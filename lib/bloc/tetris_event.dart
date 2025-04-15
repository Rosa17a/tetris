import 'package:equatable/equatable.dart';

abstract class TetrisEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Game initialization
class TetrisInitialized extends TetrisEvent {}

class TetrisGameReset extends TetrisEvent {}

// Piece movement events
class TetrisMoveLeft extends TetrisEvent {}

class TetrisMoveRight extends TetrisEvent {}

class TetrisMoveDown extends TetrisEvent {}

class TetrisRotate extends TetrisEvent {}

// Auto-repeat button actions
class TetrisStartButtonAction extends TetrisEvent {
  final String action;

  TetrisStartButtonAction(this.action);

  @override
  List<Object?> get props => [action];
}

class TetrisStopButtonAction extends TetrisEvent {
  final String action;

  TetrisStopButtonAction(this.action);

  @override
  List<Object?> get props => [action];
}

// Game state events
class TetrisTogglePause extends TetrisEvent {}

class TetrisGameOver extends TetrisEvent {}

// Game logic events
class TetrisSpawnNewPiece extends TetrisEvent {}

class TetrisLockPiece extends TetrisEvent {}

class TetrisClearLines extends TetrisEvent {
  final List<int> linesToClear;

  TetrisClearLines(this.linesToClear);

  @override
  List<Object?> get props => [linesToClear];
}

// Animation events
class TetrisFlashLines extends TetrisEvent {
  final bool isFlashing;

  TetrisFlashLines(this.isFlashing);

  @override
  List<Object?> get props => [isFlashing];
}

class TetrisIncrementFlashCount extends TetrisEvent {}

// Soft drop events
class TetrisToggleSoftDrop extends TetrisEvent {
  final bool enabled;

  TetrisToggleSoftDrop(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

// Timer events
class TetrisTimerTick extends TetrisEvent {}

class TetrisResetLastScoreChange extends TetrisEvent {}