import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PauseOverlay extends StatelessWidget {
  final VoidCallback onResume;

  const PauseOverlay({
    super.key,
    required this.onResume,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onResume(),
      child: Stack(
        children: [
          // 🔲 Dimmed background
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.7),
          ),

          // 🎮 Centered NES-style box
          Center(
            child: Container(
              padding: const EdgeInsets.all(4), // Outer black border
              color: Colors.black,
              child: Container(
                padding: const EdgeInsets.all(4), // Middle gray border
                color: const Color(0xFF2D2D2D),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: const Color(0xFF88F8FF), // NES cyan
                      width: 2,
                    ),
                  ),
                  child: Text(
                    'PAUSED',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.pressStart2p(
                      fontSize: 20,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}