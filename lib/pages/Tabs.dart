import 'package:flutter/material.dart';
import 'package:todo_flutter/pages/notepage/NoteMainPage.dart';
import 'package:todo_flutter/pages/todopage/TodoPage.dart';

class Tabs extends StatefulWidget{
  Tabs({Key key}) : super(key: key);

  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> with SingleTickerProviderStateMixin{
  var _tabController;


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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ToDo',
          style: TextStyle(
              color: Colors.black
          ),
        ),
        backgroundColor: Colors.white,
      ),

      bottomNavigationBar: Material(
        color: Colors.white,
        child: TabBar(
          controller: this._tabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black38,
          tabs: <Tab>[
            Tab(
              text: '我的待办',
              icon: Icon(Icons.add_alarm_outlined),
            ),
            Tab(
              text: '我的团队',
              icon: Icon(Icons.account_tree_outlined),
            ),
            Tab(
              text: '备忘录',
              icon: Icon(Icons.book),
            ),
            Tab(
              text: '个人中心',
              icon: Icon(Icons.account_circle),
            )
          ],
        ),
      ),

      body: TabBarView(
        controller: this._tabController,
        children: [
          TodoPage(),
          Text('团队'),
          NoteMainPage(),
          Text('个人'),
        ],
      ),
    );
  }
}