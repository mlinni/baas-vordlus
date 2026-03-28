import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/app_user.dart';
import '../models/user_profile.dart';
import '../repositories/auth_repository.dart';
import '../repositories/profile_repository.dart';
import '../repositories/storage_repository.dart';
import '../services/supabase/supabase_auth_repository.dart';
import '../services/supabase/supabase_profile_repository.dart';
import '../services/supabase/supabase_storage_repository.dart';
import '../ui/login_screen.dart';
import '../ui/profile_screen.dart';

class BaaSVordlusApp extends StatelessWidget {
  const BaaSVordlusApp({
    super.key,
    this.authRepository,
    this.profileRepository,
    this.storageRepository,
  });

  final AuthRepository? authRepository;
  final ProfileRepository? profileRepository;
  final StorageRepository? storageRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BaaS Vordlus',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B5E20)),
      ),
      home: AppShell(
        authRepository: authRepository ?? SupabaseAuthRepository(Supabase.instance.client),
        profileRepository: profileRepository ?? SupabaseProfileRepository(Supabase.instance.client),
        storageRepository: storageRepository ?? SupabaseStorageRepository(Supabase.instance.client),
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.authRepository,
    required this.profileRepository,
    required this.storageRepository,
  });

  final AuthRepository authRepository;
  final ProfileRepository profileRepository;
  final StorageRepository storageRepository;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  AppUser? _currentUser;

  Future<AppUser> _finalizeSignIn(AppUser user) async {
    final existingProfile = await widget.profileRepository.getProfile(user.id);
    if (existingProfile == null) {
      await widget.profileRepository.saveProfile(
        UserProfile(
          userId: user.id,
          email: user.email,
          displayName: 'Demo kasutaja',
          bio: 'See profiil loodi automaatselt peale autentimist.',
        ),
      );
    }

    setState(() {
      _currentUser = user;
    });

    return user;
  }

  Future<AppUser> _handleLogin(String email, String password) async {
    final user = await widget.authRepository.signInWithEmail(
      email: email,
      password: password,
    );
    return _finalizeSignIn(user);
  }

  Future<UserProfile> _loadProfile() async {
    final user = _currentUser!;
    final profile = await widget.profileRepository.getProfile(user.id);
    return profile ??
        UserProfile(
          userId: user.id,
          email: user.email,
          displayName: 'Demo kasutaja',
          bio: '',
        );
  }

  Future<UserProfile> _saveProfile(String displayName, String bio) async {
    final currentProfile = await _loadProfile();
    return widget.profileRepository.saveProfile(
      currentProfile.copyWith(
        displayName: displayName,
        bio: bio,
      ),
    );
  }

  Future<UserProfile> _uploadAvatar(String fileName, List<int> bytes) async {
    final user = _currentUser!;
    final imageUrl = await widget.storageRepository.uploadProfileImage(
      userId: user.id,
      fileName: fileName,
      bytes: bytes,
    );

    final currentProfile = await _loadProfile();
    return widget.profileRepository.saveProfile(
      currentProfile.copyWith(avatarUrl: imageUrl),
    );
  }

  Future<void> _signOut() async {
    await widget.authRepository.signOut();
    setState(() {
      _currentUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return LoginScreen(
        onLogin: _handleLogin,
      );
    }

    return ProfileScreen(
      user: _currentUser!,
      loadProfile: _loadProfile,
      saveProfile: _saveProfile,
      uploadAvatar: _uploadAvatar,
      onSignOut: _signOut,
    );
  }
}
