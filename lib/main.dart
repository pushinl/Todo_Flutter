import 'package:flutter/material.dart';

void main() => runApp(TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      home: HomePage()
    );
  }
}

class HomePage extends StatefulWidget{
  @override
  State createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{

  var tabController;

  @override
  void initState() {
    super.initState();
    this.tabController = new TabController(
        vsync: this,    // 动画效果的异步处理
        length: 4       // tab 个数
    );
  }
  // 当整个页面 dispose 时，记得把控制器也 dispose 掉，释放内存
  @override
  void dispose() {
    this.tabController .dispose();
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
      body: TabBarView(
        controller: this.tabController,
        children: [
          Text('tab1'),
          Text('tab2'),
          Text('tab3'),
          Text('tab4'),
        ],
      ),
      bottomNavigationBar: Material(
        color: Colors.white,
        child: TabBar(
          controller: this.tabController,
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
    );
  }
}
