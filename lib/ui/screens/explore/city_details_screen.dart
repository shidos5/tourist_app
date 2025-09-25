import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tourist_app/models/city.dart';
import 'package:tourist_app/ui/color/app_colors.dart';

class CityDetailsScreen extends StatefulWidget {
  final City city;
  final List<Map<String, dynamic>> allCities;

  const CityDetailsScreen({
    super.key,
    required this.city,
    required this.allCities,
  });

  @override
  State<CityDetailsScreen> createState() => _CityDetailsScreenState();
}

class _CityDetailsScreenState extends State<CityDetailsScreen> {
  bool isFavorite = false;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final response = await supabase
          .from('favorites')
          .select()
          .eq('user_id', user.id)
          .eq('city_name', widget.city.name);
          
      if (response.isNotEmpty) {
        if (mounted) {
          setState(() {
            isFavorite = true;
          });
        }
      }
    }
  }

  Future<void> _toggleFavorite() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to be logged in to add favorites')),
      );
      return;
    }

    if (isFavorite) {
      await supabase
          .from('favorites')
          .delete()
          .eq('user_id', user.id)
          .eq('city_name', widget.city.name);
    } else {
      await supabase.from('favorites').insert({
        'user_id': user.id,
        'city_name': widget.city.name,
        'city_description': widget.city.description,
        'city_rating': widget.city.rating,
        'city_attractions': widget.city.attractions,
        'city_image_url': widget.city.images.isNotEmpty ? widget.city.images.first : null,
      });
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: widget.city.name,
                  child: CachedNetworkImage(
                    imageUrl: widget.city.images.isNotEmpty
                        ? widget.city.images.first
                        : "https://via.placeholder.com/400x300.png?text=No+Image",
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 300,
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, size: 40),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: AppColors.white.withOpacity(0.8),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 16,
                  child: CircleAvatar(
                    backgroundColor: AppColors.white.withOpacity(0.8),
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.black,
                      ),
                      onPressed: _toggleFavorite,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.city.name,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.white
                          : AppColors.grayDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.city.description ?? "No description available.",
                    style: TextStyle(
                      fontSize: 16,
                      color: //trnary 
                      Theme.of(context).brightness == Brightness.dark
                          ? AppColors.white
                          : AppColors.grayDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        "${widget.city.rating ?? 'N/A'}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      Text(
                        "${widget.city.attractions ?? 'N/A'} attractions",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
