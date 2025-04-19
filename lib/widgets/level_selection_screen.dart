import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LevelSelectionScreen extends StatelessWidget {
  final Function(int) onLevelSelected;

  const LevelSelectionScreen({
    super.key,
    required this.onLevelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
     Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SELECT STARTING LEVEL',
              style: GoogleFonts.pressStart2p(
                fontSize: 20,
                color: const Color(0xFF00FF9F),
              ),
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: List.generate(10, (index) {
                return GestureDetector(
                  onTap: () {
                    onLevelSelected(index);
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF222222),
                      border: Border.all(
                        color: const Color(0xFF00FF9F),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        index.toString(),
                        style: GoogleFonts.pressStart2p(
                          fontSize: 24,
                          color: const Color(0xFF00FF9F),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    ));
  }
}
