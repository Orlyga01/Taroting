import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:sharedor/sharedor.dart';
import 'package:taroting/Interpretation/interpretation_controller.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/card/card_controller.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/helpers/global_parameters.dart';
import 'package:taroting/helpers/providers.dart';
import 'package:taroting/spread/spread_controller.dart';

final xFileProvider = StateProvider((ref) => File(''));

class CaptureCameraWidget extends ConsumerStatefulWidget {
  CaptureCameraWidget({super.key});
  static const routeName = 'home-screen';
  late img.Image cropped;
  bool? loaded = false;
  bool showCamera = false;
  @override
  _CaptureCameraWidgetState createState() => _CaptureCameraWidgetState();
}

class _CaptureCameraWidgetState extends ConsumerState<CaptureCameraWidget> {
  late CameraController controller;
  late Image imgController;
  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    final xFileState = ref.watch(xFileProvider);
    widget.showCamera = ref.watch(watchOpenCamera);
    return widget.showCamera == false
        ? const SizedBox.shrink()
        : FutureBuilder(
            future: initializationCamera(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return loaded
                    ? Image.file(File(xFileState.path))
                    : Container(
                        height: GlobalParametersTar().screenSize.height * 0.9,
                        padding: const EdgeInsets.only(
                          top: 5,
                        ),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                                height:
                                    GlobalParametersTar().screenSize.height *
                                            0.9 -
                                        100,
                                child: CameraPreview(controller)),
                            Container(
                              height: GlobalParametersTar().screenSize.height *
                                      0.9 -
                                  100,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(color: Colors.black)),
                                  Container(

                                    height: GlobalParametersTar()
                                                .screenSize
                                                .height *
                                            0.9 -
                                        100,
                                    child: Image.asset(
                                      'assets/camera-overlay-conceptcoder.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(color: Colors.black)),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width: GlobalParametersTar().screenSize.width -
                                    100,
                                child: Stack(
                                  children: [
                                    ClickWithSpin(
                                      onClicked: onTakePicture,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              bottom: 0,
                              child: InkWell(
                                onTap: () {
                                  SpreadController().setCurrentType =
                                      SpreadController().currentSpread.prevType;
                                  ref
                                      .read(watchOpenCamera.notifier)
                                      .setCameraState = false;
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 0),
                                  child: CircleAvatar(
                                      radius: 30.0,
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.close,
                                          color: Colors.black)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
  }

  Future<void> initializationCamera() async {
    var cameras = await availableCameras();
    controller = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    await controller.initialize();
  }

  void onTakePicture() async {
    // TCardController().onTimeRun();
    // return;
    await controller.takePicture().then((XFile xfile) async {
      if (mounted) {
        Size size = MediaQuery.of(context).size;
        if (xfile != null) {
          final bytes = await xfile.readAsBytes();
          //   final image = img.decodeImage(bytes);
          File? cr = await cropImage(
              xfile.path, 20, 60, size.width - 40, (size.width - 40) * 1.5);
          // showDialog(
          //     context: context,
          //     builder: (_) {
          //       // return object of type Dialog

          //       return AlertDialog(
          //         title: Image.file(File(cr!.path)),
          //       );
          //     });
          try {
            TCard? card = await TCardController().identifyTCard(cr!.path);
            card = TCardController().currentCard;
            SpreadController().saveCroppedImg = cr.path;
            if (card != null) {
              SpreadController().updateSpread(card);
              await SpreadController().loadCard(card: card, ref: ref);

              ref.read(watchOpenCamera.notifier).setCameraState = false;
            }
          } catch (e) {
            // ignore: use_build_context_synchronously
            showDialog(
                context: context,
                builder: (_) {
                  // return object of type Dialog

                  return AlertDialog(
                      title: const Text(
                          " Sorry - the card was not found. Please take a picture again."),
                      actions: [
                        OutlinedButton(
                            key: const Key("alertOKBtn"),
                            onPressed: () {
                              ref
                                  .read(watchOpenCamera.notifier)
                                  .setCameraState = true;
                              Navigator.of(context).pop();
                            },
                            child: const Text("OK"))
                      ]);
                });
          }
        }
      }
    });
  }
}

Future<File?> cropImage(
    String imagePath, double x, double y, double width, double height) async {
  // Read the image file
  final File imageFile = File(imagePath);
  final List<int> imageBytes = await imageFile.readAsBytes();
  final img.Image? image = img.decodeImage(imageBytes);
  if (image != null) {
    final int left = (x).round();
    final int top = (y).round();
    final int cropWidth = (width).round();
    final int cropHeight = (height).round();
    final img.Image croppedImage =
        img.copyCrop(image, left, top, cropWidth, cropHeight);
    final croppedFile = File('${imagePath}_croppe.png');

    return croppedFile.writeAsBytes(img.encodePng(croppedImage));
    // Crop the image

    // Calculate the coordinates based on the provided dimensions

    // Get the application documents directory
    // final Directory appDir = await getApplicationDocumentsDirectory();
    // final String appPath = appDir.path;

    // Save the cropped image to a file
    // final File croppedFile = File('$appPath/cropped_image.jpg');
    // return croppedFile.writeAsBytes(img.encodeJpg(croppedImage));
  }
  return null;
}

class ClickWithSpin extends StatefulWidget {
  ClickWithSpin({required this.onClicked, super.key});
  bool showSpin = false;
  Function() onClicked;
  @override
  State<ClickWithSpin> createState() => _ClickWithSpinState();
}

class _ClickWithSpinState extends State<ClickWithSpin> {
  @override
  Widget build(BuildContext context) {
    return widget.showSpin == true
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Center(
            child: InkWell(
              onTap: () {
                widget.onClicked();
                setState(() {
                  widget.showSpin = true;
                });
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.green,
                    child:
                        Icon(Icons.camera_alt_outlined, color: Colors.white)),
              ),
            ),
          );
  }
}
