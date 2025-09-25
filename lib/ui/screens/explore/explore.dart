// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tourist_app/models/city.dart';
import 'package:tourist_app/ui/color/app_colors.dart';
import 'package:tourist_app/services/unsplash_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tourist_app/ui/screens/explore/city_details_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Map<String, String> _cityImages = {};
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
        {
      "name": "Cairo, Egypt",
      "description": "Home to ancient pyramids and rich history",
      "rating": 4.2,
      "attractions": 120,
    },
         {
      "name": "Khartoum, Sudan",
      "description": "Where the Blue and White Nile meet",
      "rating": 3.9,
      "attractions": 120,
    },
      {
      "name": "Dubai, UAE",
      "description": "A city of superlatives and futuristic architecture",
      "rating": 4.8,
      "attractions": 190,
    },
      {
      "name": "Marrakech, Morocco",
      "description": "A city of vibrant colors and rich culture",
      "rating": 4.7,
      "attractions": 150,
    },
      {
      "name": "Sydney, Australia",
      "description": "Famous for its Opera House and stunning harbor",
      "rating": 4.6,
      "attractions": 130,
    },
      {
      "name": "Rio de Janeiro, Brazil",
      "description": "Known for its beaches, Carnival, and Christ the Redeemer statue",
      "rating": 4.5,
      "attractions": 140,
    },
      {
      "name": "Rome, Italy",
      "description": "A city rich in history with ancient ruins and art",
      "rating": 4.8,
      "attractions": 160,
    },
      {
      "name": "Bangkok, Thailand",
      "description": "A bustling city known for its vibrant street life and temples",
      "rating": 4.4,
      "attractions": 180,
    },
      {
      "name": "Barcelona, Spain",
      "description": "Famous for its art and architecture, including Gaudí's masterpieces",
      "rating": 4.7,
      "attractions": 140,
    },
      {
      "name": "Istanbul, Turkey",
      "description": "A city that straddles two continents with rich history and culture",
      "rating": 4.6,
      "attractions": 170,
    },
      {
      "name": "Cape Town, South Africa",
      "description": "Known for its stunning landscapes and Table Mountain",
      "rating": 4.5,
      "attractions": 110,
    },
      {
      "name": "San Francisco, USA",
      "description": "Famous for the Golden Gate Bridge and vibrant tech scene",
      "rating": 4.6,
      "attractions": 130,
    },
      {
      "name": "Amsterdam, Netherlands",
      "description": "Known for its canals, museums, and vibrant culture",
      "rating": 4.7,
      "attractions": 120,
    },
      {
      "name": "Lisbon, Portugal",
      "description": "A coastal city known for its historic sites and vibrant nightlife",
      "rating": 4.5,
      "attractions": 100,
    },
      {
      "name": "Vienna, Austria",
      "description": "Famous for its classical music heritage and imperial history",
      "rating": 4.8,
      "attractions": 110,
    },
      {
      "name": "Prague, Czech Republic",
      "description": "A city of a hundred spires with beautiful architecture",
      "rating": 4.7,
      "attractions": 115,
    },
      {
      "name": "Edinburgh, Scotland",
      "description": "Known for its historic and cultural attractions including the Edinburgh Castle",
      "rating": 4.6,
      "attractions": 90,
    },
      {
      "name": "Venice, Italy",
      "description": "Famous for its canals, gondolas, and Renaissance art",
      "rating": 4.8,
      "attractions": 105,
    },
      {
      "name": "Athens, Greece",
      "description": "A city rich in ancient history and archaeological sites",
      "rating": 4.5,
      "attractions": 130,
    },
      {
      "name": "Seoul, South Korea",
      "description": "A dynamic city blending modern skyscrapers with traditional palaces",
      "rating": 4.6,
      "attractions": 140,
    },
      {
      "name": "Berlin, Germany",
      "description": "Known for its vibrant culture, history, and nightlife",
      "rating": 4.7,
      "attractions": 150,
    },
      {
      "name": "Hanoi, Vietnam",
      "description": "A city known for its centuries-old architecture and rich culture",
      "rating": 4.4,
      "attractions": 125,
    },
      {
      "name": "Budapest, Hungary",
      "description": "Famous for its thermal baths and stunning architecture",
      "rating": 4.6,
      "attractions": 110,
    },
      {
      "name": "Kuala Lumpur, Malaysia",
      "description": "A bustling city known for its modern skyline and cultural diversity",
      "rating": 4.5,
      "attractions": 135,
    },
      {
      "name": "Moscow, Russia",
      "description": "A city rich in history with iconic landmarks like the Red Square and Kremlin",
      "rating": 4.6,
      "attractions": 145,
    },
      {
      "name": "Florence, Italy",
      "description": "The cradle of the Renaissance with world-class art and architecture",
      "rating": 4.8,
      "attractions": 95,
    },
      {
      "name": "Dublin, Ireland",
      "description": "Known for its literary history and vibrant pub culture",
      "rating": 4.5,
      "attractions": 100,
    },
      {
      "name": "Zurich, Switzerland",
      "description": "A global financial hub with beautiful lakeside scenery",
      "rating": 4.7,
      "attractions": 80,
    },
      {
      "name": "Lima, Peru",
      "description": "A city known for its rich history and culinary scene",
      "rating": 4.3,
      "attractions": 120,
    },
      {
      "name": "Mexico City, Mexico",
      "description": "A vibrant city with a rich cultural heritage and bustling markets",
      "rating": 4.4,
      "attractions": 160,
    },
      {
      "name": "Buenos Aires, Argentina",
      "description": "Known for its European-style architecture and tango music",
      "rating": 4.5,
      "attractions": 110,
    },
      {
      "name": "Lagos, Nigeria",
      "description": "A bustling city known for its vibrant culture and nightlife",
      "rating": 4.2,
      "attractions": 130,
    },
      {
      "name": "Jakarta, Indonesia",
      "description": "A sprawling metropolis known for its vibrant culture and cuisine",
      "rating": 4.1,
      "attractions": 140,
    },
      {
      "name": "Helsinki, Finland",
      "description": "A city known for its design, architecture, and coastal beauty",
      "rating": 4.6,
      "attractions": 85,
    },

  ];
  List<Map<String, dynamic>> _filteredCities = [];

  @override
  void initState() {
    super.initState();
    _filteredCities = _cities;
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
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.grayDark : AppColors.white,
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                                .where((city) => city['name']
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).brightness == Brightness.dark ? AppColors.grayDark : AppColors.white,
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
                            //  Later: filter cities based on selection
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
                else if (_filteredCities.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text("No match found"),
                    ),
                  )
                else
                  Column(
                    children: _filteredCities.map((city) {
                      final imageUrl = _cityImages[city["name"]] ??
                          "https://via.placeholder.com/400x200.png?text=No+Image";
                      return GestureDetector(
                        onTap: () {
                          final cityObject = City(
                            name: city['name'],
                            description: city['description'],
                            rating: city['rating'],
                            attractions: city['attractions'],
                            images: [imageUrl],
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CityDetailsScreen(city: cityObject, allCities: _cities),
                            ),
                          );
                        },
                        child: _buildCityCard(
                          imageUrl: imageUrl,
                          city: city["name"],
                          description: city["description"],
                          rating: city["rating"],
                          attractions: city["attractions"],
                        ),
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
