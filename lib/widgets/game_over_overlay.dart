import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameOverOverlay extends StatelessWidget {
  final int score;
  final VoidCallback onRestart;

  const GameOverOverlay({
    super.key,
    required this.score,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withAlpha(179),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'GAME OVER',
              style: GoogleFonts.pressStart2p(
                fontSize: 20,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'SCORE: ${score.toString().padLeft(6, '0')}',
              style: GoogleFonts.pressStart2p(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTapDown: (_) => onRestart(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF222222),
                  border: Border.all(
                    color: const Color(0xFF00FF00),
                    width: 2,
                  ),
                ),
                child: Text(
                  'RESTART',
                  style: GoogleFonts.pressStart2p(
                    fontSize: 14,
                    color: const Color(0xFF00FF00),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
