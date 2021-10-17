import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ErrorInterceptor extends InterceptorsWrapper {
  @override
  Future onError(DioError err) async {
    if (err is TodoDioError) return err;
    if (err.type == DioErrorType.CONNECT_TIMEOUT)
      return DioError(error: "网络连接超时");
    if (err.type == DioErrorType.SEND_TIMEOUT) return DioError(error: "发送请求超时");
    if (err.type == DioErrorType.RECEIVE_TIMEOUT)
      return DioError(error: "响应超时");
    if (err.type == DioErrorType.RESPONSE && err.response?.statusCode == 500)
      return DioError(error: "网络连接发生了未知错误");
    if (err.type == DioErrorType.RESPONSE && err.response?.statusCode == 401)
      return DioError(error: "密码或验证码输入错误");
    if (err.type == DioErrorType.RESPONSE && err.response?.statusCode == 302)
      return DioError(error: "办公网绑定失效，请重新绑定");

    if (!kDebugMode) return DioError(error: "发生未知错误，请联系开发人员解决");
  }
}

class TodoDioError extends DioError {
  @override
  final String error;

  TodoDioError({@required this.error});
}
