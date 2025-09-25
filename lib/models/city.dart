class City {
  final String? id;
  final String? slug;
  final String name;
  final String? country;
  final String? description;
  final double? lat;
  final double? lng;
  final List<String> images;
  final double? rating;
  final int? attractions;

  City({
    this.id,
    this.slug,
    required this.name,
    this.country,
    this.description,
    this.lat,
    this.lng,
    this.images = const [],
    this.rating,
    this.attractions,
  });

  factory City.fromJson(Map<String, dynamic> j) => City(
        id: j['id'],
        slug: j['slug'],
        name: j['name'],
        country: j['country'],
        description: j['description'],
        lat: (j['lat'] as num?)?.toDouble(),
        lng: (j['lng'] as num?)?.toDouble(),
        images: List<String>.from(j['images'] ?? []),
        rating: (j['rating'] as num?)?.toDouble(),
        attractions: j['attractions'],
      );
}
