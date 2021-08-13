import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_flutter/pages/Color.dart';
import 'package:todo_flutter/pages/notepage/sqlite/SqliteHelper.dart';
import 'package:toast/toast.dart';
import 'package:todo_flutter/pages/todopage/TodoPage1.dart';
import '../Constants.dart';
import '../../bean/note_bean_entity.dart';
import 'package:flutter_picker/flutter_picker.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key key}) : super(key: key);

  @override
  _TodoPageState createState() => _TodoPageState();

}



class _TodoPageState extends State<TodoPage> with SingleTickerProviderStateMixin {
//侧滑条


  TabController _tabController;
  var keyWord; //关键字
  SqliteHelper sqliteHelper;


  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
    sqliteHelper = new SqliteHelper();
  }


  //点击导航项是要显示的页面


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.more),
            onPressed: (){},
          ),

          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
            tabs: <Widget>[
              Tab(text: "全部待办"),
              Tab(text: "团队待办"),
              Tab(text: "我的待办"),

            ],
          ),
        ),
        body:
        TabBarView(
          controller: _tabController,
          children: <Widget>[
            Todo1Page(),
            Todo1Page(),
            Todo1Page(),

          ],
        )

    );
  }
}