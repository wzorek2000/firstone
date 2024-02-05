import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'content/pages/onboarding.dart';
import 'content/pages/login.dart';
import 'content/mainPages/page1.dart';
import 'content/pages/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'content/themes/theme_manager.dart';
import 'content/notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  NotificationService().init();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final int themeIndex = prefs.getInt('selectedIndex') ?? 0;
  final themeManager = ThemeManager();
  themeManager.setTheme(themeIndex);

  runApp(ChangeNotifierProvider(
    create: (context) => themeManager,
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    updateFcmToken();
  }

  Future<bool> checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstSeen = (prefs.getBool('first_seen') ?? true);
    if (firstSeen) {
      prefs.setBool('first_seen', false);
    }
    return firstSeen;
  }

  Future<Widget> decideFirstScreen() async {
    bool firstSeen = await checkFirstSeen();
    if (firstSeen) {
      return const OnBoardingScreen();
    } else {
      if (FirebaseAuth.instance.currentUser == null) {
        return const LoginScreen();
      } else {
        return const ContentScreen();
      }
    }
  }

  void updateFcmToken() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null && FirebaseAuth.instance.currentUser != null) {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance.collection('userActivity').doc(userId).set({
        'fcmToken': fcmToken,
        'lastActive': DateTime.now(),
      }, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: decideFirstScreen(),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Consumer<ThemeManager>(
            builder: (context, themeManager, child) {
              return MaterialApp(
                theme: themeManager.themeData,
                home: snapshot.data!,
                routes: {
                  '/settings': (_) => const SettingsScreen(),
                },
              );
            },
          );
        } else {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
      },
    );
  }
}
