import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';

void main() {
  runApp(
    const AguaPlusApp(),
  );
}

class AguaPlusApp extends StatelessWidget {
  const AguaPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agua+',

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor:
              const Color(0xFFF43B40),
        ),

        fontFamily: 'Arial',

        scaffoldBackgroundColor:
            const Color(0xFFF4F4F4),
      ),

      home:
          const SplashScreen(),
    );
  }
}

