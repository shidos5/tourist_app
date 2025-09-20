class City {
  final String id;
  final String slug;
  final String name;
  final String? country;
  final String? description;
  final double? lat;
  final double? lng;
  final List<String> images;

  City({required this.id, required this.slug, required this.name, this.country, this.description, this.lat, this.lng, this.images = const []});

  factory City.fromJson(Map<String, dynamic> j) => City(
    id: j['id'],
    slug: j['slug'],
    name: j['name'],
    country: j['country'],
    description: j['description'],
    lat: (j['lat'] as num?)?.toDouble(),
    lng: (j['lng'] as num?)?.toDouble(),
    images: List<String>.from(j['images'] ?? []),
  );
}
