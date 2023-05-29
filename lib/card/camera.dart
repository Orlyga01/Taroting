import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraOverlay extends StatefulWidget {
  const CameraOverlay({super.key});

  @override
  State<CameraOverlay> createState() => _CameraOverlayState();
}

class _CameraOverlayState extends State<CameraOverlay> {
  @override
void didChangeAppLifecycleState(AppLifecycleState state) {
  final CameraController? controller = CameraController(_cameras[0], ResolutionPreset.max);

  final CameraController? cameraController = controller;

  // App state changed before we got the chance to initialize.
  if (cameraController == null || !cameraController.value.isInitialized) {
    return;
  }

  if (state == AppLifecycleState.inactive) {
    cameraController.dispose();
  } else if (state == AppLifecycleState.resumed) {
    onNewCameraSelected(cameraController.description);
  }
}

  @override
  Widget build(BuildContext context) {
    controller = CameraController(_cameras[0], ResolutionPreset.max);

    return Stack(
  children: [
    Positioned.fill(
      child: AspectRatio(
          aspectRatio: 4/3,
          child: CameraPreview(controller)),
    ),
    Positioned.fill(
      child: Opacity(
        opacity: 0.3,
        child: Image.network(
          'urlfor the overlay image here',
          fit: BoxFit.fill,
        ),
      ),
    ),
   Positioned(
    bottom : 0,
    child: Container(), //other widgets like capture etc here
   )
  ],
);;
  }
}
