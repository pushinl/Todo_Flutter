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
import 'package:todo_flutter/Calender.dart';

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

  @override
  void initState() {
    super.initState();
    todoSqliteHelper = new TodoSqliteHelper();
    if (arguments != null) {
      todoContentController = new TextEditingController(text: arguments.content);
    } else {
      todoContentController = new TextEditingController();
    }
    // controller = RCalendarController.multiple(selectedDates: [
    //   DateTime(2019, 12, 1),
    //   DateTime(2019, 12, 2),
    //   DateTime(2019, 12, 3),
    // ]);
    getAllTodo();
  }


  @override
  void dispose() {
    super.dispose();
    todoContentController.dispose();
  }

  void addTodo(){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200.0,
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    // TODO:ICON
                    IconButton(icon: Icon(Icons.alarm), onPressed: () {}),
                    IconButton(icon: Icon(Icons.lens), onPressed: () {}),
                    IconButton(icon: Icon(Icons.dashboard), onPressed: () {

                    }),
                    IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          if (todoContentController.text == '') {
                            Toast.show("待办不能为空", context, gravity: Toast.CENTER);
                          }else {
                            addTodoSetSql();
                            getAllTodo();
                          }
                        })
                  ],
                ),
                TextField(
                  style: TextStyle(fontSize: 15),
                  cursorColor: ColorUtils.color_black,
                  controller: todoContentController,
                  decoration: buildInputDecoration("想做点什么？"),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        });
  }

  // void _removeTodoItem(int index) {
  //   setState(() => todoList.removeAt(index));
  // }

  // void _promptRemoveTodoItem(int index) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //             title: new Text('Mark "${todoList[index].content}" as done?'),
  //             actions: <Widget>[
  //               TextButton(
  //                   child: new Text(
  //                     '取消',
  //                     style: new TextStyle(color: Colors.black),
  //                   ),
  //                   onPressed: () => Navigator.of(context).pop()),
  //               TextButton(
  //                   child: new Text(
  //                     '确定',
  //                     style: new TextStyle(color: Colors.black),
  //                   ),
  //                   onPressed: () {
  //                     _removeTodoItem(index);
  //                     Navigator.of(context).pop();
  //                   })
  //             ]);
  //       });
  // }

  void gotoWriteTodo(context,TodoBeanEntity e){
    Navigator.pushNamed(context, '/writeTodo',arguments: e).then((value){
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
              height: 40,
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
              padding: EdgeInsets.all(20),
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
                height: 1,
              ),
            ),
            Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  //加上这个就不会因为高度报错了
                  scrollDirection: Axis.vertical,
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Divider(
                        color: ColorUtils.color_grey_dd,
                        height: 1,
                      ),
                    );
                    },
                  itemCount: todoList.length,
                  itemBuilder: getItemBuilder,
                )
            ),
          ],
        ),
      ),
    );
  }

  Widget getItemBuilder(context, index) {
    var e = todoList[index];
    return getDismissible(context, e);
  }

  Dismissible getDismissible(context, TodoBeanEntity e) {
    return Dismissible(
        onDismissed: (_) {
          deleteById(e.todoId);
          todoList.remove(e);
        },
        key: Key(e.todoId.toString()),
        background: Container(color: Colors.red),
        child: ListTile(
          minVerticalPadding: 0,
          onTap: () {
            // TODO: goToWriteTodo(context, e);
            gotoWriteTodo(context, e);
          },
          title: Text("${e.content}",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ColorUtils.color_grey_666)),
          // subtitle: getListViewPadding(time1, time2, time3, time4, e),
        ));
  }

  // TODO: subtitle
  //  Padding getListViewPadding(String time1, String time2, String time3,
  //     String time4, TodoBeanEntity e) {
  //   return Padding(
  //     padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
  //     child: Flex(
  //       direction: Axis.horizontal,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Text(
  //           "${time1 == time2 ? time3 : time4}",
  //           style: TextStyle(fontSize: 15, color: ColorUtils.color_grey_666),
  //         ),
  //         SizedBox(
  //           width: 20,
  //         ),
  //         Expanded(
  //             child: Text("${e.content}",
  //                 overflow: TextOverflow.ellipsis,
  //                 style: TextStyle(
  //                     fontSize: 15, color: ColorUtils.color_grey_999)))
  //       ],
  //     ),
  //   );
  // }
  void addTodoSetSql() async {
    await todoSqliteHelper.open();
    TodoBeanEntity todoBeanEntity = new TodoBeanEntity();
    todoBeanEntity.content = todoContentController.text;
    todoBeanEntity.itemStatus = 0;
    todoBeanEntity.itemImportance = 1;
    todoBeanEntity.itemDatetime = DateTime.now().toString();
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
  }

  void deleteById(int id) async {
    await todoSqliteHelper.open();
    await todoSqliteHelper.delete(id).then((value) {
      if (value > 0) Toast.show("删除成功", context);
    });
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
