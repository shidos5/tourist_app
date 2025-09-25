import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tourist_app/bloc/auth/auth_cubit.dart';
import 'package:tourist_app/repositories/profile_repository.dart';
import 'package:tourist_app/ui/screens/settings/settings_screen.dart';
import 'package:tourist_app/ui/widgets/loading_indicator.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  late final ProfileRepository _profileRepository;
  Map<String, dynamic>? _profile;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _profileRepository = ProfileRepository();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final userId = context.read<AuthCubit>().client.auth.currentUser!.id;
    final profile = await _profileRepository.fetchProfile(userId);
    setState(() {
      _profile = profile;
      _nameController.text = _profile?['name'] ?? '';
      _bioController.text = _profile?['bio'] ?? '';
      _imageUrl = _profile?['avatar_url'];
    });
  }

  Future<void> _updateProfile() async {
    final userId = context.read<AuthCubit>().client.auth.currentUser!.id;
    await _profileRepository.upsertProfile(
      userId,
      name: _nameController.text,
      bio: _bioController.text,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final userId = context.read<AuthCubit>().client.auth.currentUser!.id;
      final imageUrl = await _profileRepository.uploadAvatar(
        File(pickedFile.path),
        '${userId}_avatar',
      );
      setState(() {
        _imageUrl = imageUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: _profile == null
          ? const LoadingIndicator()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _imageUrl != null
                          ? NetworkImage(_imageUrl!)
                          : const AssetImage('assets/default_avatar.png')
                              as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _bioController,
                    decoration: const InputDecoration(
                      labelText: 'Bio',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _updateProfile,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
    );
  }
}
