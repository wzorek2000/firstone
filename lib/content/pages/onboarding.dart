import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'login.dart';
import '../themes/theme_selector.dart';

void requestPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.notification,
    Permission.phone,
    Permission.storage,
    Permission.camera,
    Permission.photos,
    Permission.activityRecognition,
    Permission.appTrackingTransparency,
    Permission.scheduleExactAlarm,
  ].request();

  statuses.forEach((permission, status) {
    print('$permission: $status');
  });
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        title: "Witaj",
        body: "Dziękujemy za pobranie naszej aplikacji",
        image: Lottie.asset('assets/Animation - 1699395967791.json'),
      ),
      PageViewModel(
        title: "",
        bodyWidget: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 200),
              Text(
                "Wybierz motyw",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              ThemeSelector(),
            ],
          ),
        ),
      ),
      PageViewModel(
        title: "Nadaj kilka uprawnień",
        body:
            "Potrzebujemy kilku uprawnień do poprawnego działania aplikacji. Po naciśnięciu przycisku zostaniesz o nie zapytany.",
        image: Lottie.asset('assets/Animation - 1699395967791.json'),
        footer: const ElevatedButton(
          onPressed: requestPermissions,
          child: Text('Nadaj uprawnienia'),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: getPages(),
      onDone: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      },
      next: const Icon(Icons.arrow_forward),
      done: const Text("Gotowe", style: TextStyle(fontWeight: FontWeight.w600)),
      globalBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
