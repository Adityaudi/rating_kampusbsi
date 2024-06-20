import 'package:flutter/material.dart';
import '../models/place.dart';

class PlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback onTap;

  PlaceCard({required this.place, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          children: [
            Image.network(place.imageUrl),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                place.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
