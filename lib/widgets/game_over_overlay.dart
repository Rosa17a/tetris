import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameOverOverlay extends StatelessWidget {
  final int score;
  final int highScore;
  final VoidCallback onRestart;

  const GameOverOverlay({
    super.key,
    required this.score,
    required this.highScore,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'GAME OVER',
              style: GoogleFonts.pressStart2p(
                fontSize: 20,
                color: Colors.redAccent,
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
            const SizedBox(height: 8),
            Text(
              'HISCORE: ${highScore.toString().padLeft(6, '0')}',
              style: GoogleFonts.pressStart2p(
                fontSize: 14,
                color: const Color(0xFF88F8FF),
              ),
            ),
            const SizedBox(height: 32),

            // ✅ NES-style border only around the button
            GestureDetector(
              onTapDown: (_) => onRestart(),
              child: Container(
                padding: const EdgeInsets.all(4), // Outer black
                color: Colors.black,
                child: Container(
                  padding: const EdgeInsets.all(4), // Middle gray
                  color: const Color(0xFF2D2D2D),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      border: Border.all(
                        color: const Color(0xFF00FF00), // Green NES style
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}