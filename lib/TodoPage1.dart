import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_flutter/Color.dart';
import 'package:todo_flutter/sqlite/SqliteHelper.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'Constants.dart';
import 'bean/note_bean_entity.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:r_calendar/r_calendar.dart';
import 'package:todo_flutter/Calender.dart';
class Todo1Page extends StatefulWidget {

  const Todo1Page({Key key}) : super(key: key);

  @override
  _Todo1PageState createState() => _Todo1PageState();
}

class _Todo1PageState extends State<Todo1Page> {
//侧滑条
  NoteBeanEntity arguments;
  TabController _tabController;
  TextEditingController title;
  var keyWord; //关键字
  SqliteHelper sqliteHelper;
  List<NoteBeanEntity> noteList = <NoteBeanEntity>[];
  var selectType = 1;
  static GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  bool isListView = true;
  RCalendarController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    title=new TextEditingController();
    sqliteHelper = new SqliteHelper();
    getAllNote();
    controller = RCalendarController.multiple(selectedDates: [
      DateTime(2019, 12, 1),
      DateTime(2019, 12, 2),
      DateTime(2019, 12, 3),
    ]);
  }
  // void _pushAddTodoScreen() async {
  //   // 将此页面推入任务栈
  //   var result = await Navigator.of(context).push<String>(
  //     // MaterialPageRoute 会自动为屏幕条目设置动画
  //     // 并添加后退按钮以关闭它
  //       new MaterialPageRoute(builder: (context) {
  //         return new Scaffold(
  //             appBar: new AppBar(title: new Text('Add a new task')),
  //             body: new TextField(
  //               autofocus: true,
  //               onSubmitted: (val) {
  //
  //                 Navigator.pop(context, val); // Close the add todo screen
  //               },
  //               decoration: new InputDecoration(
  //                   hintText: 'Enter something to do...',
  //                   contentPadding: const EdgeInsets.all(16.0)),
  //             ));
  //       }));
  //
  // }


  void _removeTodoItem(int index) {
    setState(() =>noteList.removeAt(index));
  }


  void _promptRemoveTodoItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Text('Mark "${noteList[index].title}" as done?'),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      '取消',
                      style: new TextStyle(color: Colors.black),
                    ),
                    onPressed: () => Navigator.of(context).pop()),
                new FlatButton(
                    child: new Text(
                      '确定',
                      style: new TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      _removeTodoItem(index);
                      Navigator.of(context).pop();
                    })
              ]);
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


  Future _openModalBottomSheet() async {
    final option = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200.0,
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    // TODO:ICON
                    IconButton(icon: Icon(Icons.alarm), onPressed: (){}),
                    IconButton(icon: Icon(Icons.lens), onPressed: (){}),
                    IconButton(icon: Icon(Icons.dashboard), onPressed: (){}),
                  ],
                ),
                TextField(
                  style: TextStyle(fontSize: 15),
                  cursorColor: ColorUtils.color_black,
                  controller: title,
                  decoration: buildInputDecoration("请输入标题"),
                ),
                SizedBox(
                  height: 20,
                ),

                //_showDatePicker()

              ],
            ),
          );
        }
    );

    print(option);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: new FloatingActionButton(
        onPressed: _openModalBottomSheet,
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
                                getAllNote();
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
                                    color: ColorUtils.color_grey_dd)))),
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
                child: isListView
                    ? ListView.separated(
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
                  itemCount: noteList.length,
                  itemBuilder: getItemBuilder,
                )
                    : Padding(
                  padding: EdgeInsets.all(10),
                  child: GridView.builder(
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,

                        ///三列
                        crossAxisSpacing: 10, //水平元素的间距
                        mainAxisSpacing: 10, //垂直距离的间距
                      ),
                      itemCount: noteList.length,
                      itemBuilder: getItemBuilder),
                )),
            Container(
              color: ColorUtils.color_grey_999,
              height: 40,
              child: Text("${noteList.length}个待办",
                  style:
                  TextStyle(fontSize: 10, color: ColorUtils.color_white)),
              alignment: Alignment.center,
            ),


          ],
        ),
      ),


    );
  }

  Widget getItemBuilder(context, index) {
    var e = noteList[index];
    var targetTime = selectType == 1 ? e.addTime : e.updateTime;
    var time1 = DateFormat("yyyy-MM-dd").format(DateTime.parse(targetTime));
    var time2 = DateFormat("yyyy-MM-dd").format(DateTime.now());
    var time3 = DateFormat("HH:mm").format(DateTime.parse(targetTime));
    var time4 =
    DateFormat("yyyy-MM-dd HH:mm").format(DateTime.parse(targetTime));
    return isListView
        ? getDismissible(context, e, time1, time2, time3, time4)
        : Dismissible(
        onDismissed: (_) {
          deleteById(e.noteId);
          getAllNote();
        },
        key: Key(e.noteId.toString()),
        child: InkWell(
          onTap: () {
            goToWriteNote(context, e);
          },
          child: Container(
            height: 100,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(color: ColorUtils.color_black),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${e.title}",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: ColorUtils.color_grey_666)),
                Text("${e.content}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: ColorUtils.color_grey_666)),
                Text(
                  "${time1 == time2 ? time3 : time4}",
                  style: TextStyle(
                      fontSize: 10, color: ColorUtils.color_black),
                )
              ],
            ),
          ),
        ));
  }

  Dismissible getDismissible(context, NoteBeanEntity e, String time1,
      String time2, String time3, String time4) {
    return Dismissible(
        onDismissed: (_) {
          deleteById(e.noteId);
          noteList.remove(e);
        },
        key: Key(e.noteId.toString()),
        child: ListTile(
          minVerticalPadding: 0,
          onTap: () {
            goToWriteNote(context, e);
          },
          title: Text("${e.title}",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: ColorUtils.color_grey_666)),
          subtitle: getListViewPadding(time1, time2, time3, time4, e),
        ));
  }

  void goToWriteNote(context, NoteBeanEntity e) {
    Navigator.pushNamed(context, "/writeNote", arguments: e).then((value) {
      if (value == Constants.REFRESH) {
        getAllNote();
      }
    });
  }

  Padding getListViewPadding(String time1, String time2, String time3,
      String time4, NoteBeanEntity e) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${time1 == time2 ? time3 : time4}",
            style: TextStyle(fontSize: 15, color: ColorUtils.color_grey_666),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
              child: Text("${e.content}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 15, color: ColorUtils.color_grey_999)))
        ],
      ),
    );
  }

  void getAllNote() async {
    await sqliteHelper.open();
    List<NoteBeanEntity> list;
    if (keyWord != null)
      list = await sqliteHelper.searchNote(keyWord, selectType);
    else
      list = await sqliteHelper.getAllNote(selectType);
    setState(() {
      noteList.clear();
      noteList.addAll(list);
    });
  }

  void deleteAll() async {
    await sqliteHelper.open();
    await sqliteHelper.deleteAll();
    getAllNote();
  }

  void deleteById(int id) async {
    await sqliteHelper.open();
    await sqliteHelper.delete(id).then((value) {
      if (value > 0) Toast.show("删除成功", context);
    });
  }

  showPicker(BuildContext context) {
    Picker picker = new Picker(
        adapter: PickerDataAdapter<String>(pickerdata: ["按照dd排序", "按照优先级排序"]),
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
          getAllNote();
        });
    picker.showModal(/*_globalKey.currentState*/ context);
  }
}
