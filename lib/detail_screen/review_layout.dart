import 'package:flutter/material.dart';
import 'package:restaurant/response/detail_response.dart';

class ReviewLayout extends StatelessWidget{
  const ReviewLayout({super.key, required this.cust, required this.position});


  final List<CustomerReview> cust;
  final int position;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            cust[position].name,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            cust[position].review,
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
          Text(
            cust[position].date,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}