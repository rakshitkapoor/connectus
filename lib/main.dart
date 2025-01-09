import 'package:connectus/colors.dart';
import 'package:connectus/common/widgets/error.dart';
import 'package:connectus/common/widgets/loader.dart';
import 'package:connectus/features/auth/controller/auth_controller.dart';
import 'package:connectus/features/landing/screens/landing_screen.dart';
import 'package:connectus/firebase_options.dart';
import 'package:connectus/router.dart';
import 'package:connectus/screens/mobile_layout_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ConnectUs',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(color: appBarColor),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: ref
          .watch(userDataAuthProvider)
          .when(
            data: (user) {
              if (user == null) {
                return LandingScreen();
              }
              return MobileLayoutScreen();
            },
            error: (err, trace) {
              return ErrorScreen(error: err.toString());
            },
            loading: () => const Loader(),
          ),
    );
  }
}
