import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharedor/export_common.dart';
import 'package:taroting_pk/helpers/sparkle.dart';

class Circle {
  double size;
  Color color;
  Size position;
  double opacity = 1;
  Circle(this.size, this.color, this.position, this.opacity);
  void set setOpacity(value) => opacity = value;
}

class SplashScreen extends ConsumerStatefulWidget {
  SplashScreen({
    Key? key,
  }) : super(key: key);
  List<Circle> circleList = [];

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  List<Widget> widList = [];
  double opacityState = 0;
  late Size screensize;
  double get getOpacity => opacityState;
  bool disposed = false;
  @override
  void initState() {
    super.initState();
    screensize = MediaQueryData.fromView(
            WidgetsBinding.instance.platformDispatcher.views.single)
        .size;
    if (widList.length == 0) widList = createChildren();
    int i = 1;
    Timer.periodic(Duration(milliseconds: (400)), (timer) async {
      if (mounted) {
        print(i);
        ref.read(opacityStateChanged).setOpacity(i);
        if (i == widList.length - 1 || disposed == true) timer.cancel();
        i++;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    disposed = true;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Stack(fit: StackFit.expand, children: widList));
    //child: Text("dfdfdfdfd"));
  }

  List<Widget> createChildren() {
    List<Widget> list = [];

    for (var i = 0; i < 40; i++) {
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
          // child: LogoSpinner(height: circle.size, color: circle.color),
          child: Sparkler(),
        );
      }),
    );
  }

  double randomHight(int cirSize) {
    return (20 + Random().nextInt(screensize.height.truncate() - 20 - cirSize))
        .toDouble();
  }

  int randomCircleSize() {
    return (4 + Random().nextInt(21)) * 10;
  }

  double randomWidth(int cirSize) {
    return 20 +
        Random().nextInt(screensize.width.truncate() - 20 - cirSize).toDouble();
  }

  Circle getCircle() {
    List<Color> colors = [
      BeStyle.main,
      const Color.fromARGB(255, 175, 247, 94),
      Color.fromARGB(255, 70, 122, 11),
      Colors.lightGreen
    ];
    int cirSize = randomCircleSize();
    Circle circle = Circle(cirSize.toDouble(), colors[Random().nextInt(4)],
        Size(randomWidth(cirSize), randomHight(cirSize)), 0);
    return circle;
  }
}

final opacityStateChanged = ChangeNotifierProvider.autoDispose<OpacityState>(
    (ref) => new OpacityState());

class OpacityState extends ChangeNotifier {
  List<double> opacityList = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  void setOpacity(i) {
    opacityList[i] = 1;
    notifyListeners();
  }

  double getOpacity(i) {
    return opacityList[i % 10];
  }
}

class TwinklingStarsScreen extends StatefulWidget {
  const TwinklingStarsScreen({super.key});

  @override
  State<TwinklingStarsScreen> createState() => _TwinklingStarsScreenState();
}

class _TwinklingStarsScreenState extends State<TwinklingStarsScreen> {
  List<Widget> stars = [];
  Random random = Random();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: stars,
    );
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 80; i++) {
      stars.add(_buildStar());
    }
  }

  Widget _buildStar() {
    Size screensize = MediaQueryData.fromView(
            WidgetsBinding.instance.platformDispatcher.views.single)
        .size;
    return Positioned(
      top: random.nextDouble() * screensize.height,
      left: random.nextDouble() * screensize.width,
      child: Sparkler(
        size: random.nextDouble() * 30 + 10, // Random size between 10 and 40
      ),
    );
  }

  void _updateStars() {
    setState(() {
      stars = List.generate(20, (index) => _buildStar());
    });
  }
}
