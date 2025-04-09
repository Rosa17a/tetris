import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LinesCountBox extends StatelessWidget {
  final double height;
  final double blockSize;
  final int lines;

  const LinesCountBox({
    super.key,
    required this.height,
    required this.blockSize,
    required this.lines,
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
            'LINES',
            style: GoogleFonts.pressStart2p(
              fontSize: blockSize * 0.5,
              color: const Color(0xFF00FF9F),
            ),
          ),
          Text(
            lines.toString().padLeft(3, '0'),
            style: GoogleFonts.pressStart2p(
              fontSize: blockSize * 0.5,
              color: const Color(0xFF00FF9F),
            ),
          ),
        ],
      ),
    );
  }
}
