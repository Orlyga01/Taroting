import 'package:camera/camera.dart';
import 'package:sharedor/helpers/export_helpers.dart';

class GlobalParametersTar extends GlobalParameters {
  Map<String, dynamic>? params;
  late List<CameraDescription> _cameras;

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
      super.setGlobalParameters(params);
    } on CameraException catch (e) {
      rethrow;
    }
  }

  List<CameraDescription> get cameras => _cameras;
  // @override
  // setGlobalParameters(Map<String, dynamic>? params) {

  // }
}
//https://pub.dev/packages/camera/example