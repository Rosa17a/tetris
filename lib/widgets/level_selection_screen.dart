import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/tetris_bloc.dart';
import '../bloc/tetris_state.dart';

class LevelSelectionScreen extends StatelessWidget {
  final Function(int) onLevelSelected;
  final int lineCount;

  const LevelSelectionScreen({
    super.key,
    required this.onLevelSelected,
    this.lineCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: BlocBuilder<TetrisBloc, TetrisState>(
          builder: (context, state) {
            return Center(
              child: Container(
                width: 600,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.purple, width: 4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top Bar - Game Title
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 2),
                        ),
                        child: const Text(
                          'TETRIS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PressStart2P',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Level Select Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'LEVEL',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'PressStart2P',
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Level selection grid
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: List.generate(
                                      5,
                                      (index) => _LevelButton(
                                        level: index,
                                        onSelected: onLevelSelected,
                                        isSelected:
                                            state.startingLevel == index,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: List.generate(
                                      5,
                                      (index) => _LevelButton(
                                        level: index + 5,
                                        onSelected: onLevelSelected,
                                        isSelected:
                                            state.startingLevel == index + 5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Line Count Display
                              
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Scoreboard Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      child: Column(
                        children: [
                          // Headers
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'NAME',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'PressStart2P',
                                ),
                              ),
                              Text(
                                'SCORE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'PressStart2P',
                                ),
                              ),
                              Text(
                                'LNS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'PressStart2P',
                                ),
                              ),
                              Text(
                                'LV',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'PressStart2P',
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white),
                          if (state.highScores.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'NO SCORES YET',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'PressStart2P',
                                ),
                              ),
                            )
                          else
                            ...state.highScores.map((entry) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        entry.name.padRight(8),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'PressStart2P',
                                        ),
                                      ),
                                      Text(
                                        entry.score.toString().padLeft(7, '0'),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'PressStart2P',
                                        ),
                                      ),
                                      Text(
                                        entry.lines.toString().padLeft(3, '0'),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'PressStart2P',
                                        ),
                                      ),
                                      Text(
                                        entry.level.toString().padLeft(2, '0'),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'PressStart2P',
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LevelButton extends StatelessWidget {
  final int level;
  final Function(int) onSelected;
  final bool isSelected;

  const _LevelButton({
    required this.level,
    required this.onSelected,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () => onSelected(level),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? Colors.yellow : Colors.white,
            border: Border.all(
              color: isSelected ? Colors.yellow : Colors.grey,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              level.toString(),
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'PressStart2P',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
