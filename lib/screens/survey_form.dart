import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/rating_bar.dart';
import '../models/place.dart';

class SurveyForm extends StatefulWidget {
  final Place place;

  SurveyForm({required this.place});

  @override
  _SurveyFormState createState() => _SurveyFormState();
}

class _SurveyFormState extends State<SurveyForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  double _rating = 0;
  String _feedback = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  final ValueNotifier<double> _ratingNotifier = ValueNotifier<double>(0);

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Data to be sent to the MockAPI server
      final data = {
        'name': _name,
        'email': _email,
        'placeId': widget.place.id,
        'rating': _rating,
        'feedback': _feedback,
      };

      // Send data to the MockAPI server
      final response = await http.post(
        Uri.parse(
            'https://66619d9c63e6a0189feabee6.mockapi.io/api/v1/feedback'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        // Clear the form fields
        _nameController.clear();
        _emailController.clear();
        _feedbackController.clear();
        _ratingNotifier.value = 0;

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terima kasih atas umpan balik Anda!')),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim umpan balik!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rating ${widget.place.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  hintText: 'Masukkan nama Anda',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Masukkan email Anda',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Email tidak valid';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              SizedBox(height: 20),
              Text('Rating:'),
              CustomRatingBar(
                ratingNotifier: _ratingNotifier,
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _feedbackController,
                decoration: InputDecoration(
                  labelText: 'Umpan Balik',
                  hintText: 'Berikan umpan balik Anda',
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Umpan balik tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) {
                  _feedback = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
