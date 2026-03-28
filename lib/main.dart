import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';
import 'services/firebase/firebase_auth_repository.dart';
import 'services/firebase/firebase_profile_repository.dart';
import 'services/firebase/firebase_storage_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await _loadDotEnvIfPresent();

    final provider =
        (dotenv.env['BAAS_PROVIDER'] ?? 'firebase').trim().toLowerCase();

    if (provider == 'firebase') {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      runApp(
        BaaSVordlusApp(
          authRepository: FirebaseAuthRepository(FirebaseAuth.instance),
          profileRepository:
              FirebaseProfileRepository(FirebaseFirestore.instance),
          storageRepository: FirebaseStorageRepository(FirebaseStorage.instance),
        ),
      );
      return;
    }

    if (provider == 'supabase') {
      final url = dotenv.env['SUPABASE_URL'];
      final anonKey = dotenv.env['SUPABASE_PUBLISHABLE_KEY'];
      if (url == null || url.isEmpty || anonKey == null || anonKey.isEmpty) {
        throw const FormatException(
          'SUPABASE_URL voi SUPABASE_PUBLISHABLE_KEY puudub .env failist.',
        );
      }

      await Supabase.initialize(
        url: url,
        anonKey: anonKey,
      );

      runApp(const BaaSVordlusApp());
      return;
    }

    throw FormatException(
      'Tundmatu BAAS_PROVIDER: $provider. Kasuta "firebase" voi "supabase".',
    );
  } catch (error) {
    runApp(_StartupErrorApp(error: error));
  }
}

Future<void> _loadDotEnvIfPresent() async {
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // Firebase config can come entirely from FlutterFire generated options.
  }
}

class _StartupErrorApp extends StatelessWidget {
  const _StartupErrorApp({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Rakendus ei kaivitunud.\n\n$error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
