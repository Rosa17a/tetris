import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SpeedBox extends StatelessWidget {
  final double height;
  final double blockSize;
  final int speed;

  const SpeedBox({
    super.key,
    required this.height,
    required this.blockSize,
    required this.speed,
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
            'SPEED',
            style: GoogleFonts.pressStart2p(
              fontSize: blockSize * 0.5,
              color: const Color(0xFF00FF9F),
            ),
          ),
          Text(
            speed.toString(),
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
