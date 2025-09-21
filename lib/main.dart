import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tourist_app/bloc/auth/auth_cubit.dart';
import 'package:tourist_app/tourist_app.dart';

Future <void> main()async {
  WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
    final client = Supabase.instance.client;
  runApp(BlocProvider(
      create: (_) => AuthCubit(client)..checkAuthStatus(),
      child: const TouristApp(),
    ),);
}