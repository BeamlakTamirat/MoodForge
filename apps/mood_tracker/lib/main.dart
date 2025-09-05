import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/src/app.dart';
import 'package:mood_tracker/src/data/local/hive_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await HiveService.registerAdapters();

  runApp(const ProviderScope(child: MoodApp()));
}