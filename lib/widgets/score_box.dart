import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScoreBox extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final VoidCallback onAnimationEnd;
  final int scoreChange;
  final bool showScoreChange;

  const ScoreBox({
    super.key,
    required this.text,
    required this.height,
    required this.width,
    required this.onAnimationEnd,
    required this.scoreChange,
    required this.showScoreChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.symmetric(
          horizontal: height * 0.12, vertical: height * 0.08),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF00FF9F),
          width: 2,
        ),
      ),
      child: Row(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: text
              .split('\n')
              .map((line) => Text(
                    line,
                    style: GoogleFonts.pressStart2p(
                      fontSize: height * 0.2,
                      color: const Color(0xFF00FF9F),
                    ),
                  ))
              .toList(),
        ),
        const Spacer(),
        if (showScoreChange)
          AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 500),
            onEnd: onAnimationEnd,
            child: Text(
            '+$scoreChange',
            style: GoogleFonts.pressStart2p(
              color:  Colors.white,// make 
              fontSize: height * 0.21,
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
        )
      ]),
    );
  }
}
