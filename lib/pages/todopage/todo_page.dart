import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_flutter/bean/todo_bean_entity.dart';
import 'package:todo_flutter/main.dart';
import 'package:todo_flutter/pages/color_utils.dart';
import 'package:todo_flutter/pages/todopage/sqlite/todo_sqlite_helper.dart';
import 'package:toast/toast.dart';
import 'package:todo_flutter/pages/todopage/todo_service.dart';
import 'dart:async';
import '../constants.dart';
import '../../bean/todo_bean_entity.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:r_calendar/r_calendar.dart';
import 'dart:ui';
import 'package:intl/date_symbol_data_local.dart';

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
  static List<String> labelList = ['其他', '学习', '生活', '工作', '娱乐'];
  var width, height;

  @override
  void initState() {
    super.initState();
    todoSqliteHelper = new TodoSqliteHelper();
    todoContentController = new TextEditingController();
    arguments = new TodoBeanEntity();

    initializeDateFormatting();
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 5, 15),
        child: Container(
            width: 50,
            height: height*0.08,
            child: FloatingActionButton(
              onPressed: () {
                addTodo(0);
              },
              backgroundColor: ColorUtils.color_blue_main,
              elevation: 0,
              child: new Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            )),
      ),
      key: _globalKey,
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: ColorUtils.color_background_main,
        ),
        child: Column(
          children: [
            Container(
              height: height * 0.15,
              width: width - 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [Color(0xFF656DFD), Color(0xFF6BAEF0)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
              ),
              child: Column(
                children: [
                  SizedBox(height: height*0.015,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context,'/Person').then((value) => null);
                            },
                            icon: Image.asset('assets/images/avatar_default.png', width: 35.0, height: 35.0),
                          )
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context,'/Person').then((value) => null);
                        },
                        child: Text(
                          '${Global.user.account}',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: width*0.25,),
                      Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              showPicker(context);
                            },
                            icon: Image.asset('assets/more_icon.png', width: 18.0, height: 18.0),
                          )
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context,'/Random').then((value) => null);
                            },
                            icon: Image.asset('assets/shake.png', width: 25.0, height: 25.0),
                          )
                      ),
                    ],
                  ),
                  //下面是搜索栏
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Container(
                      height: height*0.045,
                      width: width*0.8,
                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/search_icon.png",
                            width: 20,
                          ),
                          Expanded(
                              child: TextField(
                                  style: TextStyle(fontSize: 15),
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
                                      fillColor: Colors.white,
                                      contentPadding:
                                      EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white),
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(40))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white),
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(40))),
                                      hintText: "搜索待办",
                                      hintStyle: TextStyle(
                                          color: ColorUtils.color_blue_main, fontSize: 15)))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            //下面是List
            todoList.length > 0 ? Expanded(
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
            ) : Padding(
              padding: EdgeInsets.fromLTRB(0,height*0.3,0,0),
              child: Text('点击右下角按钮添加新的待办~', style: TextStyle(fontSize: 16, color: ColorUtils.color_grey_666),),
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
                        child: Image.asset(
                          'assets/circle/Ellipse.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: width * 0.63,
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
                                                          .itemDatetime)) >
                                                  0
                                              ? ColorUtils.color_delete
                                              : ColorUtils.color_date_text)),
                                  SizedBox(
                                    width: 20,
                                    height: 15,
                                  )
                                ],
                              )
                            ]),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: getImage(e.itemImportance),
                      ),
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
                            width: width * 0.63,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${e.content}",
                                    style: TextStyle(
                                      fontSize: 19,
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
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: getImage(e.itemImportance),
                          ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context1, bottomState) {
            return Container(
              height: 140.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFF656DFD), Color(0xFF6BAEF0)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
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
                                icon: arguments.itemDatetime==null ? Image.asset(
                                  'assets/images/time.png',
                                  width: 18,
                                  height: 18,
                                ):Image.asset(
                                  'assets/images/time_ok.png',
                                  width: 18,
                                  height: 18,
                                ),
                                onPressed: () async {
                                  result = await showDatePicker(
                                    context: context,
                                    initialDate: arguments.itemDatetime == null ? DateTime.now() : DateTime.parse(arguments.itemDatetime),
                                    firstDate: DateTime(2021),
                                    lastDate: DateTime(2100),
                                    builder: (context, child) {
                                      return Theme(
                                        data: ThemeData.light().copyWith(
                                          primaryColor: ColorUtils.color_blue_main,
                                          accentColor: ColorUtils.color_blue_main,
                                          colorScheme: ColorScheme.light(primary: ColorUtils.color_blue_main),
                                          buttonTheme: ButtonThemeData(
                                              textTheme: ButtonTextTheme.primary
                                          ),
                                        ),
                                        child: child,
                                      );
                                    });
                                  //print('$result');
                                  if (result != null)
                                    arguments.itemDatetime = result.toString();
                                  bottomState(() {});
                                }),
                            IconButton(
                                icon: arguments.itemImportance == null ? Image.asset(
                                  'assets/images/priority.png',
                                  width: 18,
                                  height: 18,
                                ) : Image.asset(
                                  'assets/images/pri_ok.png',
                                  width: 18,
                                  height: 18,
                                ),
                                onPressed: () async {
                                  await importanceDialog();
                                  bottomState(() {});
                                }),
                            IconButton(
                                icon: arguments.itemLabels == null ? Image.asset(
                                  'assets/images/type.png',
                                  width: 18,
                                  height: 18,
                                ) : Image.asset(
                                  'assets/images/type_ok.png',
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
                                width: 20,
                                height: 20,
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
                  Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Container(
                        height: height*0.07,
                        child: TextField(
                          style: TextStyle(fontSize: 15),
                          cursorHeight: 20,
                          cursorColor: ColorUtils.color_blue_main,
                          controller: todoContentController,
                          decoration: buildInputDecoration(" 想做点什么？ "),
                        ),
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
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.bold),
        );
    }
    return Text(
      '! 无优先级',
      style: TextStyle(
          color: Colors.grey,
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
      contentPadding: EdgeInsets.only(left: 15),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorUtils.color_white),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorUtils.color_white),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      hintText: text,
      hintStyle: TextStyle(color: ColorUtils.color_grey_666),
      filled: true,
      fillColor: ColorUtils.color_white,
    );
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
                  child: Text(' 学习 '),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                  ),
                  onPressed: () {
                    arguments.itemLabels = 1;
                    exit(context);
                  },
                ),
                ElevatedButton(
                  child: Text(' 生活 '),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                  ),
                  onPressed: () {
                    arguments.itemLabels = 2;
                    exit(context);
                  },
                ),
                ElevatedButton(
                  child: Text(' 工作 '),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                  ),
                  onPressed: () {
                    arguments.itemLabels = 3;
                    exit(context);
                  },
                ),
                ElevatedButton(
                  child: Text(' 娱乐 '),
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
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  getImportanceElevatedButton(4, dialogContext),
                  getImportanceElevatedButton(3, dialogContext),
                  getImportanceElevatedButton(2, dialogContext),
                  getImportanceElevatedButton(1, dialogContext),
                ],
              ),
            ),
          );
        });
  }

  ElevatedButton getImportanceElevatedButton(int i, BuildContext context) {
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
    //TODO: Other Params are waited to commit
    print(todoBeanEntity.itemDatetime);

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
