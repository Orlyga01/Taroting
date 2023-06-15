import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/helpers/global_parameters.dart';
import 'package:taroting/helpers/providers.dart';
import 'package:taroting/spread/spread_controller.dart';

class CardInSpreadWidget extends ConsumerStatefulWidget {
  InterpretationType iType;
  CardInSpreadWidget({required this.iType, super.key});

  @override
  ConsumerState<CardInSpreadWidget> createState() => _CardInSpreadWidgetState();
}

class _CardInSpreadWidgetState extends ConsumerState<CardInSpreadWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _frontAnimation;
  late Animation<double> _backAnimation;
  bool _isFrontVisible = false;
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _frontAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _backAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleCard() {
    if (_isFrontVisible) {
      _animationController.forward();
    } else {
      if (SpreadController().currentSpread.isRandom != true) {
        //if there is no card yet and its not random then we need to show the camera
        ref.read(watchOpenCamera.notifier).setCameraState = true;
        SpreadController().currentSpread.currentType = widget.iType;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TCard? watchedcard = ref.watch(watchCard);
    TCard? card;
    if (watchedcard != null &&
        SpreadController().currentSpread.currentType == widget.iType) {
      card = watchedcard;
      _isFrontVisible = true;
      _animationController.reverse();
    }

    return Container(
        width: GlobalParametersTar().screenSize.width / 3.5,
        height: GlobalParametersTar().screenSize.width / 3.5 * 1.5,
        child: GestureDetector(
          onTap: _toggleCard,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (BuildContext context, Widget? child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(_isFrontVisible
                      ? 0
                      : 3.141592653589793 * _backAnimation.value),
                child: !_isFrontVisible
                    ? _buildCardSide(title: "Subject")
                    : _buildCardSide(card: card),
              );
            },
          ),
        ));
  }

  Widget _buildCardSide({String? title, TCard? card}) {
    return Container(
        width: GlobalParametersTar().screenSize.width / 3.5,
        height: GlobalParametersTar().screenSize.width / 3.5 * 1.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: card != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "assets/cards/${card.img}",
                  fit: BoxFit.cover,
                ),
              )
            : Text(title!));
  }
}
