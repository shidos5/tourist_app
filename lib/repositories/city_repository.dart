import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/city.dart';

class CityRepository {
  final SupabaseClient client;
  CityRepository(this.client);

  Future<List<City>> fetchCities({String? query}) async {
    final data = query == null || query.isEmpty
        ? await client.from('cities').select().order('name')
        : await client.from('cities').select().ilike('name', '%$query%');

    // 'data' is already a List<dynamic> from Supabase v2
    return (data as List)
        .map((e) => City.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
