import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tetris_nes/models/tetromino_piece.dart';
import 'package:tetris_nes/models/types.dart';
import 'package:tetris_nes/widgets/piece_shading.dart';

class NextPieceBox extends StatelessWidget {
  final double height;
  final double blockSize;
  final PieceMatrix nextPiece;
  final TetrominoPiece nextPieceType;
  final int level;

  const NextPieceBox({
    super.key,
    required this.height,
    required this.blockSize,
    required this.nextPiece,
    required this.nextPieceType,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF00FF9F),
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
              fontSize: blockSize * 0.5,
              color: const Color(0xFF00FF9F),
            ),
          ),
          Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF00FF9F), width: 1),
              color: Colors.black,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(nextPiece.length, (i) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(nextPiece[i].length, (j) {
                      return Container(
                        width: 12,
                        height: 12,
                        margin: const EdgeInsets.all(0.5),
                        decoration: BoxDecoration(
                          color: nextPiece[i][j] == 1
                              ? nextPieceType.getColor(level)
                              : Colors.transparent,
                        ),
                        child: nextPiece[i][j] == 1
                            ? PieceShading(pieceType: nextPieceType)
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
    );
  }
}
