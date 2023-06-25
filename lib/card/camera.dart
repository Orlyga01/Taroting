import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:sharedor/sharedor.dart';
import 'package:taroting/Interpretation/interpretation_controller.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/card/card_controller.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/helpers/global_parameters.dart';
import 'package:taroting/helpers/providers.dart';
import 'package:taroting/helpers/translations.dart';
import 'package:taroting/spread/spread_controller.dart';

final xFileProvider = StateProvider((ref) => File(''));

class CaptureCameraWidget extends ConsumerStatefulWidget {
  CaptureCameraWidget({super.key});
  static const routeName = 'home-screen';
  late img.Image cropped;
  bool? loaded = false;
  bool showCamera = false;
  Size initialOffset = const Size(40, 20);
  Size croppedSize = const Size(300, 480);
  Uint8List? cameraImage;
  late double scale;
  bool inProcess = false;
  @override
  _CaptureCameraWidgetState createState() => _CaptureCameraWidgetState();
}

class _CaptureCameraWidgetState extends ConsumerState<CaptureCameraWidget> {
  late CameraController controller;
  bool loaded = false;
  final GlobalKey _keyWidth = GlobalKey();
  final GlobalKey cropperKey = GlobalKey();
  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPersistentFrameCallback((_) => getCropImage());

  //   super.initState();
  // }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

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
                                      key: _keyWidth,
                                      child: Container(
                                          color:
                                              Colors.white.withOpacity(0.6))),
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
                                      child: Container(
                                          color:
                                              Colors.white.withOpacity(0.6))),
                                ],
                              ),
                            ),
                            if (widget.cameraImage != null)
                              Positioned(
                                  child: Align(
                                alignment: Alignment.centerRight,
                                child: RepaintBoundary(
                                  key: cropperKey,
                                  child: Container(
                                      width: widget.croppedSize.width /
                                          widget.scale *
                                          0.9,
                                      height: widget.croppedSize.width /
                                          widget.scale *
                                          0.9 *
                                          1.7,
                                      // Define the height of the visible part
                                      child: OverflowBox(
                                          maxWidth: double.infinity,
                                          maxHeight: double.infinity,
                                          alignment: Alignment.center,
                                          child: FittedBox(
                                              fit: BoxFit.cover,
                                              alignment: Alignment.center,
                                              child: Container(
                                                  width:
                                                      widget.croppedSize.width /
                                                          widget.scale *
                                                          0.9,
                                                  height: widget
                                                          .croppedSize.width /
                                                      widget.scale *
                                                      0.9 *
                                                      1.7, //ne the height of the vis
                                                  child: Image.memory(
                                                    widget.cameraImage!,
                                                    fit: BoxFit.none,
                                                  ))))),
                                ),
                              )),
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
        widget.cameraImage = await xfile.readAsBytes();

        if (xfile != null) {
          final bytes = await xfile.readAsBytes();
          //   final image = img.decodeImage(bytes);
          final RenderBox renderBox =
              _keyWidth.currentContext?.findRenderObject() as RenderBox;
          widget.scale = 1 /
              (controller.value.aspectRatio *
                  MediaQuery.of(context).size.aspectRatio);
          double insidewidth = size.width - 2 * (renderBox.size.width);
          widget.croppedSize = Size(insidewidth * 0.9, 0);
          //widget.croppedSize = Size(180.0, 180 * 1.6);
          widget.initialOffset = Size(
              (renderBox.size.width + 10) / widget.scale, 25 / widget.scale);

          setState(() {});
          await Future.delayed(
              Duration(milliseconds: 1500), () => getCropImage());
        }
      }
    });
  }

  Future<void> findTheCard(File cr) async {
    try {
      SpreadController().saveCroppedImg = cr.path;
      TCard? card = await TCardController().identifyTCard(cr.path);
      card = TCardController().currentCard;
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
                title: Text(
                    " Sorry - the card was not found. Please take a picture again."
                        .TR),
                actions: [
                  OutlinedButton(
                      key: const Key("alertOKBtn"),
                      onPressed: () {
                        ref.read(watchOpenCamera.notifier).setCameraState =
                            true;
                        Navigator.of(context).pop();
                      },
                      child: const Text("OK"))
                ]);
          });
    }
  }

  Future<File?> getCropImage() async {
    if (widget.inProcess) return null;
    widget.inProcess = true;

     Future.doWhile(() => cropperKey.currentContext == null);
    await Future.delayed(Duration(milliseconds: 1000));
    final renderObject = cropperKey.currentContext!.findRenderObject();
    final boundary = renderObject as RenderRepaintBoundary;
    final image = await boundary.toImage();
// Convert image to bytes in PNG format
    final byteData = await image.toByteData(
      format: ImageByteFormat.png,
    );

    final pngBytes = byteData?.buffer.asUint8List();
    final tempDir = await getApplicationDocumentsDirectory();
    File file = await File(
            '${tempDir.path}/${DateTime.now().microsecondsSinceEpoch.toString()}_cropped.png')
        .create();
    file.writeAsBytesSync(pngBytes!);

    showDialog(
        context: context,
        builder: (_) {
          // return object of type Dialog

          return AlertDialog(
            title: Column(
              children: [
                Container(color: Colors.yellow, child: Text("before")),
                Image.file(file),
              ],
            ),
          );
        });
    await findTheCard(file);
    widget.inProcess = false;
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
