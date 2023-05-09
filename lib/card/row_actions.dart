import 'package:flutter/material.dart';
import 'package:sharedor/export_common.dart';
import 'package:sharedor/helpers/export_helpers.dart';

class ListRowActions<T> extends StatefulWidget {
  // bool expanded = false;
  Future<bool> Function(T) onClick;
  bool addCardMode;
  GlobalKey gk = GlobalKey();

  T item;
  ListRowActions({
    Key? key,
    //  required this.expanded,
    required this.onClick,
    this.addCardMode = false,
    required this.item,
  }) : super(key: key);

  @override
  State<ListRowActions> createState() => _ListRowActionsState<T>();
}

class _ListRowActionsState<T> extends State<ListRowActions<T>> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(itemBuilder: (context) {
      return [
        PopupMenuItem(
          value: 'edit',
          child: Text('Edit'),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Text('Delete'),
        )
      ];
    });
  }
}
