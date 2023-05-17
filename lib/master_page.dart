//import 'package:bemember/generic_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:family_menu/helpers/global_parameters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharedor/export_common.dart';
import 'package:sharedor/helpers/device.dart';
import 'dart:ui' as ui;
import 'package:sharedor/widgets/alerts.dart';
import 'package:family_menu/export_all_ui.dart';

class AppMainTemplate extends StatelessWidget {
  final List<Widget> children;
  final Widget? title;
  final bool? isHome;
  final bool? showBack;
  final bool? areYouSure;
  final List<Widget>? persistentFooterButtons;
  final Widget? bottomArea;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? floatingActionButton;
  final List<Widget>? actions;
  final Widget? topLeftArea;
  const AppMainTemplate(
      {Key? key,
      required this.children,
      this.title,
      this.actions,
      this.floatingActionButton,
      this.floatingActionButtonLocation,
      this.persistentFooterButtons,
      this.isHome,
      this.showBack,
      this.areYouSure,
      this.topLeftArea,
      this.bottomArea})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget nav = showBack == true
        ? IconButton(
            icon: Icon(
                Directionality.of(context) == ui.TextDirection.rtl
                    ? Icons.keyboard_arrow_left
                    : Icons.keyboard_arrow_right,
                color: BeStyle.textColor),
            onPressed: () => areYouSure == true
                ? showDialogBe(context, "showOKCancelDialog",
                    onPressOK: () => Navigator.of(context).pop())
                : Navigator.of(context).pop(),
          )
        : (isHome != true)
            ? IconButton(
                color: BeStyle.textColorLight,
                onPressed: () => Navigator.pushNamed(
                      context,
                      "clientlist",
                    ),
                icon: const Icon(LineAwesomeIcons.home))
            : const SizedBox.shrink();

    List<Widget>? actionList;
    if (actions != null) actionList = actions!;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/backgrounds/bg1.jpg',
          repeat: ImageRepeat.repeat,
          height: GlobalParametersFM().screenSize.height,
          width: GlobalParametersFM().screenSize.width,
        ),
        Scaffold(
            key: GlobalKey<ScaffoldState>(),
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            // drawer: MenuDrawer(listTiles: [], outsideContext: context),
            // key: _scaffoldKey,
            appBar: AppBar(
                backgroundColor: Colors.blueGrey.shade50,
                toolbarHeight: 30,
                toolbarTextStyle: TextStyle(color: BeStyle.textColor),
                toolbarOpacity: 0.8,
                title: title ?? const SizedBox.expand(),
                centerTitle: true,
                leading: nav,
                actions: actions),
            floatingActionButton: floatingActionButton,
            floatingActionButtonLocation: floatingActionButtonLocation,
            persistentFooterButtons: persistentFooterButtons,
            body: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                FocusScope.of(context).requestFocus(FocusNode());

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: SafeArea(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 25),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        SizedBox(
                          //   color: Colors.red,
                          height: GlobalParametersFM().screenSize.height * 0.75,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: children.length,
                              itemBuilder: (context, index) {
                                return children[index];
                              }),
                        ),
                        if (bottomArea != null)
                          Positioned.directional(
                              textDirection: Directionality.of(context),
                              end: 0,
                              bottom: 0,
                              child: Align(
                                  alignment: FractionalOffset.bottomCenter,
                                  child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          border: Border(
                                            top: const BorderSide(width: 2),
                                          )),
                                      child: bottomArea!))),
                        if (topLeftArea != null)
                          Positioned.directional(
                              textDirection: Directionality.of(context),
                              end: 0,
                              top: 0,
                              child: Align(
                                  alignment: FractionalOffset.topCenter,
                                  child: topLeftArea)),
                        Consumer(builder: (context, ScopedReader watch, child) {
                          AsyncValue<ConnectivityResult> connectivity =
                              watch(connectivityProvider);

                          NetworkProvider()
                              .pageAlertNoConnectivity(context, connectivity);
                          return const SizedBox.shrink();
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
