// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tourist_app/ui/color/app_colors.dart';
import 'package:tourist_app/services/unsplash_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredCities = [];
  Map<String, String> _cityImages = {};
  bool _isLoading = true;
  final List<String> _filters = [
    "Popular",
    "Beaches",
    "Mountains",
    "Culture",
    "Adventure",
  ];
  int _selectedFilterIndex = 0;

  final UnsplashService _unsplashService = UnsplashService();

  final List<Map<String, dynamic>> _cities = [
    {
      "name": "Paris, France",
      "description": "City of lights and romance with iconic landmarks",
      "rating": 4.8,
      "attractions": 127,
    },
    {
      "name": "Tokyo, Japan",
      "description": "A vibrant mix of tradition and modernity",
      "rating": 4.7,
      "attractions": 200,
    },
    {
      "name": "New York, USA",
      "description": "The city that never sleeps",
      "rating": 4.6,
      "attractions": 150,
    },
  ];
  @override
  void initState() {
    super.initState();
    _filteredCities = _cities; // show all initially
    _loadCityImages();
  }

  Future<void> _loadCityImages() async {
    setState(() => _isLoading = true);
    try {
      for (var city in _cities) {
        final imageUrl = await _unsplashService.fetchCityPhoto(city["name"]);
        if (imageUrl != null) {
          _cityImages[city["name"]] = imageUrl;
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _refreshData() async {
    await _loadCityImages();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.grayLight,
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Header
                Container(
                  padding: const EdgeInsets.all(16),
                  color: AppColors.primary,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Discover Amazing Places",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Find the best attractions and plan your perfect trip",
                        style: TextStyle(
                          color: AppColors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // 🔹 Search Field
                      TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _filteredCities = _cities
                                .where(
                                  (city) => city["name"].toLowerCase().contains(
                                    value.toLowerCase(),
                                  ),
                                )
                                .toList();
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.white,
                          hintText: "Search cities or countries...",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 🔹 Filter Chips
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filters.length,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedFilterIndex == index;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(_filters[index]),
                          selected: isSelected,
                          selectedColor: AppColors.secondary,
                          backgroundColor: AppColors.grayLight,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppColors.white
                                : AppColors.grayDark,
                          ),
                          onSelected: (_) {
                            setState(() => _selectedFilterIndex = index);
                            // 🔹 Later: filter cities based on selection
                          },
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // 🔹 Featured Destinations
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Featured Destinations",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grayDark,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else
                  Column(
                    children: _cities.map((city) {
                      final imageUrl = _cityImages[city["name"]] ??
                          "https://via.placeholder.com/400x200.png?text=No+Image";
                      return _buildCityCard(
                        imageUrl: imageUrl,
                        city: city["name"],
                        description: city["description"],
                        rating: city["rating"],
                        attractions: city["attractions"],
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCityCard({
    required String imageUrl,
    required String city,
    required String description,
    required double rating,
    required int attractions,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.grayDark.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 180,
                color: Colors.grey[300],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error, size: 40),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  city,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grayDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.grayDark.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text("$rating"),
                    const Spacer(),
                    Text(
                      "$attractions attractions",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
