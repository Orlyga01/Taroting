import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/card/select_card_widget.dart';
import 'package:taroting/helpers/global_parameters.dart';
import 'package:taroting/helpers/providers.dart';
import 'package:taroting/helpers/translations.dart';
import 'package:taroting/spread/spread_controller.dart';
import 'package:sharedor/common_functions.dart';

class CardInSpreadWidget extends ConsumerStatefulWidget {
  InterpretationType iType;
  TCard? card;
  CardInSpreadWidget({this.card, required this.iType, super.key});

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
    bool? doRefresh = ref.watch(watchRefresh);
if (doRefresh == true) {
      widget.card = null;
      _isFrontVisible = false;
      _animationController.reverse();
    }
    String title = enumToString(widget.iType.toString()).capitalize();
    if (watchedcard != null &&
        SpreadController().currentSpread.currentType == widget.iType) {
      widget.card = watchedcard;
    }
    if (widget.card != null && widget.card!.id.isNotEmpty) {
      _isFrontVisible = true;
      _animationController.reverse();
    } 
    return Container(
        width: GlobalParametersTar().screenSize.width / 3.5,
        height: GlobalParametersTar().screenSize.width / 3.5 * 1.5 + 50,
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
                    ? _buildCardSide(title: title)
                    : _buildCardSide(title: title, card: widget.card),
              );
            },
          ),
        ));
  }

  Widget _buildCardSide({String? title, TCard? card}) {
    return Container(
        width: GlobalParametersTar().screenSize.width / 3.5,
        height: (GlobalParametersTar().screenSize.width / 3.5 * 1.5) + 50,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 48, 8, 8),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        title!.TR,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: card != null ? 12 : 16),
                      ),
                    ),
                  ),
                  if (card != null)
                    SizedBox(
                        height: 25,
                        //  alignment: Alignment.topRight,
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  // return object of type Dialog
                                  SpreadController().currentSpread.currentType =
                                      widget.iType;
                                  return AlertDialog(
                                    title: SelectCardWidget(chooseCard: false),
                                  );
                                });
                          },
                          icon: Icon(
                            Icons.refresh_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ))
                ],
              ),
              if (card != null)
                GestureDetector(
                  onTap: () {
                    SpreadController()
                        .loadCard(iType: widget.iType, card: card, ref: ref);
                    ref.read(watchSpreadFullView.notifier).setFullViewState =
                        false;
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/cards/${card.img}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
        ));
  }
}
