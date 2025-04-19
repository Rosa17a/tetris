import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tetris_nes/bloc/tetris_bloc.dart';
import 'package:tetris_nes/bloc/tetris_event.dart';
import 'package:tetris_nes/game_page.dart';
import 'package:tetris_nes/widgets/level_selection_screen.dart';

class AppRoutes {
  static const String levelSelection = '/level-selection';
  static const String game = '/game';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case levelSelection:
        return MaterialPageRoute(
          builder: (context) => LevelSelectionScreen(
            onLevelSelected: (level) {
              context.read<TetrisBloc>().add(TetrisSetStartingLevel(level));
              Navigator.pushReplacementNamed(context, AppRoutes.game);
            },
          ),
        );
      case game:
        return MaterialPageRoute(
          builder: (_) => const TetrisGame(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => LevelSelectionScreen(
            onLevelSelected: (level) {
              context.read<TetrisBloc>().add(TetrisSetStartingLevel(level));
              Navigator.pushReplacementNamed(context, AppRoutes.game);
            },
          ),
        );
    }
  }
}
