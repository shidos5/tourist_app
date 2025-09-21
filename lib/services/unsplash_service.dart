// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UnsplashService {
    final String? accessKey = dotenv.env['UNSPLASH_ACCESS_KEY'];
  

  Future<String?> fetchCityPhoto(String city) async {
    final url = Uri.parse(
      "https://api.unsplash.com/search/photos"
      "?query=$city&per_page=1&orientation=landscape&client_id=$accessKey",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List<dynamic>;
      if (results.isNotEmpty) {
        return results[0]['urls']['regular'];
      } else {
        print("⚠️ No image found for $city");
        return null;
      }
    } else {
      print("❌ Error fetching Unsplash: ${response.body}");
      return null;
    }
  }
}
