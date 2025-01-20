import 'package:dio/dio.dart';

import 'end_point.dart';
class DioHelper {
  static late Dio dio;
  static init() {
    dio = Dio(BaseOptions(
      baseUrl: baseurl,
      receiveDataWhenStatusError: true,

    ));
  }

  static Future<Response> postData({
    required String url,
    dynamic data,
  }) async {
    dio.options.headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    return await dio.post(url, data: data);
  }



  static Future<Response> DeleteData({
    required String url,
  }) async {
    dio.options.headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    return await dio.delete(url);
  }

  static Future<Response> getData({
    required String url,
    // required Map<String,dynamic> query,
  }) async {
    dio.options.headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    return await dio.get(url);
  }

  static Future<Response> getdo({
    required String url,
    // required Map<String,dynamic> query,
  }) async {

    return await dio.get(url,options: Options(responseType: ResponseType.stream));
  }

}
