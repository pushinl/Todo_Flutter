

import 'package:flutter/material.dart';
import 'package:todo_flutter/pages/loginpage/register_page.dart';
import 'package:todo_flutter/pages/personpage/person_page.dart';
import 'package:todo_flutter/pages/tabs.dart';
import 'package:todo_flutter/pages/calendarpage/calendar_page.dart';
import 'package:todo_flutter/pages/loginpage/login_page.dart';
import 'package:todo_flutter/pages/notepage/note_main_page.dart';
import 'package:todo_flutter/pages/notepage/write_note_page.dart';
import 'package:todo_flutter/pages/randompage/random_page.dart';
import 'package:todo_flutter/pages/todopage/todo_page.dart';

import 'feedback_page.dart';

//配置路由，以后所有的跳转的页面都可以再这里完成
final routes = {
  '/tabs': (context) => Tabs(),
  '/note': (context) => NoteMainPage(),
  '/writeNote': (context, {arguments}) => WriteNotePage(arguments: arguments,),
  '/Calendar':(context) =>CalendarPage(),
  '/Random' : (context) => RandomPage(),
  '/Login' : (context) => LoginRoute(),
  '/Register' : (context) => RegisterPage(),
  '/feedback' : (context) => FeedbackPage(),
  '/Person' : (context) => PersonPage(),

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
