import 'package:firebase_core/firebase_core.dart';

import '../../environment/app_config.dart';
import 'options/local/firebase_options.dart' as local;
import 'options/staging/firebase_options.dart' as staging;
import 'options/production/firebase_options.dart' as production;

FirebaseOptions firebaseOptionsForEnvironment(AppEnvironment environment) =>
    switch (environment) {
      AppEnvironment.local => local.DefaultFirebaseOptions.currentPlatform,
      AppEnvironment.staging => staging.DefaultFirebaseOptions.currentPlatform,
      AppEnvironment.production =>
        production.DefaultFirebaseOptions.currentPlatform,
    };
