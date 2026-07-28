import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import 'core/app_colors.dart';
import 'core/app_constants.dart';
import 'pages/home_page.dart';

class DogmaYFeRadioApp extends StatelessWidget {
  const DogmaYFeRadioApp({
    required this.audioHandler,
    super.key,
  });

  final AudioHandler audioHandler;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.navy,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.gold,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: HomePage(audioHandler: audioHandler),
    );
  }
}
