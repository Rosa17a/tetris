import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tetris_nes/bloc/tetris_bloc.dart';
import 'package:tetris_nes/bloc/tetris_event.dart';
import 'package:tetris_nes/routes.dart';

class TetrisApp extends StatelessWidget {
  const TetrisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TetrisBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'NES Tetris',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
        ),
        initialRoute: AppRoutes.levelSelection,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
