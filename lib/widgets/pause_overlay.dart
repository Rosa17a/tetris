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
          // Semi-transparent overlay
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black
                .withAlpha(100), // Reduced alpha for more transparency
          ),
          // Pause text
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(200),
                border: Border.all(
                  color: const Color(0xFF00FF9F),
                  width: 2,
                ),
              ),
              child: Text(
                'PAUSED',
                style: GoogleFonts.pressStart2p(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
