import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:taroting/helpers/global_parameters.dart';
import 'firebase_options.dart';

import 'home.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(  options: DefaultFirebaseOptions.currentPlatform,
);
  await GlobalParametersTar().setGlobalParameters({
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
            splashIconSize: GlobalParametersTar().screenSize.height,
            nextScreen: HomePage(),
            splash: const SizedBox.shrink()));
  }
}
