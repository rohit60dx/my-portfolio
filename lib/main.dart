// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:rohit_portfolio/firebase_options.dart';
// import 'screens/home_screen.dart';
// import 'utils/theme.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   // Firebase Analytics init
//   final analytics = FirebaseAnalytics.instance;
//   await analytics.logAppOpen();

//   FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
//   await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

//   runApp(PortfolioApp(analytics: analytics));
// }

// class PortfolioApp extends StatelessWidget {
//   final FirebaseAnalytics analytics;
//   const PortfolioApp({super.key, required this.analytics});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Rohit Kumar — Flutter Developer',
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.darkTheme,
//       navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
//       home: const HomeScreen(),
//     );
//   }
// }

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rohit_portfolio/firebase_options.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // // Crashlytics Setup
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  // Optional: Analytics
  final analytics = FirebaseAnalytics.instance;
  await analytics.logAppOpen();

  runApp(PortfolioApp(analytics: analytics));
}

class PortfolioApp extends StatelessWidget {
  final FirebaseAnalytics analytics;
  const PortfolioApp({super.key, required this.analytics});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rohit Kumar — Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
      home: const HomeScreen(),
    );
  }
}
