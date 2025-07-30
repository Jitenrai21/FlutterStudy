import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/weather_service.dart';
import '../services/firebase_service.dart';
import 'favorites_screen.dart';
import '../auth/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String city = '';
  Map<String, dynamic>? weatherData;
  bool isLoading = false;

  final Color primaryColor = const Color(0xFF0ABAB5);
  final Color accentColor = const Color(0xFF56DFCF);
  final Color highlightColor = const Color(0xFFADEED9);

  Future<void> searchWeather() async {
    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);
    final data = await WeatherService.fetchWeather(city);
    setState(() {
      weatherData = data;
      isLoading = false;
    });
  }

  Widget weatherWidget() {
    if (weatherData == null) return const SizedBox();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${weatherData!['name']}',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor)),
          const SizedBox(height: 8),
          Text(
            '${weatherData!['main']['temp']}°C',
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${weatherData!['weather'][0]['description']}',
            style: const TextStyle(fontSize: 18, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () =>
                  FirestoreService.addCity(weatherData!['name']),
              icon: const Icon(Icons.favorite_border),
              label: const Text("Add to Favorites"),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      backgroundColor: highlightColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('JKR Weather App', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FavoritesScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => AuthService.signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${user.displayName}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Enter City',
                      labelStyle: TextStyle(color: primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black87),
                    onChanged: (val) => city = val,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: searchWeather,
                    icon: const Icon(Icons.search),
                    label: const Text("What's the Weather like?"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (!isLoading) weatherWidget(),
          ],
        ),
      ),
    );
  }
}
