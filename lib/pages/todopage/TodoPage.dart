import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_flutter/bean/todo_bean_entity.dart';
import 'package:todo_flutter/pages/Color.dart';
import 'package:todo_flutter/pages/todopage/sqlite/TodoSqliteHelper.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import '../Constants.dart';
import '../../bean/todo_bean_entity.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:r_calendar/r_calendar.dart';

import 'WriteTodoPage.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key key}) : super(key: key);

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  TodoBeanEntity arguments;
  TextEditingController todoContentController;
  var keyWord; //关键字
  TodoSqliteHelper todoSqliteHelper;
  List<TodoBeanEntity> todoList = <TodoBeanEntity>[];
  var selectType = 1;
  static GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  RCalendarController todoDateController;
  static List<String> labelList = ["学习", "睡觉", "吃饭", "游戏"];

  @override
  void initState() {
    super.initState();
    todoSqliteHelper = new TodoSqliteHelper();
    todoContentController = new TextEditingController();
    arguments = new TodoBeanEntity();
    // controller = RCalendarController.multiple(selectedDates: [
    //   DateTime(2019, 12, 1),
    //   DateTime(2019, 12, 2),
    //   DateTime(2019, 12, 3),
    // ]);
    getAllTodo();
  }

  void addTodo() {
    var result, label, importance;
    showModalBottomSheet(context: context, builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (context1, bottomState) {
            return Container(
              height: 200.0,
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      // TODO:ICON
                      IconButton(
                        //设置时间与重复
                          icon: Icon(Icons.alarm),
                          onPressed: () async {
                            result = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2021),
                                lastDate: DateTime(2030),
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData.dark(),
                                    child: child,
                                  );
                                }
                            );
                            print('$result');
                            if(result.toString() != null) print("qwq");
                            arguments.itemDatetime = result.toString();
                            bottomState(() {
                            });
                          }),
                      IconButton(
                        //设置类别
                          icon: Icon(Icons.lens),
                          onPressed: () {
                            sortDialog();
                          }),
                      IconButton(
                          icon: Icon(Icons.dashboard),
                          onPressed: () {
                            importanceDialog();
                          }),
                      IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            if (todoContentController.text == '') {
                              Toast.show("待办不能为空", context,
                                  gravity: Toast.CENTER);
                            } else {
                              addTodoSetSql();
                              getAllTodo();
                            }
                          })
                    ],
                  ),
                  Container(
                    height: 15,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(result == null ? " ":"$result"),
                      ],
                    ),
                  ),
                  TextField(
                    style: TextStyle(fontSize: 15),
                    cursorColor: ColorUtils.color_black,
                    controller: todoContentController,
                    decoration: buildInputDecoration("想做点什么？"),
                  ),
                  SizedBox(
                    height: 20,
                    child: ElevatedButton(),
                  ),
                ],
              ),
            );
          });
    });
  }

  void gotoWriteTodo(context, TodoBeanEntity e) {
    // TODO：可以参考这里写页面跳转
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return WriteTodoPage(arguments: e);
    })).then((value) {
      if (value == Constants.REFRESH) {
        getAllTodo();
      }
    });
  }

  InputDecoration buildInputDecoration(text) {
    return InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorUtils.color_grey_dd),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorUtils.color_grey_dd),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        hintText: text,
        hintStyle: TextStyle(color: ColorUtils.color_grey_dd));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: new FloatingActionButton(
        onPressed: addTodo,
        tooltip: '添加待办',
        child: new Icon(Icons.add),
      ),
      key: _globalKey,
      body: Container(
        decoration: BoxDecoration(color: ColorUtils.color_white),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              height: 30,
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  InkWell(
                      onTap: () {
                        showPicker(context);
                      },
                      child: Icon(Icons.assignment)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                decoration: BoxDecoration(
                    color: ColorUtils.color_grey_dd,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                            style: TextStyle(fontSize: 15),
                            autofocus: false,
                            cursorColor: ColorUtils.color_black,
                            onChanged: (value) {
                              setState(() {
                                keyWord = value;
                                getAllTodo();
                              });
                            },
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: ColorUtils.color_grey_dd,
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 0, 10, 0),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorUtils.color_grey_dd),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorUtils.color_grey_dd),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText: "输入搜索的内容",
                                hintStyle: TextStyle(
                                    color: ColorUtils.color_grey_666)))),
                    Image.asset(
                      "assets/images/search_search.png",
                      width: 25,
                      height: 25,
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Divider(
                color: ColorUtils.color_grey_dd,
                height: 2,
              ),
            ),
            Expanded(
                child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              separatorBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Divider(
                    color: ColorUtils.color_grey_dd,
                    height: 30,
                  ),
                );
              },
              itemCount: todoList.length,
              itemBuilder: getItemBuilder,
            )),
          ],
        ),
      ),
    );
  }

  Widget getItemBuilder(context, index) {
    var e = todoList[index];
    var targetTime = e.itemDatetime;
    var time = DateFormat("MM月dd日 HH:MM").format(DateTime.parse(targetTime));
    var label = labelList[e.itemLabels];
    return getDismissible(context, e, time, label);
  }

  Dismissible getDismissible(
      context, TodoBeanEntity e, String time, String label) {
    return e.itemStatus == 0
        ? Dismissible(
            onDismissed: (_) {
              deleteById(e.todoId);
              todoList.remove(e);
            },
            key: Key(e.todoId.toString()),
            background: Container(color: Colors.red),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    arguments = e;
                    arguments.itemStatus = 1;
                    setTodoStatus();
                    getAllTodo();
                  },
                  child: Image(
                    image: AssetImage("assets/images/icon_menu.png"),
                    width: 25,
                    height: 25,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  // minVerticalPadding: 0,
                  onPressed: () {
                    // TODO: goToWriteTodo(context, e);
                    gotoWriteTodo(context, e);
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${e.content}",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        Row(
                          children: [
                            Text(label,
                                style: TextStyle(
                                    fontSize: 15, color: randomColor())),
                            SizedBox(
                              width: 20,
                              height: 15,
                            ),
                            Text(time,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: DateTime.now().compareTo(
                                                DateTime.parse(
                                                    e.itemDatetime)) <
                                            0
                                        ? Colors.black
                                        : Colors.red)),
                          ],
                        )
                      ]),
                ),
              ],
            ))
        : Dismissible(
            onDismissed: (_) {
              deleteById(e.todoId);
              todoList.remove(e);
            },
            key: Key(e.todoId.toString()),
            background: Container(color: Colors.red),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    arguments = e;
                    arguments.itemStatus = 0;
                    setTodoStatus();
                    getAllTodo();
                  },
                  child: Image(
                    image: AssetImage("assets/images/icon_ok.png"),
                    width: 20,
                    height: 20,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  // minVerticalPadding: 0,
                  onPressed: () {
                    // TODO: goToWriteTodo(context, e);
                    gotoWriteTodo(context, e);
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${e.content}",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.black38)),
                        Row(
                          children: [
                            Text(label,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black38)),
                            SizedBox(
                              width: 20,
                              height: 15,
                            ),
                            Text(time,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black38)),
                          ],
                        )
                      ]),
                )
              ],
            ));
  }

  AlertDialog sortDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
              content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                ElevatedButton.icon(
                  icon: Icon(Icons.stacked_bar_chart),
                  label: Text('学习'),
                  onPressed: () {
                    arguments.itemLabels = 1;
                    exit(context);
                  },
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.stacked_bar_chart),
                  label: Text('生活'),
                  onPressed: () {
                    arguments.itemLabels = 2;
                    exit(context);
                  },
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.stacked_bar_chart),
                  label: Text('工作'),
                  onPressed: () {
                    arguments.itemLabels = 3;
                    exit(context);
                  },
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.stacked_bar_chart),
                  label: Text('娱乐'),
                  onPressed: () {
                    arguments.itemLabels = 4;
                    exit(context);
                  },
                ),
              ],
            ),
          ));
        });
  }

  AlertDialog importanceDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, 4);
                    },
                    child: Text('重要且紧急'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, 3);
                    },
                    child: Text('不重要且紧急'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, 2);
                    },
                    child: Text('重要且不紧急'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, 1);
                    },
                    child: Text('不重要且不紧急'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void addTodoSetSql() async {
    await todoSqliteHelper.open();
    TodoBeanEntity todoBeanEntity = new TodoBeanEntity();
    todoBeanEntity.content = todoContentController.text;
    todoBeanEntity.itemStatus = 0;
    todoBeanEntity.itemImportance = 3;
    todoBeanEntity.itemDatetime = arguments.itemDatetime;
    todoBeanEntity.itemLabels = 1;
    todoBeanEntity.itemTypeDdlOrRepeat = 1;
    todoBeanEntity.itemTypePersonOrTeam = 2;
    //TODO: Other Params are waited to commit

    await todoSqliteHelper.insert(todoBeanEntity).then((value) {
      if (value.todoId > 0) {
        Toast.show("新增待办成功", context, gravity: Toast.CENTER);
        exit(context);
      }
    });
    await todoSqliteHelper.close();
  }

  void exit(BuildContext context) {
    Navigator.of(context).pop(Constants.REFRESH);
  }

  void getAllTodo() async {
    await todoSqliteHelper.open();
    List<TodoBeanEntity> list;
    if (keyWord != null)
      list = await todoSqliteHelper.searchTodo(keyWord, selectType);
    else
      list = await todoSqliteHelper.getAllTodo(selectType);
    setState(() {
      todoList.clear();
      todoList.addAll(list);
    });
    todoContentController.text = ''; //TODO : 暂时把清空controller的放在这里了。。
    await todoSqliteHelper.close();
  }

  void deleteById(int id) async {
    await todoSqliteHelper.open();
    await todoSqliteHelper.delete(id).then((value) {
      if (value > 0) Toast.show("删除成功", context);
    });
    await todoSqliteHelper.close();
  }

  void setTodoStatus() async {
    await todoSqliteHelper.open();
    await todoSqliteHelper.update(arguments);
    await todoSqliteHelper.close();
  }

  showPicker(BuildContext context) {
    Picker picker = new Picker(
        adapter: PickerDataAdapter<String>(pickerdata: ["按照ddl排序", "按照优先级排序"]),
        changeToFirst: true,
        textAlign: TextAlign.left,
        columnPadding: const EdgeInsets.all(8.0),
        confirmText: "确定",
        confirmTextStyle: TextStyle(color: ColorUtils.color_black),
        cancelText: "取消",
        cancelTextStyle: TextStyle(color: ColorUtils.color_black),
        onConfirm: (Picker picker, List value) {
          setState(() {
            selectType = value[0] + 1;
          });
          getAllTodo();
        });
    picker.showModal(/*_globalKey.currentState*/ context);
  }
}
