import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/weather_service.dart';
import '../services/firebase_service.dart';
import 'favorites_screen.dart';
import '../auth/auth_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String city = '';
  Map<String, dynamic>? weatherData;
  bool isLoading = false;

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
    if (weatherData == null) return SizedBox();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Color(0xFFF8F3CE),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${weatherData!['name']}',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7A7A73))),
          SizedBox(height: 8),
          Text(
            '${weatherData!['main']['temp']}°C',
            style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w700,
                color: Color(0xFF7A7A73)),
          ),
          SizedBox(height: 4),
          Text(
            '${weatherData!['weather'][0]['description']}',
            style: TextStyle(fontSize: 18, color: Color(0xFF7A7A73)),
          ),
          SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () =>
                  FirestoreService.addCity(weatherData!['name']),
              icon: Icon(Icons.favorite_border),
              label: Text("Add to Favorites"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7A7A73),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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
      backgroundColor: Color(0xFFDDDAD0),
      appBar: AppBar(
        backgroundColor: Color(0xFF7A7A73),
        title: Text('JKR Weather App', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FavoritesScreen()),
            ),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => AuthService.signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${user.displayName}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7A7A73),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFF8F3CE),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
              ),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Enter City',
                      labelStyle: TextStyle(color: Color(0xFF7A7A73)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF7A7A73)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: TextStyle(color: Colors.black87),
                    onChanged: (val) => city = val,
                  ),
                  SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: searchWeather,
                    icon: Icon(Icons.search),
                    label: Text("What's the Weather like?"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF7A7A73),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (!isLoading) weatherWidget(),
          ],
        ),
      ),
    );
  }
}
