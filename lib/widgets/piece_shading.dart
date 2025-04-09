import 'package:flutter/material.dart';
import 'package:tetris_nes/models/tetromino_piece.dart';

class PieceShading extends StatelessWidget {
  final TetrominoPiece pieceType;

  const PieceShading({
    super.key,
    required this.pieceType,
  });

  @override
  Widget build(BuildContext context) {
    final shadingColors = pieceType.getShadingColors();
    return Stack(
      children: [
        // Top-left corner highlight
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 0.7,
                colors: [
                  Colors.white,
                  Colors.transparent,
                ],
                stops: [0.0, 1.0],
              ),
            ),
          ),
        ),

        // Top border (thicker)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 4,
            child: ColoredBox(
              color: shadingColors[0],
            ),
          ),
        ),

        // Left border (thicker)
        Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          child: SizedBox(
            width: 4,
            child: ColoredBox(
              color: shadingColors[0],
            ),
          ),
        ),

        // Bottom border
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 1,
            child: ColoredBox(
              color: shadingColors[1],
            ),
          ),
        ),

        // Right border
        Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          child: SizedBox(
            width: 1,
            child: ColoredBox(
              color: shadingColors[1],
            ),
          ),
        ),
      ],
    );
  }
}
