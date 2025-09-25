// lib/src/repositories/profile_repository.dart
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  final SupabaseClient client;
  ProfileRepository({SupabaseClient? client}) : client = client ?? Supabase.instance.client;

  Future<Map<String, dynamic>?> fetchProfile(String userId) async {
    final res = await client.from('profiles').select().eq('id', userId).maybeSingle();
    return res == null ? null : Map<String, dynamic>.from(res as Map);
  }

  Future<void> upsertProfile(String userId, {String? name, String? bio, String? avatarUrl}) async {
    final data = {'id': userId};
    if (name != null) data['name'] = name;
    if (bio != null) data['bio'] = bio;
    if (avatarUrl != null) data['avatar_url'] = avatarUrl;
    await client.from('profiles').upsert(data);
  }

  /// Uploads a File to the 'avatars' bucket and returns the public URL (string).
  Future<String> uploadAvatar(File file, String destFilename) async {
    // Ensure bucket 'avatars' exists and is public or use getSignedUrl for private buckets.
    final storage = client.storage.from('avatars');

    // NOTE: this can throw; caller should handle exceptions.
    await storage.upload(destFilename, file, fileOptions: const FileOptions(upsert: true));

    // getPublicUrl returns String
    final String publicUrl = storage.getPublicUrl(destFilename);

    // If your bucket is private, you should use createSignedUrl instead:
    // final signed = await storage.createSignedUrl(destFilename, 60 * 60 * 24); // seconds
    // return signed;

    return publicUrl;
  }

  // Basic count helpers — replace table names if different
  Future<int> countTrips(String userId) async {
    final list = await client.from('trips').select().eq('user_id', userId);
    return (list as List?)?.length ?? 0;
  }

  Future<int> countCities(String userId) async {
    final list = await client.from('user_cities').select().eq('user_id', userId);
    return (list as List?)?.length ?? 0;
  }

  Future<int> countCountries(String userId) async {
    final list = await client.from('user_countries').select().eq('user_id', userId);
    return (list as List?)?.length ?? 0;
  }
}
