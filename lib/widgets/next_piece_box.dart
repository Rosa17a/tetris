import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tetris_nes/models/tetromino_piece.dart';
import 'package:tetris_nes/models/types.dart';
import 'package:tetris_nes/widgets/piece_shading.dart';

class NextPieceBox extends StatelessWidget {
  final double height;
  final double blockSize;
  final double fontSize;
  final PieceMatrix nextPiece;
  final TetrominoPiece nextPieceType;
  final int level;

  const NextPieceBox({
    super.key,
    required this.height,
    required this.blockSize,
    required this.fontSize,
    required this.nextPiece,
    required this.nextPieceType,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(4),
      child: Container(
        color: const Color(0xFF2D2D2D),
        padding: const EdgeInsets.all(4),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              color: const Color(0xFF88F8FF), // NES cyan
              width: 2,
            ),
          ),
          padding: EdgeInsets.all(blockSize * 0.2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'NEXT',
                style: GoogleFonts.pressStart2p(
                  fontSize: fontSize,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 60,
                height: 60,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF88F8FF), width: 1),
                  color: Colors.black,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(nextPiece.length, (i) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(nextPiece[i].length, (j) {
                          return SizedBox(
                            width: 12,
                            height: 12,
                            child: nextPiece[i][j] == 1
                                ? PieceShading(
                                    piece: nextPieceType,
                                    level: level,
                                    size: 12,
                                    isFlashing: false,
                                  )
                                : null,
                          );
                        }),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}