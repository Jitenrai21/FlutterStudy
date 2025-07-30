import 'package:flutter/material.dart';
import 'theme_switcher_screen.dart';
import 'image_picker_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animations & Device Features',
      theme: ThemeData(
        primaryColor: const Color(0xFF0065F8),
        scaffoldBackgroundColor: const Color(0xFFF2F6FA),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final Color primaryColor = const Color(0xFF0065F8);
  final Color accentColor = const Color(0xFF00CAFF);
  final Color highlightColor = const Color(0xFF00FFDE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FA),
      appBar: AppBar(
        title: const Text("JKR's Animation Feature and Image Picker"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Try Out",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 30),

                ElevatedButton.icon(
                  icon: const Icon(Icons.animation),
                  label: const Text("Theme Animation"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    elevation: 4,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ThemeSwitcher()),
                    );
                  },
                ),
                const SizedBox(height: 20),

                ElevatedButton.icon(
                  icon: const Icon(Icons.image),
                  label: const Text("Pick Image"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: highlightColor,
                    foregroundColor: Colors.black,
                    elevation: 4,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ImagePickerScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
