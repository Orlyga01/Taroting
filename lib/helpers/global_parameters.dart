import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sharedor/helpers/export_helpers.dart';
import 'package:taroting/helpers/translations.dart';

class GlobalParametersTar extends GlobalParameters {
  Map<String, dynamic>? params;
  late List<CameraDescription> _cameras;
  late File _tensofFlowFile;
  late File _tensorFlowLabel;
  late Map<String, String> _translations;
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
      super.setGlobalParameters(params);
      _cameras = await availableCameras();
      _translations = await getTranslations();
      await loadTEnsofFlowFile();
    } catch (e) {
      rethrow;
    }
  }

  loadTEnsofFlowFile() async {
    final appDocDir = await getApplicationDocumentsDirectory();

    if (kDebugMode) {
      _tensofFlowFile =
          File("${appDocDir.path}/assets/misc/model_unquant.tflite");
      _tensorFlowLabel = File("${appDocDir.path}/assets/misc/labels.txt");
    } else {
      try {
        final storageRef = FirebaseStorage.instance.ref();
        Reference pathReference = storageRef.child("misc/model_unquant.tflite");
        String filePath = "${appDocDir.path}/model_unquant.tflite";
        _tensofFlowFile = File(filePath);
        pathReference.writeToFile(_tensofFlowFile);
        pathReference = storageRef.child("misc/labels.txt");
        filePath = "${appDocDir.path}/labels.txt";
        _tensorFlowLabel = File(filePath);
        pathReference.writeToFile(_tensorFlowLabel);
      } catch (e) {
        print("!!!---Error loading tensor flow file $e");
      }
    }
  }

  Map<String, String> get translations => _translations;
  File get tensofFlowFile => _tensofFlowFile;
  File get tensofFlowLabel => _tensorFlowLabel;

  List<CameraDescription> get cameras => _cameras;
  // @override
  // setGlobalParameters(Map<String, dynamic>? params) {

  // }
}
//https://pub.dev/packages/camera/example