import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tetris_nes/bloc/tetris_event.dart';
import 'package:tetris_nes/bloc/tetris_state.dart';
import 'package:tetris_nes/models/tetromino_piece.dart';
import 'package:tetris_nes/models/types.dart';

class TetrisBloc extends Bloc<TetrisEvent, TetrisState> {
  final Random _random = Random();
  Timer? _fallTimer;
  Timer? _flashTimer;
  Timer? _autoRepeatTimer;
  Timer? _speedIncreaseTimer;
  String? _currentAction;
  int _currentRepeatDelay = 10;
  static const int _autoRepeatDelay = 300;
  static const int _minRepeatDelay = 50;
  static const String _highScoreKey = 'tetris_high_score';
  SharedPreferences? _prefs;

  final TetrominoMatrix tetrominoes = [
    // I piece (Light blue) - straight line
    [
      [0, 0, 0, 0],
      [1, 1, 1, 1],
      [0, 0, 0, 0],
      [0, 0, 0, 0],
    ],
    // O piece (Yellow) - square
    [
      [1, 1],
      [1, 1],
    ],
    // T piece (Purple) - T shape
    [
      [0, 1, 0],
      [1, 1, 1],
      [0, 0, 0],
    ],
    // S piece (Green) - S shape
    [
      [0, 1, 1],
      [1, 1, 0],
      [0, 0, 0],
    ],
    // Z piece (Red) - Z shape
    [
      [1, 1, 0],
      [0, 1, 1],
      [0, 0, 0],
    ],
    // J piece (Blue) - J shape
    [
      [1, 0, 0],
      [1, 1, 1],
      [0, 0, 0],
    ],
    // L piece (Orange) - L shape
    [
      [0, 0, 1],
      [1, 1, 1],
      [0, 0, 0],
    ],
  ];

  final List<TetrominoPiece> pieceTypes = [
    TetrominoPiece.I,
    TetrominoPiece.O,
    TetrominoPiece.T,
    TetrominoPiece.S,
    TetrominoPiece.Z,
    TetrominoPiece.J,
    TetrominoPiece.L,
  ];

  TetrisBloc() : super(TetrisState.initial()) {
    // Initialize shared preferences
    _initPrefs();

    // Game initialization
    on<TetrisInitialized>(_onTetrisInitialized);
    on<TetrisGameReset>(_onTetrisGameReset);

    // Piece movement
    on<TetrisMoveLeft>(_onTetrisMoveLeft);
    on<TetrisMoveRight>(_onTetrisMoveRight);
    on<TetrisMoveDown>(_onTetrisMoveDown);
    on<TetrisRotate>(_onTetrisRotate);

    // Button actions
    on<TetrisStartButtonAction>(_onTetrisStartButtonAction);
    on<TetrisStopButtonAction>(_onTetrisStopButtonAction);

    // Game state
    on<TetrisTogglePause>(_onTetrisTogglePause);
    on<TetrisGameOver>(_onTetrisGameOver);

    // Game logic
    on<TetrisSpawnNewPiece>(_onTetrisSpawnNewPiece);
    on<TetrisLockPiece>(_onTetrisLockPiece);
    on<TetrisClearLines>(_onTetrisClearLines);

    // Animation
    on<TetrisFlashLines>(_onTetrisFlashLines);
    on<TetrisIncrementFlashCount>(_onTetrisIncrementFlashCount);

    // Soft drop
    on<TetrisToggleSoftDrop>(_onTetrisToggleSoftDrop);

    // Timer
    on<TetrisTimerTick>(_onTetrisTimerTick);
    on<TetrisResetLastScoreChange>(_onTetrisResetLastScoreChange);

    // Level selection
    on<TetrisSetStartingLevel>(_onTetrisSetStartingLevel);
  }

  @override
  Future<void> close() {
    _fallTimer?.cancel();
    _flashTimer?.cancel();
    _autoRepeatTimer?.cancel();
    _speedIncreaseTimer?.cancel();
    return super.close();
  }

  // Helper Methods

  void _startFallTimer() {
    _fallTimer?.cancel();
    _fallTimer = Timer.periodic(
      Duration(milliseconds: state.isSoftDropping ? 20 : state.fallSpeed),
      (_) {
        if (!state.isPaused && !state.isGameOver) {
          add(TetrisTimerTick());
        }
      },
    );
  }

  PieceMatrix _getRandomPiece() {
    final index = _random.nextInt(tetrominoes.length);
    final piece = tetrominoes[index];
    return PieceMatrix.from(
      piece.map((row) => List<int>.from(row)),
    );
  }

  bool _checkCollision(int nextX, int nextY, List<List<int>> piece) {
    for (int y = 0; y < piece.length; y++) {
      for (int x = 0; x < piece[y].length; x++) {
        if (piece[y][x] == 1) {
          int newX = nextX + x;
          int newY = nextY + y;

          // Check boundaries
          if (newX < 0 || newX >= 10 || newY >= 20) {
            return true;
          }

          // Check collision with locked pieces
          if (newY >= 0 && state.grid[newY][newX] == 1) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void _executeAction(String action) {
    switch (action) {
      case 'left':
        add(TetrisMoveLeft());
        break;
      case 'right':
        add(TetrisMoveRight());
        break;
      case 'down':
        add(TetrisMoveDown());
        break;
    }
  }

  // Event Handlers

  void _onTetrisInitialized(
      TetrisInitialized event, Emitter<TetrisState> emit) {
    add(TetrisSpawnNewPiece());
    _startFallTimer();
  }

  void _onTetrisGameReset(TetrisGameReset event, Emitter<TetrisState> emit) {
    _fallTimer?.cancel();
    _flashTimer?.cancel();
    _autoRepeatTimer?.cancel();
    _speedIncreaseTimer?.cancel();

    // Refetch high score from storage
    _initPrefs();

    // Reset to initial state with current starting level
    emit(TetrisState.initial().copyWith(
      startingLevel: state.startingLevel,
      level: state.startingLevel,
      fallSpeed: _calculateFallSpeed(state.startingLevel),
    ));
    add(TetrisInitialized());
  }

  int _calculateFallSpeed(int level) {
    if (level <= 10) {
      return (800 * pow(0.85, level)).toInt();
    } else if (level < 29) {
      if (level >= 19) return 17;
      if (level >= 16) return 33;
      if (level >= 13) return 50;
      return (800 * pow(0.85, 10)).toInt(); // Level 11-12 speed
    } else {
      return 1; // Kill screen
    }
  }

  void _onTetrisSetStartingLevel(
      TetrisSetStartingLevel event, Emitter<TetrisState> emit) {
    final newFallSpeed = _calculateFallSpeed(event.level);
    emit(state.copyWith(
      startingLevel: event.level,
      level: event.level,
      fallSpeed: newFallSpeed,
      score: 0,
      lines: 0,
      lastScoreChange: 0,
    ));
  }

  void _onTetrisMoveLeft(TetrisMoveLeft event, Emitter<TetrisState> emit) {
    if (state.isPaused || state.isGameOver) return;

    if (!_checkCollision(
        state.currentX - 1, state.currentY, state.currentPiece)) {
      emit(state.copyWith(currentX: state.currentX - 1));
    }
  }

  void _onTetrisMoveRight(TetrisMoveRight event, Emitter<TetrisState> emit) {
    if (state.isPaused || state.isGameOver) return;

    if (!_checkCollision(
        state.currentX + 1, state.currentY, state.currentPiece)) {
      emit(state.copyWith(currentX: state.currentX + 1));
    }
  }

  void _onTetrisMoveDown(TetrisMoveDown event, Emitter<TetrisState> emit) {
    if (state.isPaused || state.isGameOver) return;

    if (!_checkCollision(
        state.currentX, state.currentY + 1, state.currentPiece)) {
      if (state.isSoftDropping) {
        // Add 1 point for each soft drop movement and show accumulated points
        final newScore = state.score + 1;
        final accumulatedPoints = state.lastScoreChange + 1;
        emit(state.copyWith(
          currentY: state.currentY + 1,
          score: newScore,
          lastScoreChange:
              accumulatedPoints, // Show accumulated points in real-time
        ));
      } else {
        emit(state.copyWith(currentY: state.currentY + 1));
      }
    } else {
      add(TetrisLockPiece());
    }
  }

  void _onTetrisRotate(TetrisRotate event, Emitter<TetrisState> emit) {
    if (state.isPaused || state.isGameOver) return;

    // I piece special case - only has 2 orientations
    if (state.currentPieceType == TetrominoPiece.I) {
      if (state.currentPiece[1][0] == 1) {
        // If horizontal
        final rotated = [
          [0, 0, 1, 0],
          [0, 0, 1, 0],
          [0, 0, 1, 0],
          [0, 0, 1, 0],
        ];

        // Try positions with smallest offset first
        if (!_checkCollision(state.currentX, state.currentY, rotated)) {
          emit(state.copyWith(currentPiece: rotated));
          return;
        }

        // Try positions with increasing offsets
        final offsets = [-1, 1, -2, 2];
        for (final offset in offsets) {
          if (!_checkCollision(
              state.currentX + offset, state.currentY, rotated)) {
            emit(state.copyWith(
              currentPiece: rotated,
              currentX: state.currentX + offset,
            ));
            return;
          }
        }
      } else {
        // If vertical
        final rotated = [
          [0, 0, 0, 0],
          [1, 1, 1, 1],
          [0, 0, 0, 0],
          [0, 0, 0, 0],
        ];

        // Try positions with smallest offset first
        if (!_checkCollision(state.currentX, state.currentY, rotated)) {
          emit(state.copyWith(currentPiece: rotated));
          return;
        }

        // Try positions with increasing offsets
        final offsets = [-1, 1, -2, 2];
        for (final offset in offsets) {
          if (!_checkCollision(
              state.currentX + offset, state.currentY, rotated)) {
            emit(state.copyWith(
              currentPiece: rotated,
              currentX: state.currentX + offset,
            ));
            return;
          }
        }
      }
      return;
    }

    // O piece doesn't rotate
    if (state.currentPieceType == TetrominoPiece.O) {
      return;
    }

    // For all other pieces, rotate clockwise
    final rotated = List.generate(
      state.currentPiece.length,
      (i) => List.generate(
        state.currentPiece.length,
        (j) => state.currentPiece[state.currentPiece.length - 1 - j][i],
      ),
    );

    // Try positions with smallest offset first
    if (!_checkCollision(state.currentX, state.currentY, rotated)) {
      emit(state.copyWith(currentPiece: rotated));
      return;
    }

    // Try positions with increasing offsets
    final offsets = [-1, 1, -2, 2];
    for (final offset in offsets) {
      if (!_checkCollision(state.currentX + offset, state.currentY, rotated)) {
        emit(state.copyWith(
          currentPiece: rotated,
          currentX: state.currentX + offset,
        ));
        return;
      }
    }
  }

  void _onTetrisStartButtonAction(
      TetrisStartButtonAction event, Emitter<TetrisState> emit) {
    if (state.isPaused || state.isGameOver) return;

    // Execute action immediately
    if (event.action == 'down') {
      // Enable soft drop and add first point
      emit(state.copyWith(
        isSoftDropping: true,
        lastScoreChange: 1,
        score: state.score + 1,
      ));
    } else {
      _executeAction(event.action);
    }

    // Set up auto-repeat with progressive speed
    _currentAction = event.action;
    _currentRepeatDelay = _autoRepeatDelay;

    _autoRepeatTimer?.cancel();
    _speedIncreaseTimer?.cancel();

    // Start auto-repeat after initial delay
    _autoRepeatTimer = Timer.periodic(
      Duration(milliseconds: _currentRepeatDelay),
      (timer) {
        if (!state.isPaused &&
            !state.isGameOver &&
            _currentAction == event.action) {
          if (event.action == 'down') {
            // Add point for each soft drop movement
            add(TetrisMoveDown());
          } else {
            _executeAction(event.action);
          }
        }
      },
    );

    // Gradually increase speed
    _speedIncreaseTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        if (!state.isPaused &&
            !state.isGameOver &&
            _currentAction == event.action) {
          _currentRepeatDelay = (_currentRepeatDelay * 0.8).toInt();
          if (_currentRepeatDelay < _minRepeatDelay) {
            _currentRepeatDelay = _minRepeatDelay;
          }

          // Restart auto-repeat timer with new delay
          _autoRepeatTimer?.cancel();
          _autoRepeatTimer = Timer.periodic(
            Duration(milliseconds: _currentRepeatDelay),
            (timer) {
              if (!state.isPaused &&
                  !state.isGameOver &&
                  _currentAction == event.action) {
                if (event.action == 'down') {
                  // Add point for each soft drop movement
                  add(TetrisMoveDown());
                } else {
                  _executeAction(event.action);
                }
              }
            },
          );
        }
      },
    );
  }

  void _onTetrisStopButtonAction(
      TetrisStopButtonAction event, Emitter<TetrisState> emit) {
    if (_currentAction == event.action) {
      if (event.action == 'down') {
        // Disable soft drop
        emit(state.copyWith(
          isSoftDropping: false,
        ));
      }
      _currentAction = null;
      _autoRepeatTimer?.cancel();
      _speedIncreaseTimer?.cancel();
    }
  }

  void _onTetrisTogglePause(
      TetrisTogglePause event, Emitter<TetrisState> emit) {
    if (state.isGameOver) return;

    final isPaused = !state.isPaused;
    emit(state.copyWith(isPaused: isPaused));

    if (isPaused) {
      // Pause the game
      _fallTimer?.cancel();
      _flashTimer?.cancel();
    } else {
      // Resume the game
      _startFallTimer();

      if (state.flashingLines.isNotEmpty) {
        // Restart flash animation
        _flashTimer?.cancel();
        _flashTimer = Timer.periodic(
          const Duration(milliseconds: 100),
          (timer) {
            add(TetrisFlashLines(!state.isFlashing));
            add(TetrisIncrementFlashCount());
          },
        );
      }
    }
  }

  void _onTetrisGameOver(TetrisGameOver event, Emitter<TetrisState> emit) {
    // Update high score before emitting game over
    _updateHighScore(state.score);
    emit(state.copyWith(isGameOver: true));

    // Cancel all timers
    _fallTimer?.cancel();
    _autoRepeatTimer?.cancel();
    _speedIncreaseTimer?.cancel();
    _flashTimer?.cancel();
  }

  void _onTetrisSpawnNewPiece(
      TetrisSpawnNewPiece event, Emitter<TetrisState> emit) {
    TetrominoPiece nextType;
    List<List<int>> next;

    if (state.nextPiece.isEmpty) {
      // If there's no next piece yet (game just started)
      next = _getRandomPiece();
      final index = tetrominoes.indexOf(tetrominoes.firstWhere(
        (piece) => piece.toString() == next.toString(),
      ));
      nextType = pieceTypes[index];
    } else {
      next = state.nextPiece;
      nextType = state.nextPieceType;
    }

    // Generate a new next piece
    final newNext = _getRandomPiece();
    final index = tetrominoes.indexOf(tetrominoes.firstWhere(
      (piece) => piece.toString() == newNext.toString(),
    ));
    final newNextType = pieceTypes[index];

    // Calculate spawn position (center of the grid)
    int spawnX = (10 - next[0].length) ~/ 2;
    int spawnY = 0;

    // Check if the piece can be placed at spawn position
    bool canSpawn = true;
    for (int y = 0; y < next.length; y++) {
      for (int x = 0; x < next[y].length; x++) {
        if (next[y][x] == 1) {
          int gridY = spawnY + y;
          int gridX = spawnX + x;

          // Check if the position is within bounds and not occupied
          if (gridX < 0 ||
              gridX >= 10 ||
              gridY >= 20 ||
              (gridY >= 0 && state.grid[gridY][gridX] == 1)) {
            canSpawn = false;
            break;
          }
        }
      }
      if (!canSpawn) break;
    }

    if (!canSpawn) {
      add(TetrisGameOver());
      return;
    }

    // Update state with new current and next pieces
    emit(state.copyWith(
      currentPiece: List<List<int>>.from(next),
      currentPieceType: nextType,
      nextPiece: newNext,
      nextPieceType: newNextType,
      currentX: spawnX,
      currentY: spawnY,
    ));
  }

  void _onTetrisLockPiece(TetrisLockPiece event, Emitter<TetrisState> emit) {
    bool reachedTop = false;

    // First check if we can lock the piece
    for (int y = 0; y < state.currentPiece.length; y++) {
      for (int x = 0; x < state.currentPiece[y].length; x++) {
        if (state.currentPiece[y][x] == 1) {
          int gridY = state.currentY + y;
          int gridX = state.currentX + x;

          // Check if piece is within valid bounds
          if (gridX < 0 || gridX >= 10 || gridY >= 20) {
            return; // Cannot lock piece if out of bounds
          }

          // Check if position is already occupied
          if (gridY >= 0 && state.grid[gridY][gridX] == 1) {
            return; // Cannot lock piece if space is occupied
          }
        }
      }
    }

    // Create new grid and gridPieces with the locked piece
    final List<List<int>> newGrid = List.generate(
      20,
      (i) => List<int>.from(state.grid[i]),
    );

    final List<List<TetrominoPiece?>> newGridPieces = List.generate(
      20,
      (i) => List<TetrominoPiece?>.from(state.gridPieces[i]),
    );

    // Lock the piece
    for (int y = 0; y < state.currentPiece.length; y++) {
      for (int x = 0; x < state.currentPiece[y].length; x++) {
        if (state.currentPiece[y][x] == 1) {
          int gridY = state.currentY + y;
          int gridX = state.currentX + x;

          // Check if piece reaches top
          if (gridY <= 0) {
            reachedTop = true;
          }

          if (gridY >= 0 && gridY < 20 && gridX >= 0 && gridX < 10) {
            newGrid[gridY][gridX] = 1;
            newGridPieces[gridY][gridX] = state.currentPieceType;
          }
        }
      }
    }

    // Update state with locked piece
    emit(state.copyWith(
      grid: newGrid,
      gridPieces: newGridPieces,
    ));

    // End game if piece reached top
    if (reachedTop) {
      add(TetrisGameOver());
      return;
    }

    // Check for completed lines
    List<int> linesToClear = [];
    for (int row = 0; row < 20; row++) {
      bool isComplete = true;
      for (int col = 0; col < 10; col++) {
        if (newGrid[row][col] == 0) {
          isComplete = false;
          break;
        }
      }
      if (isComplete) {
        linesToClear.add(row);
      }
    }

    if (linesToClear.isNotEmpty) {
      add(TetrisClearLines(linesToClear));
    } else {
      // No lines to clear, spawn next piece
      add(TetrisSpawnNewPiece());
    }
  }

  void _onTetrisClearLines(TetrisClearLines event, Emitter<TetrisState> emit) {
    // Update score based on number of lines cleared
    int baseScore = 0;
    int consecutiveTetris = state.consecutiveTetris;

    switch (event.linesToClear.length) {
      case 1:
        baseScore = 40;
        consecutiveTetris = 0;
        break;
      case 2:
        baseScore = 100;
        consecutiveTetris = 0;
        break;
      case 3:
        baseScore = 300;
        consecutiveTetris = 0;
        break;
      case 4:
        baseScore = 1200; // Tetris!
        consecutiveTetris++;
        // Bonus for consecutive Tetris
        if (consecutiveTetris > 1) {
          baseScore *= consecutiveTetris;
        }
        break;
    }

    // Apply level multiplier (NES scoring system)
    final lastScoreChange = baseScore * (state.level + 1);
    final newScore = state.score + lastScoreChange;

    // Update lines count and level (advances every 10 lines)
    final newLines = state.lines + event.linesToClear.length;
    final newLevel = newLines ~/ 10; // Level up every 10 lines

    // Update fall speed based on level (NES speed curve)
    int newFallSpeed = 800; // Default speed for level 0
    if (newLevel <= 10) {
      // Levels 1-10: Speed increases with each level
      newFallSpeed = (800 * pow(0.85, newLevel)).toInt();
    } else if (newLevel < 29) {
      // Levels 11-28: Speed only increases on specific levels
      final speedLevel = newLevel;
      if (speedLevel >= 13) {
        newFallSpeed = 50; // Level 13-15
      }
      if (speedLevel >= 16) {
        newFallSpeed = 33; // Level 16-18
      }
      if (speedLevel >= 19) {
        newFallSpeed = 17; // Level 19-28
      }
    } else {
      // Level 29+: Kill screen (1 frame per cell)
      newFallSpeed = 1;
    }

    if (event.linesToClear.length == 4) {
      // Only start flashing animation for Tetris (4 lines)
      emit(state.copyWith(
        flashingLines: event.linesToClear,
        isFlashing: true,
        flashCount: 0,
        score: newScore,
        lastScoreChange: lastScoreChange,
        lines: newLines,
        level: newLevel,
        fallSpeed: newFallSpeed,
        consecutiveTetris: consecutiveTetris,
      ));

      // Start flash animation with faster timing
      _flashTimer?.cancel();
      _flashTimer = Timer.periodic(
        const Duration(
            milliseconds: 50), // Faster flash (50ms instead of 100ms)
        (timer) {
          add(TetrisFlashLines(!state.isFlashing));
          add(TetrisIncrementFlashCount());
        },
      );
    } else {
      // For 1-3 lines, remove them immediately
      final List<List<int>> newGrid = List.generate(
        20,
        (i) => List<int>.from(state.grid[i]),
      );

      final List<List<TetrominoPiece?>> newGridPieces = List.generate(
        20,
        (i) => List<TetrominoPiece?>.from(state.gridPieces[i]),
      );

      // Remove completed lines (starting from bottom to maintain indices)
      for (int row in event.linesToClear.reversed) {
        newGrid.removeAt(row);
        newGridPieces.removeAt(row);
      }

      // Add new empty lines at the top
      for (int i = 0; i < event.linesToClear.length; i++) {
        newGrid.insert(0, List.filled(10, 0));
        newGridPieces.insert(0, List.filled(10, null));
      }

      emit(state.copyWith(
        grid: newGrid,
        gridPieces: newGridPieces,
        score: newScore,
        lastScoreChange: lastScoreChange,
        lines: newLines,
        level: newLevel,
        fallSpeed: newFallSpeed,
        consecutiveTetris: consecutiveTetris,
      ));

      // Spawn next piece immediately for 1-3 lines
      add(TetrisSpawnNewPiece());
    }
  }

  void _onTetrisFlashLines(TetrisFlashLines event, Emitter<TetrisState> emit) {
    // Create a new grid with black lines for flashing
    final List<List<int>> newGrid = List.generate(
      20,
      (i) => List<int>.from(state.grid[i]),
    );

    // Make the flashing lines black (value 2)
    for (int row in state.flashingLines) {
      for (int col = 0; col < 10; col++) {
        newGrid[row][col] = event.isFlashing ? 2 : 1;
      }
    }

    emit(state.copyWith(
      isFlashing: event.isFlashing,
      grid: newGrid,
    ));
  }

  void _onTetrisIncrementFlashCount(
      TetrisIncrementFlashCount event, Emitter<TetrisState> emit) {
    final newFlashCount = state.flashCount + 1;
    emit(state.copyWith(flashCount: newFlashCount));

    // After 6 flashes (3 on/off cycles), remove the lines
    if (newFlashCount >= 6) {
      _flashTimer?.cancel();

      final List<List<int>> newGrid = List.generate(
        20,
        (i) => List<int>.from(state.grid[i]),
      );

      final List<List<TetrominoPiece?>> newGridPieces = List.generate(
        20,
        (i) => List<TetrominoPiece?>.from(state.gridPieces[i]),
      );

      // Remove completed lines (starting from bottom to maintain indices)
      for (int row in state.flashingLines.reversed) {
        newGrid.removeAt(row);
        newGridPieces.removeAt(row);
      }

      // Add new empty lines at the top
      for (int i = 0; i < state.flashingLines.length; i++) {
        newGrid.insert(0, List.filled(10, 0));
        newGridPieces.insert(0, List.filled(10, null));
      }

      emit(state.copyWith(
        grid: newGrid,
        gridPieces: newGridPieces,
        isFlashing: false,
        flashingLines: [],
      ));

      // Restart fall timer with current fall speed
      _startFallTimer();

      // Spawn next piece
      add(TetrisSpawnNewPiece());
    }
  }

  void _onTetrisToggleSoftDrop(
      TetrisToggleSoftDrop event, Emitter<TetrisState> emit) {
    if (event.enabled) {
      // When starting soft drop, reset score change and add first point
      emit(state.copyWith(
        isSoftDropping: true,
        lastScoreChange: 1,
        score: state.score + 1,
      ));
      print('Soft drop enabled: ${state.isSoftDropping}');
    } else {
      // When stopping soft drop, just update the flag
      emit(state.copyWith(
        isSoftDropping: false,
      ));
      print('Soft drop disabled: ${state.isSoftDropping}');
    }
    _startFallTimer(); // Restart timer with new speed
  }

  void _onTetrisTimerTick(TetrisTimerTick event, Emitter<TetrisState> emit) {
    add(TetrisMoveDown());
  }

  void _onTetrisResetLastScoreChange(
      TetrisResetLastScoreChange event, Emitter<TetrisState> emit) {
    emit(state.copyWith(lastScoreChange: 0));
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final highScore = _prefs?.getInt(_highScoreKey) ?? 0;
    emit(state.copyWith(highScore: highScore));
  }

  Future<void> _updateHighScore(int score) async {
    if (score > state.highScore) {
      await _prefs?.setInt(_highScoreKey, score);
      emit(state.copyWith(highScore: score));
    }
  }
}
