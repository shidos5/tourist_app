import 'package:flutter/material.dart';

class FavoritePlacesScreen extends StatelessWidget {
  const FavoritePlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Places'),
      ),
      body: const Center(
        child: Text('Your favorite places will be displayed here.'),
      ),
    );
  }
}
