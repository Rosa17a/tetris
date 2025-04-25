import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScoreBox extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final double fontSize;
  final VoidCallback onAnimationEnd;
  final int scoreChange;
  final bool showScoreChange;

  const ScoreBox({
    super.key,
    required this.text,
    required this.height,
    required this.width,
    required this.fontSize,
    required this.onAnimationEnd,
    required this.scoreChange,
    required this.showScoreChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: Colors.black,
      padding: const EdgeInsets.all(4),
      child: Container(
        color: const Color(0xFF2D2D2D),
        padding: const EdgeInsets.all(4),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              color: const Color(0xFF88F8FF),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              // Text block (e.g., "SCORE\n000123")
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: text
                    .split('\n')
                    .map((line) => Text(
                          line,
                          style: GoogleFonts.pressStart2p(
                            fontSize: fontSize,
                            color: Colors.white,
                          ),
                        ))
                    .toList(),
              ),
              const Spacer(),

              // Animated score change display
              if (showScoreChange)
                Text(
                  '+$scoreChange',
                  style: GoogleFonts.pressStart2p(
                    fontSize: fontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
