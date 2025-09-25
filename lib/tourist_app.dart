import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_app/bloc/theme/theme_cubit.dart';
import 'package:tourist_app/ui/screens/splash/splash_screen.dart';
import 'package:tourist_app/ui/theme/app_theme.dart';

class TouristApp extends StatelessWidget {
  const TouristApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}
