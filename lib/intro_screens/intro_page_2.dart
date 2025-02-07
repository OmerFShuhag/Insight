import 'package:flutter/material.dart';

class IntroPage2 extends StatefulWidget {
  @override
  _IntroPage2State createState() => _IntroPage2State();
}

class _IntroPage2State extends State<IntroPage2>
    with SingleTickerProviderStateMixin {
  double opacityLevel = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        opacityLevel = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 1),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              const Color(0xFF004E64),
              const Color(0xFF007D8C),
              const Color(0xFF0ABAB5),
            ],
          ),
        ),
        child: Center(
          child: TweenAnimationBuilder(
            tween: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            builder: (context, Offset offset, child) {
              return Transform.translate(
                offset: offset * 50, // Move up smoothly
                child: AnimatedOpacity(
                  opacity: opacityLevel,
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.storage,
                        size: 100,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Store Your Projects Securely",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "With INSIGHT, keep all your projects safe and organized in one place.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
