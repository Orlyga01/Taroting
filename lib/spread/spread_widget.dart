// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:taroting/Interpretation/interpretation_model.dart';
// import 'package:taroting/card/card_model.dart';
// import 'package:taroting/helpers/providers.dart';
// import 'package:taroting/spread/spread_model.dart';
// import 'package:sharedor/common_functions.dart';

// class SpreadWidget extends ConsumerWidget {
//   SpreadModel spread;

//   SpreadWidget(this.spread, {super.key});

//   @override
//   Widget build(BuildContext context, ref) {
//     spread = ref.watch(watchSpreadChange).getSpread;
//     Map<InterpretationType, TCard>? results = spread.results ?? {};
//     return ListView.builder(
//         itemCount: results.length,
//         shrinkWrap: true,
//         itemBuilder: (context, index) {
//           InterpretationType iType = results.keys.toList()[index];
//           TCard card = results[iType]!;
//           String? inter = results[iType]!.getInterByType(iType);
//           return card.id.isNotEmpty
//               ? ExpandableTile(
//                   title: enumToString(iType.toString()),
//                   image: card.img,
//                   description: inter ?? "loading")
//               : SizedBox.shrink();
//         });
//   }
// }

// class ExpandableTile extends StatefulWidget {
//   final String title;
//   final String image;
//   final String description;

//   ExpandableTile({
//     required this.title,
//     required this.image,
//     required this.description,
//   });

//   @override
//   _ExpandableTileState createState() => _ExpandableTileState();
// }

// class _ExpandableTileState extends State<ExpandableTile> {
//   bool isExpanded = false;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ListTile(
//           title: Text(widget.title),
//           onTap: () {
//             setState(() {
//               isExpanded = !isExpanded;
//             });
//           },
//         ),
//         AnimatedContainer(
//           duration: Duration(milliseconds: 300),
//           height: isExpanded ? 300 : 50,
//           child: Stack(
//             children: [
//               Row(
//                 children: [
//                   SizedBox(
//                     width: 100,
//                     child: Image.asset(
//                       'assets/cards/${widget.image}',
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                   Expanded(
//                       child: Text(
//                     widget.description,
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 16,
//                     ),
//                   ))
//                 ],
//               ),
//               if (!isExpanded)
//                 Positioned.fill(
//                   bottom: 0,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           Colors.white.withOpacity(0.0),
//                           Colors.white,
//                         ],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         stops: [0.7, 1.0],
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
