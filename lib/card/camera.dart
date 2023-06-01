import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:sharedor/sharedor.dart';

final xFileProvider = StateProvider((ref) => XFile(''));

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

    return Scaffold(
      body: FutureBuilder(
        future: initializationCamera(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return loaded
                ? Image.file(File(xFileState.path))
                : Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      AspectRatio(
                        aspectRatio: 3 / 4,
                        child: CameraPreview(controller),
                      ),
                      AspectRatio(
                        aspectRatio: 3 / 4,
                        child: Image.asset(
                          'assets/camera-overlay-conceptcoder.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      InkWell(
                        onTap: () => onTakePicture(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Colors.green,
                            child: Icon(Icons.camera_alt_outlined, color: Colors.white)
                          ),
                        ),
                      ),
                    ],
                  );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
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
          ref.read(xFileProvider.notifier).state = xfile;
          final bytes = await xfile.readAsBytes();
          final image = img.decodeImage(bytes);
          showDialog(
              context: context,
              builder: (_) {
                // return object of type Dialog

                return AlertDialog(
                    title: Text("hi"),
                    content: Image.file(File(xfile.path)),
                    actions: [
                      OutlinedButton(
                          key: const Key("alertOKBtn"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("OK"))
                    ]);
              });
          setState(() {
            loaded = true;
          });
        }
      }
    });
  }
}
