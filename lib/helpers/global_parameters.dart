import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sharedor/helpers/export_helpers.dart';

class GlobalParametersTar extends GlobalParameters {
  Map<String, dynamic>? params;
  late List<CameraDescription> _cameras;
  late File _tensofFlowFile;
  late File _tensorFlowLabel;
  static final GlobalParametersTar _gp = GlobalParametersTar._internal();
  GlobalParametersTar._internal() {
    // setGlobalParameters(params);
  }
  factory GlobalParametersTar() {
    return _gp;
  }
  @override
  setGlobalParameters(Map<String, dynamic>? params) async {
    try {
      _cameras = await availableCameras();

      loadTEnsofFlowFile();
      super.setGlobalParameters(params);
    } on CameraException catch (e) {
      rethrow;
    }
  }

  loadTEnsofFlowFile() async {
    final storageRef = FirebaseStorage.instance.ref();
    Reference pathReference = storageRef.child("misc/model_unquant.tflite");
    final appDocDir = await getApplicationDocumentsDirectory();
    String filePath = "${appDocDir.path}/model_unquant.tflite";
    _tensofFlowFile = File(filePath);
    pathReference.writeToFile(_tensofFlowFile);
    pathReference = storageRef.child("misc/labels.txt");
    filePath = "${appDocDir.path}/labels.txt";
    _tensorFlowLabel = File(filePath);
    pathReference.writeToFile(_tensorFlowLabel);
  }

  File get tensofFlowFile => _tensofFlowFile;
  File get tensofFlowLabel => _tensorFlowLabel;

  List<CameraDescription> get cameras => _cameras;
  // @override
  // setGlobalParameters(Map<String, dynamic>? params) {

  // }
}
//https://pub.dev/packages/camera/example