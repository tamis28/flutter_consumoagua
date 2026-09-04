import 'package:flutter/material.dart';

import 'home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _enter(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 360,
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                const Text(
                  '💧',
                  style: TextStyle(fontSize: 42),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Agua+',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Controle seu consumo de água',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF737373),
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _enter(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFF43B40),
                      foregroundColor: Colors.white,
                      minimumSize:
                          const Size.fromHeight(44),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Entrar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
