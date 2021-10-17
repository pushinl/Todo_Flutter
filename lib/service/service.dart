import 'package:dio/dio.dart';

import 'error_interceptor.dart';

/// [OnSuccess]和[OnResult]均为请求成功；[OnFailure]为请求失败
typedef OnSuccess = void Function();
typedef OnResult<T> = void Function(T data);
typedef OnFailure = void Function(DioError e);

abstract class DioAbstract {
  String baseUrl;
  Map<String, String> headers;
  List<InterceptorsWrapper> interceptors = [];
  ResponseType responseType = ResponseType.json;
  bool responseBody = false;
  Dio _dio;

  Dio get dio => _dio;

  DioAbstract() {
    BaseOptions options = BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 10000,
        receiveTimeout: 10000,
        responseType: responseType,
        headers: headers);
    _dio = Dio()
      ..options = options
      ..interceptors.addAll(interceptors)
      ..interceptors.add(ErrorInterceptor())
      ..interceptors.add(LogInterceptor(responseBody: responseBody));
  }
}

extension DioRequests on DioAbstract {
  Future<Response<dynamic>> get(String path,
      {Map<String, dynamic> queryParameters}) {
    return dio
        .get(path, queryParameters: queryParameters)
        .catchError((error, stack) {
      throw error;
    });
  }

  Future<Response<dynamic>> post(String path,
      {Map<String, dynamic> queryParameters, FormData formData}) {
    return dio
        .post(path, queryParameters: queryParameters, data: formData)
        .catchError((error, stack) {
      throw error;
    });
  }

  Future<Response<dynamic>> put(String path,
      {Map<String, dynamic> queryParameters}) {
    return dio
        .put(path, queryParameters: queryParameters)
        .catchError((error, stack) {
      throw error;
    });
  }
}

mixin AsyncTimer {
  static Map<String, bool> _map = {};

  static Future<void> runRepeatChecked<R>(
      String key, Future<void> body()) async {
    if (!_map.containsKey(key)) _map[key] = true;
    if (!_map[key]) return;
    _map[key] = false;
    await body();
    _map[key] = true;
  }
}

class CommonBody {
  int errorCode;
  String message;
  String result;

  CommonBody.fromJson(dynamic jsonData) {
    errorCode = jsonData['code'];
    message = jsonData['message'];
    result = jsonData['result'];
  }
}