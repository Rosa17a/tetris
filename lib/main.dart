import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetris_nes/app.dart';

void main() {
  // Lock app to portrait mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const TetrisApp());
}
