import 'package:flutter/material.dart';
import 'package:todo_flutter/pages/Color.dart';
import 'package:todo_flutter/pages/notepage/NoteMainPage.dart';
import 'package:todo_flutter/pages/todopage/TodoPage.dart';
import 'package:todo_flutter/pages/personpage/PersonPage.dart';
import 'package:todo_flutter/pages/teampage/TeamPage.dart';
class Tabs extends StatefulWidget{
  Tabs({Key key}) : super(key: key);

  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> with SingleTickerProviderStateMixin{
  var _tabController;
  var tabImages;


  @override
  void initState() {
    super.initState();
    this._tabController = new TabController(
        vsync: this,    // 动画效果的异步处理
        length: 4       // tab 个数
    );
  }
  // 当整个页面 dispose 时，记得把控制器也 dispose 掉，释放内存
  @override
  void dispose() {
    this._tabController .dispose();
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
        getTabImage('assets/team_default_icon.png'),
        getTabImage('assets/team_light_icon.png')
      ],
      [
        getTabImage('assets/note_default_icon.png'),
        getTabImage('assets/note_light_icon.png')
      ],
      [
        getTabImage('assets/person_default_icon.png'),
        getTabImage('assets/person_light_icon.png')
      ]
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorUtils.color_background_main,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/message_icon.png', width: 22.0, height: 22.0),
          onPressed: (){},
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context,'/Calendar').then((value) => null);
              },
              icon: Image.asset('assets/calendar_icon.png', width: 22.0, height: 22.0),
          )
        ],
      ),

      bottomNavigationBar: Container(
        color: ColorUtils.color_background_main,
        height: 70,
        child: TabBar(
          controller: this._tabController,
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          tabs: <Tab>[
            Tab(
              icon: getTabIcon(0),
            ),
            Tab(
              icon: getTabIcon(1),
            ),
            Tab(
              icon: getTabIcon(2),
            ),
            Tab(
              icon: getTabIcon(3),
            )
          ],
        ),
      ),

      body: TabBarView(
        controller: this._tabController,
        children: [
          TodoPage(),
          TeamPage(),
          NoteMainPage(),
          PersonPage(),
        ],
      ),
    );
  }

  /*
   * 根据选择获得对应的normal或是press的icon
   * TODO:这里还是有问题
   */
  Image getTabIcon(int curIndex) {
    if (curIndex == _tabController) {
      return tabImages[curIndex][0];
    }
    return tabImages[curIndex][1];
  }
  /*
   * 根据image路径获取图片
   */
  Image getTabImage(path) {
    return Image.asset(path, width: 27.5, height: 27.5);
  }

}