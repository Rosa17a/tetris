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
    required this.onResume,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF00FF9F),
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          // Grid
          SizedBox(
            width: width,
            height: height,
            child: Stack(
              children: [
                // Grid
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 10,
                  ),
                  itemCount: 200,
                  itemBuilder: (context, index) {
                    final row = index ~/ 10;
                    final col = index % 10;
                    final isFilled = grid[row][col] == 1;
                    final shouldShowShading =
                        isFilled && !isFlashing && gridPieces[row][col] != null;
                    final isFlashingRow =
                        flashingLines.contains(row) && isFlashing;
                    final pieceType = gridPieces[row][col];

                    return Container(
                      decoration: BoxDecoration(
                        color: isFilled
                            ? isFlashingRow
                                ? Colors.white
                                : pieceType?.getColor(level) ?? Colors.blue
                            : Colors.black,
                        border: shouldShowShading
                            ? null
                            : Border.all(
                                color: const Color(0xFF111111),
                                width: 1,
                              ),
                      ),
                      child: shouldShowShading
                          ? PieceShading(pieceType: pieceType!)
                          : null,
                    );
                  },
                ),
                // Current piece
                if (!isGameOver)
                  Positioned(
                    left: currentX * blockSize,
                    top: currentY * blockSize,
                    child: Column(
                      children: currentPiece.map((row) {
                        return Row(
                          children: row.map((cell) {
                            return Container(
                              width: blockSize,
                              height: blockSize,
                              decoration: BoxDecoration(
                                color: cell == 1
                                    ? currentPieceType.getColor(level)
                                    : Colors.transparent,
                              ),
                              child: cell == 1
                                  ? PieceShading(pieceType: currentPieceType)
                                  : null,
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
          // Overlays
          if (isPaused) PauseOverlay(onResume: onResume),
          if (isGameOver)
            GameOverOverlay(
              score: score,
              onRestart: onRestart,
            )
        ],
      ),
    );
  }
}
