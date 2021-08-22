import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_flutter/pages/Color.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:r_calendar/r_calendar.dart';
import 'package:todo_flutter/Calender.dart';
import 'package:todo_flutter/pages/Tabs.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({Key key}) : super(key: key);

  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> with SingleTickerProviderStateMixin{
  TabController mController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mController=TabController(length: 2, vsync: this);

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: TabBar(
                    // 多个标签时滚动加载
                    isScrollable: true,
                    // 标签指示器的颜色
                    indicatorColor: Colors.black,
                    // 标签的颜色
                    labelColor: Colors.black,
                    // 未选中标签的颜色
                    unselectedLabelColor: Colors.black,
                    // 指示器的大小
                    indicatorSize: TabBarIndicatorSize.label,
                    // 指示器的权重，即线条高度
                    indicatorWeight: 4.0,
                    tabs: <Widget>[
                      Tab(
                        text: "            我加入的               ",

                      ),
                      Tab(
                        text: "            我管理的               ",
                      ),

                    ],

            ),
          ),
          body: new TabBarView(
            controller: mController,
            children: <Widget>[
              Container(
                child: Text('我加入的'),
              ),
              Container(
                child: Text('我管理的'),
              )
            ],
          ),
        ));
  }
}
