import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;

final xFileProvider = StateProvider((ref) => XFile(''));

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({super.key});
  static const routeName = 'home-screen';
  late img.Image cropped;
  bool? loaded = false;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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
                ? Image.memory(widget.cropped.getBytes())
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
                            backgroundColor: Colors.white,
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

          widget.cropped = img.copyCrop(image!, 30, 30, 100, 200);
          setState(() {
            loaded = true;
          });
        }
      }
    });
  }
}
