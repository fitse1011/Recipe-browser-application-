import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const RecipeBrowserApp());
}

class RecipeBrowserApp extends StatelessWidget {
  const RecipeBrowserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Browser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE8601C), // warm orange — food brand feel
          brightness: Brightness.light,
        ),
        cardTheme: const CardThemeData(surfaceTintColor: Colors.transparent),
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      home: const HomeScreen(),
    );
  }
}
