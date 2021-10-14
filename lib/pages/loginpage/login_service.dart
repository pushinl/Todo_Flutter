// import 'dart:convert';
//
// import 'package:dio/dio.dart';
// import 'package:todo_flutter/service/error_interceptor.dart';
// import 'package:todo_flutter/service/service.dart';
// class LoginDio extends DioAbstract {
//   static const APP_KEY = "banana";
//   static const APP_SECRET = "37b590063d593716405a2c5a382b1130b28bf8a7";
//   static String ticket = base64Encode(utf8.encode(APP_KEY + '.' + APP_SECRET));
//
//   @override
//   String baseUrl = "http://121.43.164.122:3389/";
//
//   @override
//   Map<String, String> headers = {"ticket": ticket};
//
//   @override
//   List<InterceptorsWrapper> interceptors = [
//     InterceptorsWrapper(onRequest: (Options options) {
//       var pref = CommonPreferences();
//       options.headers['token'] = pref.token.value;
//       options.headers['Cookie'] = pref.captchaCookie.value;
//     }, onResponse: (Response response) {
//       var code = response?.data['error_code'] ?? -1;
//       switch (code) {
//         case 40002:
//           throw TodoDioError(error: "该用户不存在");
//         case 40003:
//           throw TodoDioError(error: "用户名或密码错误");
//         case 40004:
//           throw TodoDioError(error: "用户名已存在");
//       }
//     })
//   ];
//
// }