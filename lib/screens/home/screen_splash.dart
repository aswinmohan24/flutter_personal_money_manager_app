import 'package:flutter/material.dart';

import 'package:money_manager_flutter/screens/home/screen_home.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    splashScreen(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
          child: AnimatedTextKit(animatedTexts: [
        ScaleAnimatedText(
          '\t\t\t\t Personal\nMoney Manager',
          textStyle: const TextStyle(
              color: Colors.white, fontSize: 45, fontWeight: FontWeight.bold),
        ),
      ])),
    );
  }

  Future<void> splashScreen(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
      return ScreenHome();
    }));
  }
}
