import 'dart:io';

import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taroting/keys.dart';
import 'package:sharedor/helpers/global_parameters.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tflite/tflite.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'home.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GlobalParameters().setGlobalParameters({
    "language": Platform.localeName,
  });
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Let do Taroting',
        debugShowCheckedModeBanner: false,
        //         theme: CustomTheme(context).beMemberTheme,

        home: AnimatedSplashScreen(
            backgroundColor: Colors.white,
            duration: 2500,
            splashIconSize: GlobalParameters().screenSize.height,
            nextScreen: HomePage(),
            splash: const SizedBox.shrink()));
  }
}
