import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetris_nes/app.dart';
import 'package:tetris_nes/services/theme_service.dart';

void main() async {
  // Lock app to portrait mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize theme manager
  await ThemeService().initialize();

  runApp(const TetrisApp());
}
