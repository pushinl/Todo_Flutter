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
import 'dart:ui';

class TodoPage extends StatefulWidget {
  const TodoPage({Key key}) : super(key: key);

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  TodoBeanEntity arguments;
  TextEditingController todoContentController;
  var keyWord; //关键字
  static TodoSqliteHelper todoSqliteHelper;
  List<TodoBeanEntity> todoList = <TodoBeanEntity>[];
  var selectType = 1;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  RCalendarController todoDateController;
  static List<String> labelList = ['#其他', '#学习', '#生活', '#工作', '#娱乐'];
  var width, height;

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Container(
          width: 50,
          height: height*0.08,
          child: FloatingActionButton(
            onPressed: () {
              addTodo(0);
            },
            backgroundColor: ColorUtils.color_blue_main,
            tooltip: '添加待办',
            elevation: 0,
            child: new Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          )),
      key: _globalKey,
      body: Container(
        decoration: BoxDecoration(
          color: ColorUtils.color_background_main,
        ),
        child: Column(
          children: [
            //下面是搜索栏
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
              child: Row(
                children: [
                  Container(
                    height: height*0.045,
                    width: width - 73,
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    decoration: BoxDecoration(
                        color: ColorUtils.color_grey_dd,
                        borderRadius: BorderRadius.all(Radius.circular(40))),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/search_icon.png",
                          width: 15,
                          height: height*0.03,
                        ),
                        Expanded(
                            child: TextField(
                                style: TextStyle(fontSize: 14),
                                autofocus: false,
                                cursorColor: ColorUtils.color_text,
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
                                        BorderRadius.all(Radius.circular(40))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorUtils.color_grey_dd),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(40))),
                                    hintText: "Search...",
                                    hintStyle: TextStyle(
                                        color: ColorUtils.color_grey_666)))),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Image.asset(
                        'assets/more_icon.png',
                        width: 15,
                        height: height*0.03,
                      ),
                      onPressed: () {
                        showPicker(context);
                      },
                    ),
                  )
                ],
              ),
            ),
            //下面是List
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Divider(
                      color: ColorUtils.color_grey_dd,
                      height: 10,
                    ),
                  );
                },
                itemCount: todoList.length,
                itemBuilder: getItemBuilder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getItemBuilder(context, index) {
    var e = todoList[index];
    var targetTime = e.itemDatetime;
    var time = DateFormat("MM月dd日")
        .format(DateTime.parse(targetTime)); //TODO：TIMEPICKER
    var label = labelList[e.itemLabels];
    int labelType = e.itemLabels;
    int importance = e.itemImportance;
    return getDismissible(context, e, time, label, labelType, importance);
  }

  Dismissible getDismissible(context, TodoBeanEntity e, String time,
      String label, int labelType, int importance) {
    return e.itemStatus == 0
        ? Dismissible(
            onDismissed: (_) {
              deleteById(e.todoId);
              todoList.remove(e);
              getAllTodo();
            },
            key: Key(e.todoId.toString()),
            background: Container(color: ColorUtils.color_delete),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: ElevatedButton(
                // minVerticalPadding: 0,
                onPressed: () {
                  arguments = e;
                  addTodo(1);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Container(
                  height: height * 0.1,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          arguments = e;
                          arguments.itemStatus = 1;
                          setTodoStatus();
                          getAllTodo();
                        },
                        child: getImage(e.itemImportance),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: width * 0.7,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${e.content}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: ColorUtils.color_text)),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text(label,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: ColorUtils
                                              .color_blue_main)),
                                  SizedBox(
                                    width: 20,
                                    height: 15,
                                  ),
                                  Text(time,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: DateTime.now().compareTo(
                                                      DateTime.parse(e
                                                          .itemDatetime)) <
                                                  0
                                              ? ColorUtils.color_date_text
                                              : ColorUtils.color_delete)),
                                  SizedBox(
                                    width: 20,
                                    height: 15,
                                  )
                                ],
                              )
                            ]),
                      )
                    ],
                  ),
                ),
              ),
            ))
        : Dismissible(
            onDismissed: (_) {
              deleteById(e.todoId);
              todoList.remove(e);
              getAllTodo();
            },
            key: Key(e.todoId.toString()),
            background: Container(color: ColorUtils.color_delete),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Container(
                  width: width - 40,
                  child: ElevatedButton(
                    // minVerticalPadding: 0,
                    onPressed: () {
                      arguments = e;
                      addTodo(1);
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    child: Container(
                      height: height*0.1,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              arguments = e;
                              arguments.itemStatus = 0;
                              setTodoStatus();
                              getAllTodo();
                            },
                            child: Image(
                              image: AssetImage("assets/circle/finished.png"),
                              width: 24,
                              height: 24,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: width * 0.7,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${e.content}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.lineThrough,
                                      color: ColorUtils.color_delete_text,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text(label,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: ColorUtils
                                                  .color_delete_text)),
                                      SizedBox(
                                        width: 20,
                                        height: 15,
                                      ),
                                      Text(time,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: ColorUtils
                                                  .color_delete_text)),
                                    ],
                                  )
                                ]),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ));
  }

  void addTodo(int option) {
    //0 : add   1 : update
    var result;
    if (option == 1)
      todoContentController.text = arguments.content;
    else {
      //add
      arguments = new TodoBeanEntity();
      todoContentController.text = '';
    }
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context1, bottomState) {
            return Container(
              height: 200.0,
              child: Column(
                children: <Widget>[
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            IconButton(
                                //设置时间与重复
                                icon: Image.asset(
                                  'assets/images/time.png',
                                  width: 18,
                                  height: 18,
                                ),
                                onPressed: () async {
                                  result = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2021),
                                      lastDate: DateTime(2030),
                                      builder: (context, child) {
                                        return Theme(
                                          data: ThemeData.fallback(),
                                          child: child,
                                        );
                                      });
                                  //print('$result');
                                  if (result != null)
                                    arguments.itemDatetime = result.toString();
                                  bottomState(() {});
                                }),
                            IconButton(
                                icon: Image.asset(
                                  'assets/images/priority.png',
                                  width: 18,
                                  height: 18,
                                ),
                                onPressed: () async {
                                  await importanceDialog();
                                  bottomState(() {});
                                }),
                            IconButton(
                                icon: Image.asset(
                                  'assets/images/type.png',
                                  width: 18,
                                  height: 18,
                                ),
                                onPressed: () async {
                                  await sortDialog();
                                  bottomState(() {});
                                }),
                          ],
                        ),
                      ),
                      Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              icon: Image.asset(
                                'assets/images/reok.png',
                                width: 18,
                                height: 18,
                              ),
                              onPressed: () {
                                if (todoContentController.text == '') {
                                  Toast.show("待办不能为空！", context);
                                } else if (arguments.itemDatetime == null) {
                                  Toast.show("请选择待办时间！", context);
                                } else {
                                  option == 1 ? updateTodo() : addTodoSetSql();
                                  getAllTodo();
                                }
                              })),
                    ],
                  ),
                  Container(
                    height: 25,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          child: Text(
                            arguments.itemDatetime == null
                                ? ' 请选择日期！ '
                                : DateFormat(" MM月dd日 ").format(
                                    DateTime.parse(arguments.itemDatetime)),
                            style: TextStyle(
                                fontSize: 15,
                                color: ColorUtils.color_blue_main),
                          ),
                          color: ColorUtils.color_background_main,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        getImportanceText(arguments.itemImportance),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          child: Text(
                            arguments.itemLabels == null
                                ? ' #其他 '
                                : labelList[arguments.itemLabels],
                            style: TextStyle(
                                fontSize: 15,
                                color: ColorUtils.color_blue_main),
                          ),
                          color: ColorUtils.color_background_main,
                        )
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                      child: TextField(
                        style: TextStyle(fontSize: 15),
                        cursorColor: ColorUtils.color_text,
                        controller: todoContentController,
                        decoration: buildInputDecoration(" 想做点什么？ "),
                      )),
                ],
              ),
            );
          });
        });
  }

  Text getImportanceText(int imp) {
    switch (imp) {
      case 4:
        return Text(
          '!!!! 高优先级',
          style: TextStyle(
              color: ColorUtils.color_delete,
              fontSize: 15,
              fontWeight: FontWeight.bold),
        );
      case 3:
        return Text(
          '!!! 中优先级',
          style: TextStyle(
              color: ColorUtils.color_blue_light,
              fontSize: 15,
              fontWeight: FontWeight.bold),
        );
      case 2:
        return Text(
          '!! 低优先级',
          style: TextStyle(
              color: ColorUtils.color_green,
              fontSize: 15,
              fontWeight: FontWeight.bold),
        );
      case 1:
        return Text(
          '! 无优先级',
          style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 15,
              fontWeight: FontWeight.bold),
        );
    }
    return Text(
      '! 无优先级',
      style: TextStyle(
          color: Colors.blueGrey,
          fontSize: 15,
          fontWeight: FontWeight.bold),
    );
  }

  // void gotoWriteTodo(context, TodoBeanEntity e) {
  //   // TODO：可以参考这里写页面跳转
  //   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
  //     return WriteTodoPage(arguments: e);
  //   })).then((value) {
  //     if (value == Constants.REFRESH) {
  //       getAllTodo();
  //     }
  //   });
  // }

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

  Image getImage(int image) {
    return Image.asset(
      'assets/circle/Todo_$image.png',
      width: 24,
      height: 24,
    );
  }

  Future sortDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
              content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                ElevatedButton(
                  child: Text(' #学习 '),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                  ),
                  onPressed: () {
                    arguments.itemLabels = 1;
                    exit(context);
                  },
                ),
                ElevatedButton(
                  child: Text(' #生活 '),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                  ),
                  onPressed: () {
                    arguments.itemLabels = 2;
                    exit(context);
                  },
                ),
                ElevatedButton(
                  child: Text(' #工作 '),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                  ),
                  onPressed: () {
                    arguments.itemLabels = 3;
                    exit(context);
                  },
                ),
                ElevatedButton(
                  child: Text(' #娱乐 '),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                  ),
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

  Future importanceDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  getImportanceElevatedButton(4),
                  getImportanceElevatedButton(3),
                  getImportanceElevatedButton(2),
                  getImportanceElevatedButton(1),
                ],
              ),
            ),
          );
        });
  }

  ElevatedButton getImportanceElevatedButton(int i) {
    return ElevatedButton(
      onPressed: () {
        arguments.itemImportance = i;
        exit(context);
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
      ),
      child: getImportanceText(i),
    );
  }

  void addTodoSetSql() async {
    await todoSqliteHelper.open();
    TodoBeanEntity todoBeanEntity = new TodoBeanEntity();
    todoBeanEntity.content = todoContentController.text;
    todoBeanEntity.itemStatus = 0;
    todoBeanEntity.itemImportance = arguments.itemImportance == null
        ? arguments.itemImportance = 1
        : arguments.itemImportance;
    todoBeanEntity.itemDatetime = arguments.itemDatetime == null
        ? arguments.itemDatetime = DateTime.now().toString()
        : arguments.itemDatetime;
    todoBeanEntity.itemLabels = arguments.itemLabels == null
        ? arguments.itemLabels = 0
        : arguments.itemLabels;
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

  void updateTodo() async {
    await todoSqliteHelper.open();
    arguments.content = todoContentController.text;
    await todoSqliteHelper.update(arguments).then((value) {
      Toast.show("更新待办成功", context, gravity: Toast.CENTER);
      exit(context);
    });
    await todoSqliteHelper.close();
  }

  showPicker(BuildContext context) {
    Picker picker = new Picker(
        adapter: PickerDataAdapter<String>(pickerdata: ["按照DDL排序", "按照优先级排序"]),
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
