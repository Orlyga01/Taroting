import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:sharedor/sharedor.dart';
import 'package:taroting/card/card_controller.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/helpers/providers.dart';

final xFileProvider = StateProvider((ref) => File(''));

class CaptureCameraWidget extends ConsumerStatefulWidget {
  CaptureCameraWidget({super.key});
  static const routeName = 'home-screen';
  late img.Image cropped;
  bool? loaded = false;
  @override
  _CaptureCameraWidgetState createState() => _CaptureCameraWidgetState();
}

class _CaptureCameraWidgetState extends ConsumerState<CaptureCameraWidget> {
  late CameraController controller;
  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    final xFileState = ref.watch(xFileProvider);

    return FutureBuilder(
      future: initializationCamera(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return loaded
              ? Image.file(File(xFileState.path))
              : Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: CameraPreview(controller),
                    ),
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                        'assets/camera-overlay-conceptcoder.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    InkWell(
                      onTap: () => onTakePicture(),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Colors.green,
                            child: Icon(Icons.camera_alt_outlined,
                                color: Colors.white)),
                      ),
                    ),
                  ],
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
    await controller.takePicture().then((XFile xfile) async {
      if (mounted) {
        if (xfile != null) {
          final bytes = await xfile.readAsBytes();
          //   final image = img.decodeImage(bytes);
          File? cr = await cropImage(xfile.path, 0.22, 0.24, 0.55, 0.52);

          TCard? card = await TCardController().identifyTCard(cr!.path);
          //???  ref.read(xFileProvider.notifier).state = cr;
          if (card != null) {
            ref.read(watchCard.notifier).cardLoaded = card;
          } else {
            showDialog(
                context: context,
                builder: (_) {
                  // return object of type Dialog

                  return AlertDialog(
                      title: Text(
                          " Sorry - the card was not found. Please take a picture again."),
                      actions: [
                        OutlinedButton(
                            key: const Key("alertOKBtn"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("OK"))
                      ]);
                });
          }
          showDialog(
              context: context,
              builder: (_) {
                // return object of type Dialog

                return AlertDialog(
                    title: Text(card!.name),
                    content: Image.file(cr),
                    actions: [
                      OutlinedButton(
                          key: const Key("alertOKBtn"),
                          onPressed: () {
                            loaded = true;
                            ref.read(watchSpreadChange).switchCameraOn = false;

                            Navigator.of(context).pop();
                          },
                          child: const Text("OK"))
                    ]);
              });
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
