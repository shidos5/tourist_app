import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_app/bloc/auth/auth_cubit.dart';
import 'package:tourist_app/bloc/theme/theme_cubit.dart';
import 'package:tourist_app/ui/screens/auth/sign_in_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await context.read<AuthCubit>().signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Theme'),
            subtitle: const Text('Choose app appearance (system / light / dark)'),
            trailing: BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, state) {
                final current = state;
                // We'll show three segmented controls to match iOS feeling or a small popup
                return PopupMenuButton<ThemeMode>(
                  onSelected: (val) {
                    themeCubit.setTheme(val);
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: ThemeMode.system, child: Text('System')),
                    PopupMenuItem(value: ThemeMode.light, child: Text('Light')),
                    PopupMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                  ],
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(current == ThemeMode.light ? 'Light' : current == ThemeMode.dark ? 'Dark' : 'System'),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                );
              },
            ),
          ),

          // iOS-style toggle for quick dark mode on/off (this is a convenience toggle)
          ListTile(
            title: const Text('Dark Mode (quick)'),
            trailing: BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, state) {
                final isDark = state == ThemeMode.dark;
                return CupertinoSwitch(
                  value: isDark,
                  onChanged: (val) {
                    context.read<ThemeCubit>().setTheme(val ? ThemeMode.dark : ThemeMode.light);
                  },
                );
              },
            ),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text('Logout'),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
