import 'package:equatable/equatable.dart';
import 'package:tetris_nes/models/tetromino_piece.dart';
import 'package:tetris_nes/models/types.dart';

class TetrisState extends Equatable {
  final GridMatrix grid;
  final GridPiecesMatrix gridPieces;
  final PieceMatrix currentPiece;
  final TetrominoPiece currentPieceType;
  final PieceMatrix nextPiece;
  final TetrominoPiece nextPieceType;
  final int currentX;
  final int currentY;
  final int score;
  final int lastScoreChange;
  final int lines;
  final int level;
  final int fallSpeed;
  final bool isPaused;
  final bool isGameOver;
  final bool isSoftDropping;
  final List<int> flashingLines;
  final bool isFlashing;
  final int flashCount;
  final int consecutiveTetris;

  const TetrisState({
    required this.grid,
    required this.gridPieces,
    required this.currentPiece,
    required this.currentPieceType,
    required this.nextPiece,
    required this.nextPieceType,
    required this.currentX,
    required this.currentY,
    required this.score,
    required this.lastScoreChange,
    required this.lines,
    required this.level,
    required this.fallSpeed,
    required this.isPaused,
    required this.isGameOver,
    required this.isSoftDropping,
    required this.flashingLines,
    required this.isFlashing,
    required this.flashCount,
    required this.consecutiveTetris,
  });

  // Initial state of the game
  factory TetrisState.initial() {
    return TetrisState(
      grid: List.generate(20, (_) => List.filled(10, 0)),
      gridPieces: List.generate(20, (_) => List.filled(10, null)),
      currentPiece: const [],
      currentPieceType: TetrominoPiece.I,
      nextPiece: const [],
      nextPieceType: TetrominoPiece.I,
      currentX: 0,
      currentY: 0,
      score: 0,
      lastScoreChange: 0,
      lines: 0,
      level: 0,
      fallSpeed: 800,
      isPaused: false,
      isGameOver: false,
      isSoftDropping: false,
      flashingLines: const [],
      isFlashing: false,
      flashCount: 0,
      consecutiveTetris: 0,
    );
  }

  // Copy with method for immutability
  TetrisState copyWith({
    GridMatrix? grid,
    GridPiecesMatrix? gridPieces,
    PieceMatrix? currentPiece,
    TetrominoPiece? currentPieceType,
    PieceMatrix? nextPiece,
    TetrominoPiece? nextPieceType,
    int? currentX,
    int? currentY,
    int? score,
    int? lastScoreChange,
    int? lines,
    int? level,
    int? fallSpeed,
    bool? isPaused,
    bool? isGameOver,
    bool? isSoftDropping,
    List<int>? flashingLines,
    bool? isFlashing,
    int? flashCount,
    int? consecutiveTetris,
  }) {
    return TetrisState(
      grid: grid ?? this.grid,
      gridPieces: gridPieces ?? this.gridPieces,
      currentPiece: currentPiece ?? this.currentPiece,
      currentPieceType: currentPieceType ?? this.currentPieceType,
      nextPiece: nextPiece ?? this.nextPiece,
      nextPieceType: nextPieceType ?? this.nextPieceType,
      currentX: currentX ?? this.currentX,
      currentY: currentY ?? this.currentY,
      score: score ?? this.score,
      lastScoreChange: lastScoreChange ?? this.lastScoreChange,
      lines: lines ?? this.lines,
      level: level ?? this.level,
      fallSpeed: fallSpeed ?? this.fallSpeed,
      isPaused: isPaused ?? this.isPaused,
      isGameOver: isGameOver ?? this.isGameOver,
      isSoftDropping: isSoftDropping ?? this.isSoftDropping,
      flashingLines: flashingLines ?? this.flashingLines,
      isFlashing: isFlashing ?? this.isFlashing,
      flashCount: flashCount ?? this.flashCount,
      consecutiveTetris: consecutiveTetris ?? this.consecutiveTetris,
    );
  }

  @override
  List<Object?> get props => [
        grid,
        gridPieces,
        currentPiece,
        currentPieceType,
        nextPiece,
        nextPieceType,
        currentX,
        currentY,
        score,
        lastScoreChange,
        lines,
        level,
        fallSpeed,
        isPaused,
        isGameOver,
        isSoftDropping,
        flashingLines,
        isFlashing,
        flashCount,
        consecutiveTetris,
      ];
}
