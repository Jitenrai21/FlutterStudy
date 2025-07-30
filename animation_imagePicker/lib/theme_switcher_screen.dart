import 'package:flutter/material.dart';

class ThemeSwitcher extends StatefulWidget {
  const ThemeSwitcher({super.key});

  @override
  State<ThemeSwitcher> createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher> {
  bool isDark = false;

  final Color primaryColor = const Color(0xFF0065F8);
  final Color accentColor = const Color(0xFF00CAFF);
  final Color highlightColor = const Color(0xFF00FFDE);

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? Colors.black : const Color(0xFFF2F6FA);
    final textColor = isDark ? Colors.white : Colors.black;
    final modeText = isDark ? "Dark Mode" : "Light Mode";
    final cardColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Animated Theme"),
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
        elevation: 4,
      ),
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          padding: const EdgeInsets.all(32),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: textColor,
                size: 50,
              ),
              const SizedBox(height: 20),
              Text(
                modeText,
                style: TextStyle(
                  color: textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Tap the button below to switch theme.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: highlightColor,
        foregroundColor: Colors.black,
        onPressed: () => setState(() => isDark = !isDark),
        tooltip: "Switch Theme",
        child: const Icon(Icons.swap_horiz),
      ),
    );
  }
}