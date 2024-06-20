import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomRatingBar extends StatelessWidget {
  final ValueNotifier<double> ratingNotifier;
  final void Function(double) onRatingUpdate;

  CustomRatingBar({required this.ratingNotifier, required this.onRatingUpdate});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: ratingNotifier,
      builder: (context, rating, child) {
        return RatingBar.builder(
          initialRating: rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (newRating) {
            ratingNotifier.value = newRating;
            onRatingUpdate(newRating);
          },
        );
      },
    );
  }
}
