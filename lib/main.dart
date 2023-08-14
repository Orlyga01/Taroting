import 'dart:io';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:taroting_pk/helpers/global_parameters.dart';
import 'package:taroting_pk/spread/spread_screen.dart';

import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:taroting_pk/helpers/route.dart';

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
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

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
            nextScreen: SpreadScreen(),
            splash: const SizedBox.shrink()));
  }
}
