import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';
import '../services/weather_service.dart';

class FavoritesScreen extends StatelessWidget {
  Future<Map<String, dynamic>?> _loadWeather(String city) async {
    try {
      print('Fetching weather for city: $city');
      final weather = await WeatherService.fetchWeather(city);
      print('Weather data for $city: $weather');
      return weather;
    } catch (e) {
      print('Error fetching weather for $city: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFADEED9), // Light theme base
      appBar: AppBar(
        backgroundColor: Color(0xFF0ABAB5), // Primary
        title: Text(
          "Favorites",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 2,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService.getFavoriteCities(),
        builder: (context, snapshot) {
          print('Firestore snapshot: ${snapshot.data?.docs.map((doc) => doc.data()).toList()}');
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: Color(0xFF0ABAB5)));
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(
              child: Text(
                "No favorites added yet.",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF0ABAB5),
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: docs.length,
            separatorBuilder: (_, __) => SizedBox(height: 12),
            itemBuilder: (context, index) {
              final city = docs[index]['name'] as String? ?? '';
              if (city.isEmpty) {
                print('Invalid city name at index $index');
                return ListTile(
                  title: Text('Invalid city name'),
                  tileColor: Color(0xFF56DFCF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                );
              }

              return FutureBuilder<Map<String, dynamic>?>(
                future: _loadWeather(city),
                builder: (context, weatherSnapshot) {
                  final isLoading = weatherSnapshot.connectionState == ConnectionState.waiting;

                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: Color(0xFF56DFCF), // Secondary color
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      title: Text(
                        isLoading
                            ? city
                            : weatherSnapshot.hasData && weatherSnapshot.data != null
                                ? '${weatherSnapshot.data!['name']} - ${weatherSnapshot.data!['main']['temp']?.toStringAsFixed(1) ?? 'N/A'}°C'
                                : '$city - Failed to load',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF084A4A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: isLoading || !weatherSnapshot.hasData || weatherSnapshot.data == null
                          ? null
                          : Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                (weatherSnapshot.data!['weather']?[0]['description'] as String?)?.replaceFirstMapped(
                                      RegExp(r'^\w'),
                                      (Match m) => m.group(0)!.toUpperCase(),
                                    ) ??
                                    'N/A',
                                style: TextStyle(
                                  color: Color(0xFF084A4A).withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_outline),
                        color: Color(0xFF084A4A),
                        onPressed: () async {
                          try {
                            await FirestoreService.removeCity(city);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('$city removed from favorites')),
                            );
                          } catch (e) {
                            print('Error removing city: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to remove $city')),
                            );
                          }
                        },
                        tooltip: "Remove from favorites",
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}