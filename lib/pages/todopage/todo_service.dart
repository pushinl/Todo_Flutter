import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/bean/todo_bean_entity.dart';
import 'package:todo_flutter/bean/user_bean_entity.dart';
import 'package:todo_flutter/main.dart';
import 'package:todo_flutter/service/error_interceptor.dart';
import 'package:todo_flutter/service/service.dart';

class TodoDio extends DioAbstract {
  @override
  String baseUrl = 'http://121.43.164.122:3391/user/';

  @override
  List<InterceptorsWrapper> interceptors = [
    InterceptorsWrapper(onResponse: (Response response) {
      var code = response?.data['ErrorCode'] ?? 0;
      switch (code) {
        case 0: // 成功
          return response;
        default: // 其他错误
          throw TodoDioError(error: response.data['msg']);
      }
    })
  ];
}

final todoDio = TodoDio();

class TodoService with AsyncTimer {
  static getTodo({
    @required OnResult<List<TodoBeanEntity>> onResult,
    @required OnFailure onFailure,
  }) async {
    try {
      var response = await todoDio.get(
        'getTodo',
        queryParameters: {
          'User' : '${Global.user}',
        }
      );
      List<TodoBeanEntity> list = [];
      for (Map<String, dynamic> json in response.data['data']) {
        list.add(TodoBeanEntity().fromJson(json));
      }
      onResult(list);
    } on DioError catch (e) {
      onFailure(e);
    }
  }

  static addTodo({
    @required OnResult<List<TodoBeanEntity>> onResult,
    @required OnFailure onFailure,
  }) async {
    try {
      var response = await todoDio.post(
        'addTodo',
        queryParameters: {
          'User' : '${Global.user}',
        }
      );
    } on DioError catch (e) {
      onFailure(e);
    }
  }
}