import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_flutter/pages/Color.dart';
import 'package:todo_flutter/pages/Constants.dart';
import 'package:todo_flutter/pages/todopage/sqlite/TodoSqliteHelper.dart';

import '../../bean/todo_bean_entity.dart';
import 'package:toast/toast.dart';

import '../Color.dart';
import '../Constants.dart';
import 'sqlite/TodoSqliteHelper.dart';

class WriteTodoPage extends StatefulWidget {
  final arguments;

  const WriteTodoPage({Key key, this.arguments}) : super(key: key);

  @override
  _WriteTodoPageState createState() =>
      _WriteTodoPageState(arguments: this.arguments);
}

class _WriteTodoPageState extends State<WriteTodoPage> {
  TodoBeanEntity arguments;
  TodoSqliteHelper todoSqliteHelper;
  TextEditingController content;

  _WriteTodoPageState({this.arguments});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todoSqliteHelper = new TodoSqliteHelper();
    content = new TextEditingController(text: arguments.content);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              title: Text("待办"),
              leading: IconButton(
                iconSize: 36,
                onPressed: () {
                  exit(context);
                },
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  color: ColorUtils.color_black,
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      if (content.text == '') {
                        Toast.show("标题或内容不能为空", context, gravity: Toast.CENTER);
                      } else {
                        updateNote();
                      }
                    },
                    icon: Image.asset('assets/images/icon_ok.png'))
              ],
            ),
            body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: ColorUtils.color_white),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: ListView(children: [
                    TextField(
                      style: TextStyle(fontSize: 20),
                      cursorColor: ColorUtils.color_black,
                      controller: content,
                      decoration: buildInputDecoration("请输入daiban"),
                    ),
                  ]),
                )
            )
        ),onWillPop: () {
          exit(context);
        });

  }

  void exit(BuildContext context) {
    Navigator.of(context).pop(Constants.REFRESH);
  }

  InputDecoration buildInputDecoration(text) {
    return InputDecoration(
        hintText: text,
        border: InputBorder.none,
        hintStyle: TextStyle(color: ColorUtils.color_godden_dark));
  }

  void updateNote() async {
    await todoSqliteHelper.open();
    arguments.content = content.text;
    await todoSqliteHelper.update(arguments).then((value) {
      if (value > 0) {
        Toast.show("修改成功", context, gravity: Toast.CENTER);
        exit(context);
      }
    });
    await todoSqliteHelper.close();
  }
}
