import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;

class CaptureCameraWidget extends StatefulWidget {
  CaptureCameraWidget({super.key});
  static const routeName = 'home-screen';
  late img.Image cropped;
  bool? loaded = false;
  bool showCamera = false;
  Size initialOffset = const Size(40, 20);
  Size croppedSize = const Size(300, 480);
  Uint8List? cameraImage;
  late double scale;
  @override
  _CaptureCameraWidgetState createState() => _CaptureCameraWidgetState();
}

class _CaptureCameraWidgetState extends State<CaptureCameraWidget> {
  late Image imgController;
  bool loaded = false;
  late CameraController controller;
  final _transformationController = TransformationController();
  @override
  void initState() {
    //   WidgetsBinding.instance.addPersistentFrameCallback((_) => getCropImage());

    super.initState();
  }

  GlobalKey _keyWidth = GlobalKey();
  GlobalKey cropperKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    List<Widget> children = getChildren();
    return widget.cameraImage != null
        ? RepaintBoundary(
            key: cropperKey,
            child: ClipRRect(
                child: SizedBox(
              width: widget.croppedSize.width * widget.scale,
              height: widget.croppedSize.height *
                  widget.scale, // Define the height of the visible part
              child: Stack(
                children: [
                  Positioned(
                    left: widget.initialOffset.width * widget.scale * -1,
                    top: widget.initialOffset.height *
                        widget.scale *
                        -1, // Define the x-position to adjust the visible part
                    child: Image.memory(widget.cameraImage!,
                        fit: BoxFit.cover, scale: widget.scale),
                  ),
                ],
              ),
            )),
            // LayoutBuilder(
            //   builder: (_, constraint) {
            //     return InteractiveViewer(
            //       transformationController: _transformationController,
            //       constrained: false,
            //       child: Builder(
            //         builder: (context) {
            //           // Set the initial scale once the image has been loaded

            //           //      _setInitialScale(context, widget.croppedSize);

            //           return Image.memory(widget.cameraImage!);
            //         },
            //       ),
            //       minScale: 0.1,
            //     );
            //   },
            // ),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: children.length,
            itemBuilder: (context, index) {
              return children[index];
            });
  }

  List<Widget> getChildren() {
    Size size = MediaQuery.of(context).size;

    return [
      SizedBox(height: 30),
      FutureBuilder(
        future: initializationCamera(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                height: size.height * 0.9,
                padding: const EdgeInsets.only(
                  top: 5,
                ),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      height: size.height * 0.9,
                      child: Transform.scale(
                          scale: 1 /
                              (controller.value.aspectRatio *
                                  MediaQuery.of(context).size.aspectRatio),
                          child: CameraPreview(controller)),
                    ),
                    Container(
                      height: size.height * 0.9,
                      child: Row(
                        children: [
                          Expanded(
                              key: _keyWidth,
                              child: Container(
                                  color: Colors.white.withOpacity(0.6))),
                          Container(
                            height: size.height * 0.9,
                            child: Image.asset(
                              'assets/camera-overlay-conceptcoder.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                              child: Container(
                                  color: Colors.white.withOpacity(0.6))),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: size.width - 100,
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
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 0),
                          child: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.close, color: Colors.black)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )
    ];
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
        final bytes = await xfile.readAsBytes();
        //   final image = img.decodeImage(bytes);
        final RenderBox renderBox =
            _keyWidth.currentContext?.findRenderObject() as RenderBox;
        widget.croppedSize = Size(size.width - 2 * (renderBox.size.width + 10),
            (size.width - 2 * (renderBox.size.width + 10)) * 1.6);
        widget.initialOffset = Size(renderBox.size.width + 10, 20);
        widget.scale = 1 /
            (controller.value.aspectRatio *
                MediaQuery.of(context).size.aspectRatio);
        setState(() {});
      }
    });
  }

  void _setInitialScale(BuildContext context, Size parentSize) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox = context.findRenderObject() as RenderBox?;
      final childSize = renderBox?.size ?? Size.zero;
      if (childSize != Size.zero) {
        _transformationController.value =
            Matrix4.identity() * _getCoverRatio(parentSize, childSize);
      }
    });
  }

  double _getCoverRatio(Size outside, Size inside) {
    return outside.width / outside.height > inside.width / inside.height
        ? outside.width / inside.width
        : outside.height / inside.height;
  }

  getCropImage() {
    if (cropperKey.currentContext == null) return;
    final renderObject = cropperKey.currentContext!.findRenderObject();
    final boundary = renderObject as RenderRepaintBoundary;
    boundary.toImage().then((image) => {
// Convert image to bytes in PNG format
          image
              .toByteData(
            format: ImageByteFormat.png,
          )
              .then((byteData) {
            final pngBytes = byteData?.buffer.asUint8List();
            showDialog(
                context: context,
                builder: (_) {
                  // return object of type Dialog

                  return AlertDialog(
                    title: Column(
                      children: [
                        Container(color: Colors.yellow, child: Text("before")),
                        Image.memory(pngBytes!),
                      ],
                    ),
                  );
                });
          })
        });
  }
}

Future<File?> cropImage(String imagePath, double x, double y, double width,
    double height, context) async {
  // Read the image file
  final File imageFile = File(imagePath);
  Uint8List uint8List;
  final List<int> imageBytes = await imageFile.readAsBytes();
  uint8List = Uint8List.fromList(imageBytes);
  final img.Image? image = img.decodeImage(imageBytes);

  if (image != null) {
    final int left = (x).round();
    final int top = (y).round();
    final int cropWidth = (width).round();
    final int cropHeight = (height).round();
    final img.Image croppedImage =
        img.copyCrop(image, left, top, cropWidth, cropHeight);
    final croppedFile = File('${imagePath}_croppe.png');
    showDialog(
        context: context,
        builder: (_) {
          // return object of type Dialog

          return AlertDialog(
            title: Column(
              children: [
                Container(color: Colors.yellow, child: Text("before")),
                Image.memory(Uint8List.fromList(img.encodeJpg(croppedImage))),
              ],
            ),
          );
        });
    return croppedFile.writeAsBytes(img.encodeJpg(croppedImage));
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
    widget.showSpin = false;
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
