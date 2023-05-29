// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:taroting/helpers/global_parameters.dart';

// class CameraOverlay extends StatefulWidget {
//   const CameraOverlay({super.key});

//   @override
//   State<CameraOverlay> createState() => _CameraOverlayState();
// }

// class _CameraOverlayState extends State<CameraOverlay> {
//   CameraDescription camera = GlobalParametersTar().cameras[0];
//   @override
// void didChangeAppLifecycleState(AppLifecycleState state) {
//   final CameraController? controller = CameraController(camera, ResolutionPreset.max);

//   final CameraController? cameraController = controller;

//   // App state changed before we got the chance to initialize.
//   if (cameraController == null || !cameraController.value.isInitialized) {
//     return;
//   }

//   if (state == AppLifecycleState.inactive) {
//     cameraController.dispose();
//   } else if (state == AppLifecycleState.resumed) {
//     onNewCameraSelected(cameraController.description);
//   }
// }
// void onNewCameraSelected(CameraDescription cameraDescription) async {
//       final previousCameraController = controller;
//       // Instantiating the camera controller
//       final CameraController cameraController = CameraController(
//         cameraDescription,
//         ResolutionPreset.high,
//         imageFormatGroup: ImageFormatGroup.jpeg,
//       );

//       // Dispose the previous controller
//       await previousCameraController?.dispose();

//       // Replace with the new controller
//       if (mounted) {
//          setState(() {
//            controller = cameraController;
//         });
//       }

//       // Update UI if controller updated
//       cameraController.addListener(() {
//         if (mounted) setState(() {});
//       });

//       // Initialize controller
//       try {
//         await cameraController.initialize();
//       } on CameraException catch (e) {
//         print('Error initializing camera: $e');
//       }

//       // Update the Boolean
//       if (mounted) {
//         setState(() {
//            _isCameraInitialized = controller!.value.isInitialized;
//         });
//       }
//    }


//   @override
//   Widget build(BuildContext context) {
//     controller = CameraController(_cameras[0], ResolutionPreset.max);

//     return Stack(
//   children: [
//     Positioned.fill(
//       child: AspectRatio(
//           aspectRatio: 4/3,
//           child: CameraPreview(controller)),
//     ),
//     Positioned.fill(
//       child: Opacity(
//         opacity: 0.3,
//         child: Image.network(
//           'urlfor the overlay image here',
//           fit: BoxFit.fill,
//         ),
//       ),
//     ),
//    Positioned(
//     bottom : 0,
//     child: Container(), //other widgets like capture etc here
//    )
//   ],
// );;
//   }
// }
