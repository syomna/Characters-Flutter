import 'dart:io';

import 'package:dio/dio.dart';
import 'package:displaycharacters/constants/constants.dart';

class CharactersServices {
  late Dio dio;

  CharactersServices() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: false,
      connectTimeout: const Duration(seconds: 100),
      receiveTimeout: const Duration(seconds: 100),
    );

    dio = Dio(options);
  }

  Future<bool> checkInternetConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<List<dynamic>> getAllCharacters() async {
    List<dynamic> characters = [];
    bool isConnected = await checkInternetConnectivity();
    if (isConnected) {
      try {
        Response response = await dio.get('characters');
        characters = response.data;
      } catch (e) {
        print(e);
      }
    }
    return characters;
  }
}
