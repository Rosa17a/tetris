import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tetris_nes/bloc/tetris_bloc.dart';
import 'package:tetris_nes/bloc/tetris_event.dart';
import 'package:tetris_nes/game_page.dart';

class TetrisApp extends StatelessWidget {
  const TetrisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NES Tetris',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TetrisBloc()..add(TetrisInitialized()),
          ),
        ],
        child: const TetrisGame(),
      ),
    );
  }
}
