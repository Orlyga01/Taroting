// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:cleanedapp/export_all_ui.dart';
// import 'package:cleanedapp/helpers/global_parameters.dart';
// import 'package:cleanedapp/master_page.dart';
// import 'package:cleanedapp/misc/providers.dart';
// import 'package:cleanedapp/card/card_model.dart';
// import 'package:cleanedapp/card/card_widget.dart';
// import 'package:cleanedapp/user/be_user_controller.dart';
// import 'package:cleanedapp/user/be_user_edit_widget.dart';
// import 'package:riverpod_context/riverpod_context.dart';
// import 'package:sharedor/export_common.dart';
// import 'package:sharedor/external_export_view.dart';
// import 'package:sharedor/helpers/export_helpers.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:reorderables/reorderables.dart';
// import 'package:sharedor/widgets/first_row_list_add.dart';
// import 'package:sharedor/widgets/expanded_inside_list.dart';
// import 'package:sharedor/widgets/radio_buttons.dart';

// import '../user/be_user_model.dart';

// class CardListScreen extends StatelessWidget {
//   final GlobalKey<CardListWidgetState> _key = GlobalKey<CardListWidgetState>();
//   BeUser user = BeUserController().user;

//   // ignore: use_key_in_widget_constructors
//   CardListScreen({Key? key});
//   @override
//   Widget build(BuildContext context) {
//     return AppMainTemplate(
//         isHome: true,
//         inPageTitle: "Manage house cleaning task".ctr(),
//         title: const Text("Clean App"),
//         floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
//         children: [
//           CardListWidget(
//             key: _key,
//             cards: testCards,
//           )
//         ]);
//   }
// }

// class CardListWidget extends StatefulWidget {
//   final List<Card> cards;
//   bool? updateCardMode = true;
//   bool tileExpanded = false;
//   final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

//   CardListWidget({
//     Key? key,
//     required this.cards,
//   }) : super(key: key);
//   @override
//   State<CardListWidget> createState() => CardListWidgetState();
//   // GlobalKey<FormBuilderState>? _formKey =
//   //     GlobalKey<FormBuilderState>(debugLabel: "bla");
// }

// class CardListWidgetState extends State<CardListWidget> {
//   BeUser user = BeUserController().user;
//   late Map<String, GlobalKey<FormState>> gkCard = {};
//   List<Card> cards = [];
//   bool editState = false;

//   //     if (user != null) CardController().setCurrentCardList(user!.cards);

//   @override
//   void initState() {
//     user = BeUserController().user;
//     cards = user.cards;

//     for (var item in user.cards) {
//       gkCard[item.id] = GlobalKey<FormState>();
//     }

//     super.initState();
//   }

//   Future<void> updateCardsList(List<Card> cards) async {
//     try {
//       await BeUserController().updateCardListOfUser(cards);
//       setState(() {});
//     } catch (e) {
//       showAlertDialog(e.toString(), context);
//     }
//   }

//   Future<bool> deleteCard(Card card, BuildContext context) async {
//     try {
//       await BeUserController().deleteUserCard(card);
//       // ignore: use_build_context_synchronously
//       context.read(userStateChanged.notifier).setNotifyUserChange();
//     } catch (e) {
//       log(e.toString());
//       // showAlertDialog(e.toString(), context);
//       return false;
//     }

//     return true;
//   }

//   void _onReorder(int oldIndex, int newIndex) {
//     //abort if first row has been dragged or if try to drag above the first row
//     if (oldIndex == 0 || newIndex == 0) {
//       oldIndex = newIndex;
//     } else {
//       Card orig = cards[oldIndex - 1];
//       cards.removeAt(oldIndex - 1);
//       cards.insert(newIndex - 1, orig);
//       // cards[newIndex] = orig;
//       updateCardsList(cards);
//     }
//     setState(() {
//       // Widget row = _rows.removeAt(oldIndex);
//       // _rows.insert(newIndex, row);
//     });
//   }

//   HouseType houseType = HouseType.flat;
//   final ScrollController reorderScrollController = ScrollController();

//   @override
//   Widget build(BuildContext context) {
//     // Make sure there is a scroll controller attached to the scroll view that contains ReorderableSliverList.
//     // Otherwise an error will be thrown.
//     return Consumer(builder: (consumercontext, WidgetRef ref, child) {
//       ref.watch(userStateChanged);
//       bool initialState = user.name.isEmptyBe;
//       print('in$initialState');
//       return SizedBox(
//         height: GlobalParametersFM().screenSize.height,
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: BeUserEditWidget(),
//             ),
//             Flexible(
//               child: AbsorbPointer(
//                 absorbing: initialState,
//                 child: Opacity(
//                   opacity: initialState ? 0.4 : 1,
//                   child: Column(
//                     children: [
//                       listTemplateSelection(),
//                       buildListCard(user.cards),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }

//   Widget listTemplateSelection() {
//     if (user.id.isEmptyBe || user.listsid.isEmptyBe) return SizedBox.shrink();
//     return RadioButtonWidget(
//         selectedItem: HouseType.flat,
//         items: HouseType.values,
//         onChange: (value) {
//           setSate() {
//             houseType = value;
//           }
//         });
//   }

//   Widget buildListCard(List<Card> cards) {
//     List<Widget> _rows = [];
//     _rows = List<Widget>.generate(
//       cards.length,
//       (int index) {
//         Card item = cards[index];
//         return Container(
//           color: Colors.greenAccent,
//           key: ValueKey(item.id),
//           child:
//               //Text("id:" + (cards[index].id)
//               ExapndableInList<Card>(
//                   item: item,
//                   extraActions: [
//                     IconButton(
//                         padding: const EdgeInsetsDirectional.only(end: 8),
//                         constraints: const BoxConstraints(),
//                         onPressed: () async {
//                           Navigator.pushNamed(context, "backofficecard",
//                               arguments: {"cardid": item.id});
//                         },
//                         icon: const Icon(LineAwesomeIcons.tasks)),
//                   ],
//                   leading:
//                       Icon(CardTypes[item.type]!.icon ?? Icons.abc_outlined),
//                   title: Container(color: Colors.blue, child: Text(item.title)),
//                   formkey: widget._formkey,
//                   onClickDelete: (Card item) => deleteCard(item, context),
//                   expandedChild: CardWidget(
//                     formKey: GlobalKey<FormState>(),
//                     card: cards[index],
//                     onChanged: (Card item) {
//                       cards[index] = item;
//                     },
//                   )),
//         );
//       },
//     );
//     Card emptycard = Card.empty;
//     _rows = <Widget>[
//           Container(
//             key: const ValueKey('0'),
//             child: NewObjectInList<Card>(
//                 item: emptycard,
//                 addTitle: "Add card",
//                 formkey: widget._formkey,
//                 //  onClick: (Card item) => ,
//                 addCardMode: true,
//                 expandedChild: CardWidget(
//                   formKey: widget._formkey,
//                   card: emptycard,
//                   onChanged: (Card item) {
//                     emptycard = item;
//                   },
//                 )),
//           )
//         ] +
//         _rows;
//     return ReorderableColumn(
//       children: _rows,
//       onReorder: _onReorder,
//       scrollController: reorderScrollController,
//     );
//   }
// }
