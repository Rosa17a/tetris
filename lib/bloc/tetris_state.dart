import 'package:equatable/equatable.dart';
import '../models/score_entry.dart';
import '../models/tetromino_piece.dart';

class TetrisState extends Equatable {
  final int startingLevel;
  final int level;
  final int fallSpeed;
  final int score;
  final int lines;
  final int lastScoreChange;
  final List<List<int>> grid;
  final List<List<TetrominoPiece?>> gridPieces;
  final List<List<int>> currentPiece;
  final TetrominoPiece currentPieceType;
  final List<List<int>> nextPiece;
  final TetrominoPiece nextPieceType;
  final int currentX;
  final int currentY;
  final bool isPaused;
  final bool isGameOver;
  final bool isSoftDropping;
  final List<int> flashingLines;
  final bool isFlashing;
  final int flashCount;
  final int consecutiveTetris;
  final int highScore;
  final bool isHighScore;
  final String? pendingHighScoreName;
  final List<ScoreEntry> highScores;

  const TetrisState({
    required this.startingLevel,
    required this.level,
    required this.fallSpeed,
    required this.score,
    required this.lines,
    required this.lastScoreChange,
    required this.grid,
    required this.gridPieces,
    required this.currentPiece,
    required this.currentPieceType,
    required this.nextPiece,
    required this.nextPieceType,
    required this.currentX,
    required this.currentY,
    required this.isPaused,
    required this.isGameOver,
    required this.isSoftDropping,
    required this.flashingLines,
    required this.isFlashing,
    required this.flashCount,
    required this.consecutiveTetris,
    required this.highScore,
    required this.isHighScore,
    required this.pendingHighScoreName,
    required this.highScores,
  });

  // Initial state of the game
  factory TetrisState.initial() {
    return const TetrisState(
      startingLevel: 0,
      level: 0,
      fallSpeed: 1000,
      score: 0,
      lines: 0,
      lastScoreChange: 0,
      grid: [],
      gridPieces: [],
      currentPiece: [],
      currentPieceType: TetrominoPiece.I,
      nextPiece: [],
      nextPieceType: TetrominoPiece.I,
      currentX: 0,
      currentY: 0,
      isPaused: false,
      isGameOver: false,
      isSoftDropping: false,
      flashingLines: [],
      isFlashing: false,
      flashCount: 0,
      consecutiveTetris: 0,
      highScore: 0,
      isHighScore: false,
      pendingHighScoreName: null,
      highScores: [],
    );
  }

  // Copy with method for immutability
  TetrisState copyWith({
    int? startingLevel,
    int? level,
    int? fallSpeed,
    int? score,
    int? lines,
    int? lastScoreChange,
    List<List<int>>? grid,
    List<List<TetrominoPiece?>>? gridPieces,
    List<List<int>>? currentPiece,
    TetrominoPiece? currentPieceType,
    List<List<int>>? nextPiece,
    TetrominoPiece? nextPieceType,
    int? currentX,
    int? currentY,
    bool? isPaused,
    bool? isGameOver,
    bool? isSoftDropping,
    List<int>? flashingLines,
    bool? isFlashing,
    int? flashCount,
    int? consecutiveTetris,
    int? highScore,
    bool? isHighScore,
    String? pendingHighScoreName,
    List<ScoreEntry>? highScores,
  }) {
    return TetrisState(
      startingLevel: startingLevel ?? this.startingLevel,
      level: level ?? this.level,
      fallSpeed: fallSpeed ?? this.fallSpeed,
      score: score ?? this.score,
      lines: lines ?? this.lines,
      lastScoreChange: lastScoreChange ?? this.lastScoreChange,
      grid: grid ?? this.grid,
      gridPieces: gridPieces ?? this.gridPieces,
      currentPiece: currentPiece ?? this.currentPiece,
      currentPieceType: currentPieceType ?? this.currentPieceType,
      nextPiece: nextPiece ?? this.nextPiece,
      nextPieceType: nextPieceType ?? this.nextPieceType,
      currentX: currentX ?? this.currentX,
      currentY: currentY ?? this.currentY,
      isPaused: isPaused ?? this.isPaused,
      isGameOver: isGameOver ?? this.isGameOver,
      isSoftDropping: isSoftDropping ?? this.isSoftDropping,
      flashingLines: flashingLines ?? this.flashingLines,
      isFlashing: isFlashing ?? this.isFlashing,
      flashCount: flashCount ?? this.flashCount,
      consecutiveTetris: consecutiveTetris ?? this.consecutiveTetris,
      highScore: highScore ?? this.highScore,
      isHighScore: isHighScore ?? this.isHighScore,
      pendingHighScoreName: pendingHighScoreName ?? this.pendingHighScoreName,
      highScores: highScores ?? this.highScores,
    );
  }

  @override
  List<Object?> get props => [
        startingLevel,
        level,
        fallSpeed,
        score,
        lines,
        lastScoreChange,
        grid,
        gridPieces,
        currentPiece,
        currentPieceType,
        nextPiece,
        nextPieceType,
        currentX,
        currentY,
        isPaused,
        isGameOver,
        isSoftDropping,
        flashingLines,
        isFlashing,
        flashCount,
        consecutiveTetris,
        highScore,
        isHighScore,
        pendingHighScoreName,
        highScores,
      ];
}
