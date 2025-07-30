import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';
import '../services/weather_service.dart';

class FavoritesScreen extends StatelessWidget {
  Future<Map<String, dynamic>?> _loadWeather(String city) async {
    return await WeatherService.fetchWeather(city);
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
              final city = docs[index]['name'];

              return FutureBuilder<Map<String, dynamic>?>(
                future: _loadWeather(city),
                builder: (context, weatherSnapshot) {
                  final isLoading = !weatherSnapshot.hasData;

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
                            : '${weatherSnapshot.data!['name']} - ${weatherSnapshot.data!['main']['temp'].toStringAsFixed(1)}°C',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF084A4A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: isLoading
                          ? null
                          : Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                weatherSnapshot.data!['weather'][0]['description']
                                    .replaceFirstMapped(RegExp(r'^\w'), (m) => m.group(0)!.toUpperCase()),
                                style: TextStyle(
                                  color: Color(0xFF084A4A).withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_outline),
                        color: Color(0xFF084A4A),
                        onPressed: () => FirestoreService.removeCity(city),
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
