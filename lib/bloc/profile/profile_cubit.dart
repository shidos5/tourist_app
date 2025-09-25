import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_app/bloc/profile/profile_state.dart';
import 'package:tourist_app/repositories/profile_repository.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;
  final String userId;

  ProfileCubit(this._profileRepository, this.userId) : super(ProfileInitial());

  void fetchProfile() async {
    try {
      emit(ProfileLoading());
      final profile = await _profileRepository.fetchProfile(userId);
      if (profile != null) {
        emit(ProfileLoaded(profile));
      } else {
        emit(const ProfileError('Profile not found'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void updateProfile(String name, String bio) async {
    try {
      await _profileRepository.upsertProfile(userId, name: name, bio: bio);
      fetchProfile();
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void uploadAvatar(dynamic file) async {
    try {
      await _profileRepository.uploadAvatar(file, '${userId}_avatar');
      fetchProfile();
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
