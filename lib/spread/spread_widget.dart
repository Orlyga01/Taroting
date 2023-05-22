import 'package:flutter/material.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/spread/spread_model.dart';
import 'package:sharedor/common_functions.dart';

class SpreadWidget extends StatefulWidget {
  SpreadModel spread;

  SpreadWidget(this.spread, {super.key});

  @override
  State<SpreadWidget> createState() => _SpreadWidgetState();
}

class _SpreadWidgetState extends State<SpreadWidget> {
  @override
  Widget build(BuildContext context) {
    Map<InterpretationType, SpreadResultModel>? results =
        widget.spread.results ?? {};
    return ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          InterpretationType iType = results.keys.toList()[index];
          TCard card = results[index]!.card;
          String inter = results[index]!.inter;
          return ExpandableTile(
              title: enumToString(iType.toString()),
              image: card.img,
              description: inter);
        });
  }
}

class ExpandableTile extends StatefulWidget {
  final String title;
  final String image;
  final String description;

  ExpandableTile({
    required this.title,
    required this.image,
    required this.description,
  });

  @override
  _ExpandableTileState createState() => _ExpandableTileState();
}

class _ExpandableTileState extends State<ExpandableTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(widget.title),
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: isExpanded ? 100 : 0,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  widget.image,
                  fit: BoxFit.cover,
                ),
              ),
              if (!isExpanded)
                Positioned.fill(
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.7, 1.0],
                      ),
                    ),
                  ),
                ),
              Positioned.fill(
                bottom: 8.0,
                right: 8.0,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    widget.description,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
