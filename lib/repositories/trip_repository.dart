import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tourist_app/models/trip.dart';

class TripRepository {
  final SupabaseClient client;

  TripRepository({SupabaseClient? client}) : client = client ?? Supabase.instance.client;

  Future<List<Trip>> getTrips(String userId) async {
    final data = await client
        .from('trips')
        .select()
        .eq('user_id', userId)
        .order('start_date', ascending: true);
    return (data as List).map((e) => Trip.fromMap(e)).toList();
  }

  Future<void> addTrip(Trip trip) async {
    await client.from('trips').insert(trip.toMap());
  }

  Future<void> updateTrip(Trip trip) async {
    await client.from('trips').update(trip.toMap()).eq('id', trip.id);
  }

  Future<void> deleteTrip(String tripId) async {
    await client.from('trips').delete().eq('id', tripId);
  }
}
