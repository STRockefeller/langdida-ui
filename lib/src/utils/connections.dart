import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import 'package:langdida_ui/src/api_models/card.dart';
import 'package:langdida_ui/src/utils/errors.dart';

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

  static Future<GetCardResponse> getCard(String word, language) async {
    Response response = await Dio()
        .get("${_getServerAddress()}/card/get?word=$word&language=$language");
    if (response.statusCode != 200) {
      throw ApiException(
          response.statusCode ?? 0, response.statusMessage ?? "");
    }
    return GetCardResponse.fromJson(response.data);
  }
}
