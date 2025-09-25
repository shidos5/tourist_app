import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_app/bloc/auth/auth_cubit.dart';
import 'package:tourist_app/bloc/theme/theme_cubit.dart';
import 'package:tourist_app/ui/screens/auth/sign_in_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, state) {
              return SwitchListTile(
                title: const Text('Dark Mode'),
                value: state == ThemeMode.dark,
                onChanged: (value) {
                  context.read<ThemeCubit>().toggleTheme();
                },
              );
            },
          ),
          ListTile(
            title: const Text('Language'),
            subtitle: const Text('English'), // Placeholder
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Select Language'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('English'),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: const Text('Spanish'),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              context.read<AuthCubit>().signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
