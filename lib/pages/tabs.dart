import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/pages/color_utils.dart';
import 'package:todo_flutter/pages/notepage/note_main_page.dart';
import 'package:todo_flutter/pages/todopage/todo_page.dart';
import 'package:todo_flutter/pages/personpage/person_page.dart';
import 'package:todo_flutter/pages/calendarpage/calendar_page.dart';

class Tabs extends StatefulWidget{
  Tabs({Key key}) : super(key: key);

  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> with SingleTickerProviderStateMixin{
  var _pageController = new PageController(initialPage: 0);
  var tabImages;
  int _selectedIndex = 0;
  List<Widget> _bottomPages = [TodoPage(), CalendarPage(), NoteMainPage(), PersonPage()];


  @override
  void initState() {
    super.initState();
  }
  // 当整个页面 dispose 时，记得把控制器也 dispose 掉，释放内存
  @override
  void dispose() {
    this._pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    tabImages = [
      [
        getTabImage('assets/todo_default_icon.png'),
        getTabImage('assets/todo_light_icon.png')
      ],
      [
        getTabImage('assets/calendar_default_icon.png'),
        getTabImage('assets/calendar_light_icon.png')
      ],
      [
        getTabImage('assets/note_default_icon.png'),
        getTabImage('assets/note_light_icon.png')
      ],
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorUtils.color_background_main,
        elevation: 0,
        toolbarHeight: 10,
      ),

      bottomNavigationBar: Container(
        color: ColorUtils.color_background_main,
        height: 70,
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(title: Container(),icon: getTabIcon(0), backgroundColor: ColorUtils.color_background_main),
            BottomNavigationBarItem(title: Container(),icon: getTabIcon(1), backgroundColor: ColorUtils.color_background_main),
            BottomNavigationBarItem(title: Container(),icon: getTabIcon(2), backgroundColor: ColorUtils.color_background_main),
          ],
          // selectedIconTheme: IconThemeData(
          //     color: ColorUtils.color_background_main,
          //     opacity: 1.0,
          //     size: 24
          // ),
          // unselectedIconTheme: IconThemeData(
          //     color: ColorUtils.color_background_main,
          //     opacity: 1.0,
          //     size: 24
          // ),
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          backgroundColor: ColorUtils.color_background_main,
          elevation: 0,
          onTap: (index){
            setState(() {
              _selectedIndex = index;
            });
            // print(_selectedIndex);
          },
        ),
      ),

      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _bottomPages[_selectedIndex],
      ),
    );
  }

  /*
   * 根据选择获得对应的normal或是press的icon
   * TODO:这里还是有问题
   */
  Image getTabIcon(int curIndex) {
    if (curIndex == _selectedIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }
  /*
   * 根据image路径获取图片
   */
  Image getTabImage(path) {
    return Image.asset(path, width: 27.5, height: 27.5);
  }

}