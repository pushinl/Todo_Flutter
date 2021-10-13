import 'package:dio/dio.dart';
import 'error_interceptor.dart' show TodoDioError;
import 'net_status_listener.dart';

class NetCheckInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) async {
    if (NetStatusListener().hasNetwork())
      return options;
    else
      throw TodoDioError(error: "网络未连接");
  }
}
