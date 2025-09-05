import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/moods/presentation/pages/mood_home_page.dart';

class MoodApp extends StatelessWidget {
  const MoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Tracker',
      theme: AppTheme.lightTheme,
      home: const MoodHomePage(),
    );
  }
}