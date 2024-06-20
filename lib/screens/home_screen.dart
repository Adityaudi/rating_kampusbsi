import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/place.dart';
import '../widgets/place_card.dart';
import 'survey_form.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Place>> _places;

  Future<List<Place>> fetchPlaces() async {
    final response = await http.get(
        Uri.parse('https://66619d9c63e6a0189feabee6.mockapi.io/api/v1/place'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Place.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load places');
    }
  }

  @override
  void initState() {
    super.initState();
    _places = fetchPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rating Kampus BSI'),
      ),
      body: FutureBuilder<List<Place>>(
        future: _places,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No places found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return PlaceCard(
                  place: snapshot.data![index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SurveyForm(place: snapshot.data![index]),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
