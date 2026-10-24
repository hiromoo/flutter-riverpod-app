import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../environment/app_config.dart';

class BackendServices {
  const BackendServices({
    required this.supabase,
    required this.auth,
    required this.firestore,
  });
  final SupabaseClient supabase;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  static Future<BackendServices> initialize(
    AppConfig config, {
    required FirebaseOptions firebaseOptions,
    TargetPlatform? platform,
    bool? isWeb,
  }) async {
    final web = isWeb ?? kIsWeb;
    final target = platform ?? defaultTargetPlatform;
    await Supabase.initialize(
      url: config.supabaseEndpoint,
      publishableKey: config.supabasePublishableKey,
    );
    final firebase = await Firebase.initializeApp(options: firebaseOptions);
    final auth = FirebaseAuth.instanceFor(app: firebase);
    final firestore = FirebaseFirestore.instanceFor(app: firebase);
    final emulators = config.firebaseEmulators(isWeb: web, platform: target);
    if (emulators != null) {
      await auth.useAuthEmulator(
        emulators.host,
        FirebaseEmulatorEndpoints.authPort,
      );
      firestore.useFirestoreEmulator(
        emulators.host,
        FirebaseEmulatorEndpoints.firestorePort,
      );
    }
    return BackendServices(
      supabase: Supabase.instance.client,
      auth: auth,
      firestore: firestore,
    );
  }
}

final backendServicesProvider = Provider<BackendServices>(
  (ref) => throw StateError(
    'BackendServices must be initialized in main before runApp.',
  ),
);
