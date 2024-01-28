import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:sharedor/widgets/logo_spin.dart';
import 'package:taroting_pk/helpers/global_parameters.dart';
import 'package:taroting_pk/spread/spread_screen.dart';
import 'package:sharedor/helpers/global_parameters.dart';

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

  await GlobalParametersTar().setGlobalParameters({});
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
            backgroundColor: Colors.white,
            duration: 2500,
            splashIconSize: GlobalParameters().screensize.height,
            nextScreen: SpreadScreen(),
            splash: const SizedBox.shrink()));
  }
}

class Circle {
  double size;
  Color color;
  Size position;
  double opacity = 1;
  Circle(this.size, this.color, this.position, this.opacity);
  void set setOpacity(value) => opacity = value;
}

class SplashScreen extends StatefulWidget {
  SplashScreen({
    Key? key,
  }) : super(key: key);
  List<Circle> circleList = [];

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<Widget> widList = [];
  double opacityState = 0;
  double get getOpacity => opacityState;
  @override
  void initState() {
    super.initState();
    if (widList.length == 0) widList = createChildren();
    int i = 0;
    Timer.periodic(Duration(milliseconds: (400)), (timer) async {
      context.read(opacityStateChanged).setOpacity(i);
      if (i == widList.length - 1) timer.cancel();
      i++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Stack(fit: StackFit.expand, children: widList));
  }

  List<Widget> createChildren() {
    List<Widget> list = [];

    for (var i = 0; i < 10; i++) {
      Circle circle = getCircle();
      widget.circleList.add(circle);
      list.add(getElement(circle, i));
    }
    return list;
  }

  Widget getElement(Circle circle, int i) {
    return Positioned(
      top: circle.position.height,
      left: circle.position.width,
      child: Consumer(builder: (consumercontext, ref, child) {
        double opacity = ref.watch(opacityStateChanged).getOpacity(i);
        return Opacity(
          opacity: opacity,
          child: LogoSpinner(height: circle.size, color: circle.color),
        );
      }),
    );
  }

  double randomHight(int cirSize) {
    return (20 +
            Random().nextInt(
                GlobalParameters().screenSize.height.truncate() - 20 - cirSize))
        .toDouble();
  }

  int randomCircleSize() {
    return (4 + Random().nextInt(21)) * 10;
  }

  double randomWidth(int cirSize) {
    return 20 +
        Random()
            .nextInt(
                GlobalParameters().screenSize.width.truncate() - 20 - cirSize)
            .toDouble();
  }

  Circle getCircle() {
    List<Color> colors = [Colors.yellow, Colors.green, Colors.blue, Colors.red];
    int cirSize = randomCircleSize();
    Circle circle = Circle(cirSize.toDouble(), colors[Random().nextInt(4)],
        Size(randomWidth(cirSize), randomHight(cirSize)), 0);
    return circle;
  }
}

final opacityStateChanged = ChangeNotifierProvider.autoDispose<OpacityState>(
    (ref) => new OpacityState());

class OpacityState extends ChangeNotifier {
  List<double> opacityList = [0, 0, 0, 0, 0, 0, 0, 0];

  void setOpacity(i) {
    opacityList[i] = 1;
    notifyListeners();
  }

  double getOpacity(i) {
    return opacityList[i];
  }
}
