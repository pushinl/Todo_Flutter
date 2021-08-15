

import 'package:flutter/material.dart';
import 'package:todo_flutter/Calender.dart';
import 'package:todo_flutter/pages/notepage/NoteMainPage.dart';
import 'package:todo_flutter/pages/notepage/WriteNotePage.dart';


//配置路由，以后所有的跳转的页面都可以再这里完成
final routes = {
  '/note': (context) => NoteMainPage(),
  '/writeNote': (context, {arguments}) => WriteNotePage(arguments: arguments,),
  '/Calender':(context) =>CalenderPage(),

};

//固定写法，理解不了就记住。
var onGenerateRoute = (RouteSettings settings) {
  //统一处理
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
