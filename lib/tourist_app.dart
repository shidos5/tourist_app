import 'package:flutter/material.dart';
import 'package:tourist_app/ui/screens/auth/register_screen.dart';
import 'package:tourist_app/ui/theme/app_theme.dart';

class TouristApp extends StatelessWidget {
  const TouristApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,  
      darkTheme: AppTheme.darkTheme, 
      themeMode: ThemeMode.system,
      home:RegisterScreen()
    );
  }
}