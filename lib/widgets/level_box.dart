import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LevelBox extends StatelessWidget {
  final double height;
  final double blockSize;
  final double fontSize;
  final int level;

  const LevelBox({
    super.key,
    required this.height,
    required this.blockSize,
    required this.fontSize,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Outer black NES-style border
      padding: const EdgeInsets.all(4),
      child: Container(
        color: const Color(0xFF2D2D2D), // Middle dark gray border
        padding: const EdgeInsets.all(4),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              color: const Color(0xFF88F8FF), // Inner NES cyan border
              width: 2,
            ),
          ),
          height: height,
          padding: EdgeInsets.all(blockSize * 0.2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'LEVEL',
                style: GoogleFonts.pressStart2p(
                  fontSize: fontSize,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                level.toString().padLeft(2, '0'),
                style: GoogleFonts.pressStart2p(
                  fontSize: fontSize,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}