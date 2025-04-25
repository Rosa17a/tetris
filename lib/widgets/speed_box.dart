import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SpeedBox extends StatelessWidget {
  final double height;
  final double blockSize;
  final double fontSize;
  final int speed;

  const SpeedBox({
    super.key,
    required this.height,
    required this.blockSize,
    required this.speed,
    required this.fontSize,
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
                'SPEED',
                style: GoogleFonts.pressStart2p(
                  fontSize: fontSize,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                speed.toString(),
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