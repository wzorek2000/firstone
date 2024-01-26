import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BreathingAnimationPage extends StatefulWidget {
  const BreathingAnimationPage({super.key});

  @override
  _BreathingAnimationPageState createState() => _BreathingAnimationPageState();
}

class _BreathingAnimationPageState extends State<BreathingAnimationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _colorAnimation;
  late Animation<double> _scaleAnimation;
  String _breathingText = 'Kliknij aby zacząć';
  final Uri _youtubeUrl =
      Uri.parse('https://www.youtube.com/watch?v=JJfYqWSAMCg');

  Future<void> _launchURL() async {
    if (!await launchUrl(_youtubeUrl)) {
      throw 'Could not launch $_youtubeUrl';
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {
          if (_animationController.value < 0.1) {
            _breathingText = 'Wdech';
          } else if (_animationController.value > 0.9) {
            _breathingText = 'Wydech';
          }
        });
      });

    _colorAnimation = ColorTween(begin: Colors.blue[300], end: Colors.red[400])
        .animate(_animationController);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _animationController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleAnimation() {
    setState(() {
      if (!_animationController.isAnimating) {
        _animationController.forward();
        _breathingText = 'Wdech';
      } else {
        _animationController.reset();
        _breathingText = 'Kliknij aby zacząć';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ćwiczenia oddechowe'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: toggleAnimation,
            child: Center(
              child: AnimatedBuilder(
                animation: Listenable.merge([_scaleAnimation, _colorAnimation]),
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _colorAnimation.value,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _breathingText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 120),
          ElevatedButton(
            onPressed: _launchURL,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.purple[400],
            ),
            child: const Text('Obejrzyj bardziej kompleksowe ćwiczenia'),
          )
        ],
      ),
    );
  }
}
