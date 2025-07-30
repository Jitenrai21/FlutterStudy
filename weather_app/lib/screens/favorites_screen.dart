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
      backgroundColor: Color(0xFFF8F3CE),
      appBar: AppBar(
        backgroundColor: Color(0xFF7A7A73),
        title: Text(
          "Favorites",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService.getFavoriteCities(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (_, __) => SizedBox(height: 12),
            itemBuilder: (context, index) {
              final city = docs[index]['name'];

              return FutureBuilder<Map<String, dynamic>?>(
                future: _loadWeather(city),
                builder: (context, weatherSnapshot) {
                  if (!weatherSnapshot.hasData) {
                    return Card(
                      color: Color(0xFFDDDAD0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        title: Text(
                          city,
                          style: TextStyle(
                            color: Color(0xFF7A7A73),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }

                  final data = weatherSnapshot.data!;
                  final temp = data['main']['temp'];
                  final desc = data['weather'][0]['description'];
                  final name = data['name'];

                  return Card(
                    color: Color(0xFFDDDAD0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      title: Text(
                        '$name - ${temp.toStringAsFixed(1)}°C',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF7A7A73),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          desc[0].toUpperCase() + desc.substring(1),
                          style: TextStyle(
                            color: Color(0xFF7A7A73).withOpacity(0.8),
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_outline),
                        color: Color(0xFF7A7A73),
                        onPressed: () => FirestoreService.removeCity(city),
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
