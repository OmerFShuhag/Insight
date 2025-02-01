import 'package:flutter/material.dart';

class IntroPage2 extends StatefulWidget {
  @override
  _IntroPage2State createState() => _IntroPage2State();
}

class _IntroPage2State extends State<IntroPage2> with SingleTickerProviderStateMixin {
  double opacityLevel = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        opacityLevel = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.teal],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: TweenAnimationBuilder(
            tween: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)),
            duration: Duration(milliseconds: 800),
            curve: Curves.easeOut,
            builder: (context, Offset offset, child) {
              return Transform.translate(
                offset: offset * 50, // Move up smoothly
                child: AnimatedOpacity(
                  opacity: opacityLevel,
                  duration: Duration(milliseconds: 800),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.storage,
                        size: 100,
                        color: Colors.white,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Store Your Projects Securely",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "With INSIGHT, keep all your projects safe and organized in one place. ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
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
