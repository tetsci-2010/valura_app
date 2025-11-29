import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:valura/constants/images_paths.dart';
import 'package:valura/features/screens/main_screens/home_screen/home_screen.dart';
import 'package:valura/utils/size_constant.dart';

class SplashScreen extends StatefulWidget {
  static const String id = '/splash_screen';
  static const String name = 'splash_screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    try {
      Timer(const Duration(seconds: 3), () {
        context.go(HomeScreen.id);
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(1000),
            child: Image.asset(
              ImagesPaths.valuraTextJpg,
              height: sizeConstants.imageLarge,
            ),
          ),
        ),
      ),
    );
  }
}
