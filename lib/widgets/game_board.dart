import 'package:flutter/material.dart';
import 'package:tetris_nes/models/tetromino_piece.dart';
import 'package:tetris_nes/models/types.dart';
import 'package:tetris_nes/widgets/game_over_overlay.dart';
import 'package:tetris_nes/widgets/pause_overlay.dart';
import 'package:tetris_nes/widgets/piece_shading.dart';

class GameBoard extends StatelessWidget {
  final double width;
  final double height;
  final double blockSize;
  final GridMatrix grid;
  final GridPiecesMatrix gridPieces;
  final PieceMatrix currentPiece;
  final TetrominoPiece currentPieceType;
  final int currentX;
  final int currentY;
  final int level;
  final List<int> flashingLines;
  final bool isFlashing;
  final bool isPaused;
  final bool isGameOver;
  final int score;
  final int highScore;
  final int? flashOriginCol;
  final VoidCallback onResume;
  final VoidCallback onRestart;

  const GameBoard({
    super.key,
    required this.width,
    required this.height,
    required this.blockSize,
    required this.grid,
    required this.gridPieces,
    required this.currentPiece,
    required this.currentPieceType,
    required this.currentX,
    required this.currentY,
    required this.level,
    required this.flashingLines,
    required this.isFlashing,
    required this.isPaused,
    required this.isGameOver,
    required this.score,
    required this.highScore,
    required this.onResume,
    required this.onRestart,
    required this.flashOriginCol,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Outer black border
      color: Colors.black,
      padding: const EdgeInsets.all(4), // padding for dark gray
      child: Container(
        // Dark gray border
        color: const Color(0xFF2D2D2D),
        padding: const EdgeInsets.all(4), // padding for cyan
        child: Container(
          // Cyan border (NES blue)
          decoration: BoxDecoration(
            color: Colors.black, // game background
            border: Border.all(
              color: const Color(0xFF88F8FF), // NES cyan-blue
              width: 4,
            ),
          ),
          width: width + 2, // include grid spacing
          height: height + 2,
          child: Stack(
            children: [
              // Entire game content
              SizedBox(
                width: width,
                height: height,
                child: Stack(
                  children: [
                    // 🟦 Grid of locked pieces
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 10,
                      ),
                      itemCount: 200,
                      itemBuilder: (context, index) {
                        final row = index ~/ 10;
                        final col = index % 10;
                        final isFilled = grid[row][col] == 1;
                        final isFlashingRow =
                            flashingLines.contains(row) && isFlashing;
                        final pieceType = gridPieces[row][col];

                        final distanceFromOrigin =
                            (col - (flashOriginCol ?? 4)).abs();
                        const delayPerStep = 30;
                        final flashDelay = Duration(
                          milliseconds:
                              (distanceFromOrigin * delayPerStep).round(),
                        );

                        if (isFilled && pieceType != null) {
                          return PieceShading(
                            piece: pieceType,
                            level: level,
                            size: blockSize,
                            isFlashing: isFlashingRow,
                            flashDelay: flashDelay,
                          );
                        } else {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(
                                color: const Color(0xFF111111),
                                width: 1,
                              ),
                            ),
                          );
                        }
                      },
                    ),

                    // 🟨 Current falling piece
                    if (!isGameOver)
                      Positioned(
                        left: currentX * blockSize,
                        top: currentY * blockSize,
                        child: Column(
                          children: currentPiece.map((row) {
                            final rowIndex = currentPiece.indexOf(row);
                            return Row(
                              children: row.map((cell) {
                                final currentRow = currentY + rowIndex;
                                final isFlashingRow =
                                    flashingLines.contains(currentRow) &&
                                        isFlashing;

                                return SizedBox(
                                  width: blockSize,
                                  height: blockSize,
                                  child: cell == 1
                                      ? PieceShading(
                                          piece: currentPieceType,
                                          level: level,
                                          size: blockSize,
                                          isFlashing: isFlashingRow,
                                          flashDelay: Duration.zero,
                                        )
                                      : null,
                                );
                              }).toList(),
                            );
                          }).toList(),
                        ),
                      ),

                    // ⚪ Global screen flash overlay (NES-style)
                    if (isFlashing)
                      AnimatedOpacity(
                        opacity: 1,
                        duration: const Duration(milliseconds: 60),
                        child: Container(
                          width: width,
                          height: height,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                  ],
                ),
              ),

              // 🟥 Pause overlay
              if (isPaused) PauseOverlay(onResume: onResume),

              // ⛔ Game over overlay
              if (isGameOver)
                GameOverOverlay(
                  score: score,
                  highScore: highScore,
                  onRestart: onRestart,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
