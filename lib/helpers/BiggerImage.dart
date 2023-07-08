import 'package:flutter/material.dart';

class ImagePage extends StatelessWidget {
  final String image;

  const ImagePage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(onPressed: () { Navigator.pop(context);}, icon: Icon(Icons.arrow_back),),),
      body: Center(
        child: Image.network(image),
      ),
    );
  }
}
