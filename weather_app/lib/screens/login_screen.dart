import 'package:flutter/material.dart';
import '../auth/auth_service.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Define your palette colors
    const Color backgroundColor = Color(0xFF7A7A73); // Dark Olive Gray
    const Color textColor = Color(0xFFDDDAD0);        // Soft Beige
    const Color accentColor = Color(0xFFF8F3CE);      // Light Cream

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_outlined,
                size: 100,
                color: accentColor,
              ),
              const SizedBox(height: 20),
              Text(
                "Welcome to WeatherApp",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Get accurate forecasts. Add your regions to favourites.\nSign in to continue.",
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                icon: Icon(Icons.login, color: backgroundColor),
                label: Text(
                  'Continue with Google',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: backgroundColor,
                  ),
                ),
                onPressed: () async {
                  await AuthService.signInWithGoogle();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
