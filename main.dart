
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:baas_vordlus/app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');

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
  } catch (error) {
    runApp(_StartupErrorApp(error: error));
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