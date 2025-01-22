import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:source_safe/screen/regester/login.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


class Splash extends StatefulWidget {
  Splash({required this.startwidget, super.key});

  Widget startwidget;


  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    );

    _logoController.repeat(reverse: true);

    // الانتقال إلى HomePage بعد 9 ثوانٍ
    Future.delayed(const Duration(seconds: 7), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  widget.startwidget),
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 800;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 49, 19, 78), // موف فاتح
                  Color.fromARGB(255, 115, 98, 151),//موف

                  Color.fromARGB(255, 7, 120, 232), // أزرق داكن




                ],
              ),
            ),
          ),
          // Animated Logo
          Center(
            child: ScaleTransition(
              scale: _logoAnimation,
              child: Image.asset(
                "assets/images/splash.jpg",
                width: isLargeScreen
                    ? 200
                    : 150, // تغيير الحجم بناءً على حجم الشاشة
                height: isLargeScreen ? 200 : 150,
              ),
            ),
          ),
          // Animated Texts
          Positioned(
            bottom: isLargeScreen ? 150 : 100,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    'Booking System',
                    speed: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    textStyle: TextStyle(
                      fontSize: isLargeScreen
                          ? 30
                          : 24, // تغيير حجم النص بناءً على حجم الشاشة
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Jokerman',
                    ),
                  ),
                  ScaleAnimatedText(
                    'Welcome!',
                    duration: const Duration(milliseconds: 1500),
                    textStyle: TextStyle(
                      fontSize: isLargeScreen ? 30 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Jokerman',
                    ),
                  ),
                  RotateAnimatedText(
                    'Enjoy your stay',
                    duration: const Duration(milliseconds: 1500),
                    textStyle: TextStyle(
                      fontSize: isLargeScreen ? 30 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Jokerman',
                    ),
                  ),
                ],
                repeatForever: true,
              ),
            ),
          ),
          // Loading Indicator
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: const [
                  CircularProgressIndicator(
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Loading...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

