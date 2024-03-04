import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:sharedor/widgets/logo_spin.dart';
import 'package:taroting/home.dart';
import 'package:taroting_pk/helpers/global_parameters.dart';
import 'package:taroting_pk/spread/spread_screen.dart';
import 'package:sharedor/helpers/global_parameters.dart';
import 'package:yaml/yaml.dart';

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
  String x = await rootBundle.loadString("pubspec.yaml");
  var yaml = loadYaml(x);

  await GlobalParametersTar().setGlobalParameters({"version": yaml["version"]});
  runApp(InheritedConsumer(child: ProviderScope(child: const MainApp())));
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
            backgroundColor: Color.fromARGB(255, 8, 0, 0),
            duration: 2500,
            splashIconSize: GlobalParameters().screensize.height,
            nextScreen: SpreadScreen(),
            splash: const SizedBox.shrink()));
  }

  //       home: AnimatedSplashScreen(
  //           backgroundColor: Colors.white,
  //           duration: 2500,
  //           splashIconSize: GlobalParameters().screensize.height,
  //           nextScreen: TwinklingStarsScreen(),
  //           splash: const SizedBox.shrink()));
  // }
}
// Route _createRoute() {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => SecondPage(),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       var begin = Offset(0.0, -1.0);
//       var end = Offset.zero;
//       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.ease));
//       var offsetAnimation = animation.drive(tween);

//       return FadeTransition(
//         opacity: animation,
//         child: SlideTransition(
//           position: offsetAnimation,
//           child: child,
//         ),
//       );
//     },
//   );
// }