import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HighScoreInputScreen extends StatefulWidget {
  final int score;
  final int lines;
  final int level;
  final Function(String) onNameSubmitted;

  const HighScoreInputScreen({
    super.key,
    required this.score,
    required this.lines,
    required this.level,
    required this.onNameSubmitted,
  });

  @override
  State<HighScoreInputScreen> createState() => _HighScoreInputScreenState();
}

class _HighScoreInputScreenState extends State<HighScoreInputScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Center(
          child: Container(
            width: 400,
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF800080), // Purple border
                width: 4,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text(
                  'HIGH SCORE!',
                  style: GoogleFonts.pressStart2p(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                // Score display
                Text(
                  'SCORE: ${widget.score.toString().padLeft(7, '0')}',
                  style: GoogleFonts.pressStart2p(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                // Name input
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF00FF9F),
                      width: 2,
                    ),
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLength: 8,
                    style: GoogleFonts.pressStart2p(
                      fontSize: 16,
                      color: const Color(0xFF00FF9F),
                    ),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      hintText: 'ENTER NAME',
                      hintStyle: TextStyle(
                        color: Color(0xFF00FF9F),
                      ),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        widget.onNameSubmitted(value.toUpperCase());
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Instructions
                Text(
                  'ENTER 8 LETTERS',
                  style: GoogleFonts.pressStart2p(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
