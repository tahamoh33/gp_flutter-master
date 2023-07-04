import 'package:flutter/material.dart';

class ImagePage extends StatelessWidget {
  final String image;

  const ImagePage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.network(image),
      ),
    );
  }
}
