import 'package:flutter/material.dart';
import 'utils/platform_helper.dart';
import 'router.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Only initialize Firebase on supported platforms
  if (isMobilePlatform || isWebPlatform) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(const DogsLifeApp());
}

class DogsLifeApp extends StatelessWidget {
  const DogsLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'dogsLife',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      routerConfig: appRouter,
    );
  }
}
