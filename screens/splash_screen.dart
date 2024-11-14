import 'dart:developer';

import 'package:buzz_chat/api/apis.dart';
import 'package:buzz_chat/screens/auth/login_screen.dart';
import 'package:buzz_chat/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 2000), () {

      //exit full screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(systemNavigationBarColor: Colors.white, statusBarColor: Colors.white),
      );

      if(APIs.auth.currentUser != null){
        log('\nUser ${APIs.auth}');
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(),
        ),
      );
      }else{
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LoginScreen(),
        ),
      );
      }

      
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: mq.height * .35,
            width: mq.width * .5,
            right: mq.width * .25,
            child: Image.asset('images/chat.png'),
          ),
          Positioned(
            bottom: mq.height * .15,
            width: mq.width,
            child: Text(
              'Welcome to Buzz Chat 💙',
              style: TextStyle(
                  fontSize: 16, color: Colors.black87, letterSpacing: .5),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
