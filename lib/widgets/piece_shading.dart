import 'package:flutter/material.dart';
import 'package:tetris_nes/models/tetromino_piece.dart';

class PieceShading extends StatelessWidget {
  final TetrominoPiece piece;
  final int level;
  final double size;
  final bool isFlashing;

  const PieceShading({
    super.key,
    required this.piece,
    required this.level,
    this.size = 10,
    this.isFlashing = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = piece.getVisualStyle();
    final theme =
        tetrominoThemes[piece]![level % tetrominoThemes[piece]!.length];
    final borderSize = size * 0.15;
    final highlightDotSize = size * 0.15;

    return SizedBox(
      width: size,
      height: size,
      child: Container(
        color: Colors.black, // background / gap simulation
        padding: EdgeInsets.all(borderSize / 4),
        alignment: Alignment.center,
        child: isFlashing
            // When flashing, show a solid white block
            ? Container(
                width: size - borderSize,
                height: size - borderSize,
                color: Colors.white,
              )
            // When not flashing, show the normal shaded block
            : Stack(
                children: [
                  // Inner block with border
                  Container(
                    width: size - borderSize,
                    height: size - borderSize,
                    decoration: BoxDecoration(
                      color: theme.fill,
                      border:
                          Border.all(color: theme.border, width: borderSize),
                    ),
                  ),

                  if (style == BlockVisualStyle.angledHighlight)
                  Positioned(
                    top: highlightDotSize,
                    left: highlightDotSize,
                    child: ClipPath(
                      clipper: _TopLeftTriangleClipper(),
                      child: Container(
                        width: highlightDotSize * 2,
                        height: highlightDotSize * 2,
                        color: Colors.white
                      ),
                    ),
                  ),

                  // Style-specific highlights
                  if (style == BlockVisualStyle.classicDot || style == BlockVisualStyle.angledHighlight )
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: highlightDotSize,
                        height: highlightDotSize,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class _TopLeftTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width / 2, size.height / 2)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
