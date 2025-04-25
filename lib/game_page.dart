import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tetris_nes/bloc/tetris_bloc.dart';
import 'package:tetris_nes/bloc/tetris_event.dart';
import 'package:tetris_nes/bloc/tetris_state.dart';
import 'package:tetris_nes/routes.dart';
import 'package:tetris_nes/widgets/control_button.dart';
import 'package:tetris_nes/widgets/game_board.dart';
import 'package:tetris_nes/widgets/lines_count_box.dart';
import 'package:tetris_nes/widgets/level_box.dart';
import 'package:tetris_nes/widgets/next_piece_box.dart';
import 'package:tetris_nes/widgets/score_box.dart';
import 'package:tetris_nes/widgets/speed_box.dart';
import 'package:tetris_nes/widgets/top_box.dart';
import 'package:tetris_nes/widgets/level_selection_screen.dart';
import 'package:tetris_nes/widgets/high_score_input_screen.dart';

class TetrisGame extends StatefulWidget {
  const TetrisGame({super.key});

  @override
  State<TetrisGame> createState() => _TetrisGameState();
}

class _TetrisGameState extends State<TetrisGame> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    // Initialize the game when the page is loaded
    context.read<TetrisBloc>().add(TetrisInitialized());
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: KeyboardListener(
          focusNode: _focusNode,
          autofocus: true,
          onKeyEvent: _handleKeyEvent,
          child: LayoutBuilder(builder: (context, constraints) {
            final availableHeight = constraints.maxHeight;
            final availableWidth = constraints.maxWidth;

            // Calculate sizes to fit within available space
            final maxPossibleGameHeight = availableHeight -
                (availableHeight *
                    0.15); // Reserve 15% for top bar and controls
            final desiredGameWidth = availableWidth * 0.65;
            final maxGameWidth =
                maxPossibleGameHeight / 2; // Maintain 2:1 ratio

            // Use the smaller of desired or maximum possible width, then adjust for block size
            final initialGameWidth = min(desiredGameWidth, maxGameWidth);
            // Floor dimensions to avoid sub-pixel issues
            final gameWidth = initialGameWidth.floorToDouble();
            final gameHeight = (gameWidth * 2).floorToDouble();
            final blockSize = (gameWidth / 10).floorToDouble();
            const borderWidth = 2.0;

            // Size other elements relative to block size and floor them
            final buttonSize = (blockSize * 3.5).floorToDouble();
            final topBarHeight = (blockSize * 2.2).floorToDouble();
            final statsWidth = (gameWidth * 0.35).floorToDouble();

            // Gaps (floored)
            final verticalGap = (blockSize * 0.2).floorToDouble();
            final horizontalGap = (blockSize * 0.2).floorToDouble();

            // Total width including game, stats, border, and gap (floored components)
            final totalWidth =
                (gameWidth + statsWidth + horizontalGap + (borderWidth * 2))
                    .floorToDouble();

            // Stats boxes (using floored dimensions)
            final statsBoxHeight =
                ((gameHeight - (verticalGap * 3)) / 4).floorToDouble();

            return BlocBuilder<TetrisBloc, TetrisState>(
              builder: (context, state) {
                // Show level selection only at the start of the game
                if (state.score == 0 &&
                    state.lines == 0 &&
                    state.level == 0 &&
                    state.startingLevel != 0) {
                  return LevelSelectionScreen(
                    onLevelSelected: (level) {
                      context
                          .read<TetrisBloc>()
                          .add(TetrisSetStartingLevel(level));
                    },
                  );
                }

                // Show high score input screen if game is over and it's a high score
                if (state.isGameOver &&
                    state.isHighScore &&
                    state.pendingHighScoreName != null) {
                  return HighScoreInputScreen(
                    score: state.score,
                    lines: state.lines,
                    level: state.level,
                    onNameSubmitted: (name) {
                      context
                          .read<TetrisBloc>()
                          .add(TetrisSubmitHighScoreName(name));
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.levelSelection);
                    },
                  );
                }

                return Container(
                  width: availableWidth,
                  height: availableHeight,
                  color: Colors.black,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Top bar with scores and pause
                        Container(
                          width: totalWidth,
                          height: topBarHeight,
                          margin: EdgeInsets.only(bottom: verticalGap),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BlocBuilder<TetrisBloc, TetrisState>(
                                builder: (context, state) {
                                  return TopBox(
                                    text:
                                        'HISCORE\n${state.highScore.toString().padLeft(6, '0')}',
                                    height: topBarHeight,
                                    width: totalWidth * 0.32,
                                  );
                                },
                              ),
                              BlocBuilder<TetrisBloc, TetrisState>(
                                  builder: (context, state) {
                                return ScoreBox(
                                  text:
                                      'SCORE\n${state.score.toString().padLeft(6, '0')}',
                                  height: topBarHeight,
                                  width: totalWidth * 0.45,
                                  onAnimationEnd: () {
                                    // Only reset score change if not soft dropping
                                    if (!state.isSoftDropping) {
                                      context
                                          .read<TetrisBloc>()
                                          .add(TetrisResetLastScoreChange());
                                    }
                                  },
                                  scoreChange: state.lastScoreChange,
                                  showScoreChange: state.isSoftDropping ||
                                      state.lastScoreChange > 0,
                                );
                              }),
                              BlocBuilder<TetrisBloc, TetrisState>(
                                  builder: (context, state) {
                                return TopBox(
                                  text: state.isPaused ? '▶' : '❚❚',
                                  height: topBarHeight,
                                  width: totalWidth * 0.2,
                                  isButton: true,
                                  onTap: state.isGameOver
                                      ? null
                                      : () => context
                                          .read<TetrisBloc>()
                                          .add(TetrisTogglePause()),
                                );
                              }),
                            ],
                          ),
                        ),
                        // Main game area
                        SizedBox(
                          height: gameHeight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BlocBuilder<TetrisBloc, TetrisState>(
                                builder: (context, state) {
                                  return GameBoard(
                                    width: gameWidth,
                                    height: gameHeight,
                                    blockSize: blockSize,
                                    grid: state.grid,
                                    gridPieces: state.gridPieces,
                                    currentPiece: state.currentPiece,
                                    currentPieceType: state.currentPieceType,
                                    currentX: state.currentX,
                                    currentY: state.currentY,
                                    level: state.level,
                                    flashingLines: state.flashingLines,
                                    isFlashing: state.isFlashing,
                                    isPaused: state.isPaused,
                                    isGameOver: state.isGameOver,
                                    score: state.score,
                                    highScore: state.highScore,
                                    onResume: () => context
                                        .read<TetrisBloc>()
                                        .add(TetrisTogglePause()),
                                    onRestart: () =>
                                        Navigator.pushReplacementNamed(
                                            context, AppRoutes.levelSelection),
                                    flashOriginCol: state.flashOriginCol,
                                  );
                                },
                              ),
                              SizedBox(width: horizontalGap),
                              // Stats panel
                              SizedBox(
                                width: statsWidth,
                                child: BlocBuilder<TetrisBloc, TetrisState>(
                                    builder: (context, state) {
                                  return Column(
                                    children: [
                                      NextPieceBox(
                                        height: statsBoxHeight,
                                        blockSize: blockSize,
                                        nextPiece: state.nextPiece,
                                        nextPieceType: state.nextPieceType,
                                        level: state.level,
                                      ),
                                      SizedBox(height: verticalGap),
                                      LinesCountBox(
                                        height: statsBoxHeight,
                                        blockSize: blockSize,
                                        lines: state.lines,
                                      ),
                                      SizedBox(height: verticalGap),
                                      LevelBox(
                                        height: statsBoxHeight,
                                        blockSize: blockSize,
                                        level: state.level,
                                      ),
                                      SizedBox(height: verticalGap),
                                      SpeedBox(
                                        height: statsBoxHeight,
                                        blockSize: blockSize,
                                        speed: state.fallSpeed,
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: verticalGap),
                        // Controls
                        BlocBuilder<TetrisBloc, TetrisState>(
                          builder: (context, state) {
                            final isEnabled =
                                !state.isPaused && !state.isGameOver;
                            final bloc = context.read<TetrisBloc>();
                            return SizedBox(
                              height: buttonSize,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ControlButton(
                                    symbol: '←',
                                    action: 'left',
                                    size: buttonSize,
                                    isEnabled: isEnabled,
                                    onTapDown: () => bloc
                                        .add(TetrisStartButtonAction('left')),
                                    onTapUp: () => bloc
                                        .add(TetrisStopButtonAction('left')),
                                    onTapCancel: () => bloc
                                        .add(TetrisStopButtonAction('left')),
                                  ),
                                  ControlButton(
                                    symbol: '→',
                                    action: 'right',
                                    size: buttonSize,
                                    isEnabled: isEnabled,
                                    onTapDown: () => bloc
                                        .add(TetrisStartButtonAction('right')),
                                    onTapUp: () => bloc
                                        .add(TetrisStopButtonAction('right')),
                                    onTapCancel: () => bloc
                                        .add(TetrisStopButtonAction('right')),
                                  ),
                                  ControlButton(
                                    symbol: '↓',
                                    action: 'down',
                                    size: buttonSize,
                                    isEnabled: isEnabled,
                                    onTapDown: () => bloc
                                        .add(TetrisStartButtonAction('down')),
                                    onTapUp: () => bloc
                                        .add(TetrisStopButtonAction('down')),
                                    onTapCancel: () => bloc
                                        .add(TetrisStopButtonAction('down')),
                                  ),
                                  ControlButton(
                                    symbol: '↻',
                                    action: 'rotate',
                                    size: buttonSize,
                                    isEnabled: isEnabled,
                                    onTapDown: () => bloc.add(TetrisRotate()),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.space) {
        if (!context.read<TetrisBloc>().state.isGameOver) {
          context.read<TetrisBloc>().add(TetrisTogglePause());
        }
        return;
      }

      final state = context.read<TetrisBloc>().state;
      if (!state.isPaused && !state.isGameOver) {
        switch (event.logicalKey) {
          case LogicalKeyboardKey.arrowLeft:
            context.read<TetrisBloc>().add(TetrisStartButtonAction('left'));
            break;
          case LogicalKeyboardKey.arrowRight:
            context.read<TetrisBloc>().add(TetrisStartButtonAction('right'));
            break;
          case LogicalKeyboardKey.arrowDown:
            context.read<TetrisBloc>().add(TetrisStartButtonAction('down'));
            break;
          case LogicalKeyboardKey.arrowUp:
            context.read<TetrisBloc>().add(TetrisRotate());
            break;
        }
      }
    } else if (event is KeyUpEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowLeft:
          context.read<TetrisBloc>().add(TetrisStopButtonAction('left'));
          break;
        case LogicalKeyboardKey.arrowRight:
          context.read<TetrisBloc>().add(TetrisStopButtonAction('right'));
          break;
        case LogicalKeyboardKey.arrowDown:
          context.read<TetrisBloc>().add(TetrisStopButtonAction('down'));
          break;
      }
    }
  }
}
