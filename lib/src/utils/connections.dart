import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

class Connections {
  static String _getServerAddress() {
    final GetStorage storage = GetStorage();
    String? serverAddress = storage.read('server_address');
    if (serverAddress?.isNotEmpty == true) {
      return serverAddress!;
    }
    return "";
  }

  static Future<bool> isConnected() async {
    Response response = await Dio().get("${_getServerAddress()}/ping");
    return response.statusCode == 200;
  }
}
