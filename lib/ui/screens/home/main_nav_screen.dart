// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tourist_app/ui/color/app_colors.dart';
import 'package:tourist_app/ui/screens/explore/explore.dart';
import 'package:tourist_app/ui/screens/maps/maps_screen.dart';
import 'package:tourist_app/ui/screens/profile/profile_screen.dart';
import 'package:tourist_app/ui/screens/todo/todo_screen.dart';
import 'package:tourist_app/ui/screens/trip/trips_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    ExploreScreen(),
    const TripsScreen(),
    const TodoScreen(tripId: 'f9a7c4f0-5b5e-4b4e-8b0e-3b1a2c0e8d6f'),
    const MapsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Theme.of(context).brightness == Brightness.dark ? AppColors.primary : AppColors.primary,
        unselectedItemColor: Theme.of(context).brightness == Brightness.dark ? AppColors.white : AppColors.grayDark,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.grayDark : AppColors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.card_travel), label: "Trips"),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: "To-Do"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
