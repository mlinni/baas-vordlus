import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../models/app_user.dart';
import '../models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.user,
    required this.loadProfile,
    required this.saveProfile,
    required this.uploadAvatar,
    required this.onSignOut,
  });

  final AppUser user;
  final Future<UserProfile> Function() loadProfile;
  final Future<UserProfile> Function(String displayName, String bio) saveProfile;
  final Future<UserProfile> Function(String fileName, List<int> bytes)
      uploadAvatar;
  final Future<void> Function() onSignOut;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();
  bool _isSaving = false;
  bool _isUploading = false;
  late Future<UserProfile> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = widget.loadProfile();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _fillControllers(UserProfile profile) {
    if (_displayNameController.text != profile.displayName) {
      _displayNameController.text = profile.displayName;
    }
    if (_bioController.text != profile.bio) {
      _bioController.text = profile.bio;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final profile = await widget.saveProfile(
        _displayNameController.text.trim(),
        _bioController.text.trim(),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _profileFuture = Future<UserProfile>.value(profile);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profiil salvestatud.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Salvestamine ebaonnestus: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _uploadAvatar() async {
    if (_isUploading) {
      return;
    }

    final fileResult = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (fileResult == null || fileResult.files.isEmpty) {
      return;
    }

    final selectedFile = fileResult.files.single;
    final bytes = selectedFile.bytes;
    if (bytes == null || bytes.isEmpty) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Valitud faili lugemine ebaonnestus.')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final profile = await widget.uploadAvatar(selectedFile.name, bytes);

      if (!mounted) {
        return;
      }

      setState(() {
        _profileFuture = Future<UserProfile>.value(profile);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilt laetud.')), 
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pildi uleslaadimine ebaonnestus: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profiil'),
        actions: [
          TextButton(
            onPressed: widget.onSignOut,
            child: const Text('Logi valja'),
          ),
        ],
      ),
      body: FutureBuilder<UserProfile>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = snapshot.data!;
          _fillControllers(profile);

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user.email,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Vali pilt seadmest ja lae see avatarina ules.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _displayNameController,
                          decoration: const InputDecoration(
                            labelText: 'Nimi',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Sisesta nimi.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _bioController,
                          minLines: 3,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            labelText: 'Luhikirjeldus',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Avatar URL',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(profile.avatarUrl ?? 'Puudub'),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            FilledButton(
                              onPressed: _isSaving ? null : _save,
                              child: Text(_isSaving ? 'Salvestan...' : 'Salvesta profiil'),
                            ),
                            OutlinedButton(
                              onPressed: _isUploading ? null : _uploadAvatar,
                              child: Text(
                                _isUploading
                                    ? 'Laen ules...'
                                    : 'Vali ja lae pilt ules',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
