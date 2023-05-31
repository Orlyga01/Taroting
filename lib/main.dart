import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:taroting/helpers/global_parameters.dart';
import 'package:taroting/spread/spread_screen.dart';
import 'package:taroting/card/camera.dart';

import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'helpers/route.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else if (Platform.isIOS) {
    await Firebase.initializeApp();
  }

  await GlobalParametersTar().setGlobalParameters({
    "language": Platform.localeName,
  });
  runApp(ProviderScope(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Lets do Taroting',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: BeRouter.generateRoute,
        theme: ThemeData(fontFamily: 'MartelSans'),

        //         theme: CustomTheme(context).beMemberTheme,

        home: AnimatedSplashScreen(
            backgroundColor: Colors.white,
            duration: 2500,
            splashIconSize: GlobalParametersTar().screenSize.height,
            nextScreen: HomeScreen(),
            splash: const SizedBox.shrink()));
  }
}
