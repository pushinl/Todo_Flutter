import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_flutter/pages/Color.dart';
import 'package:todo_flutter/pages/Tabs.dart';
import 'package:todo_flutter/pages/notepage/sqlite/NoteSqliteHelper.dart';
import 'package:toast/toast.dart';

import '../Constants.dart';
import 'package:todo_flutter/bean/note_bean_entity.dart';
import 'package:flutter_picker/flutter_picker.dart';

class NoteMainPage extends StatefulWidget {
  const NoteMainPage({Key key}) : super(key: key);

  @override
  _NoteMainPageState createState() => _NoteMainPageState();
}

class _NoteMainPageState extends State<NoteMainPage> {
  var width, height;

  var keyWord; //关键字
  NoteSqliteHelper sqliteHelper;
  List<NoteBeanEntity> noteList = <NoteBeanEntity>[];
  var selectType = 1; //1 按编辑日期 2 按创建日期 3 按标题
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    sqliteHelper = new NoteSqliteHelper();
    getAllNote();
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
              Navigator.pushNamed(context, "/writeNote").then((value) {
                if (value == Constants.REFRESH) {
                  getAllNote();
                }
              });
            },
            backgroundColor: ColorUtils.color_blue_main,
            elevation: 0,
            tooltip: '添加备忘录',
            child: new Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          )),
      key: _globalKey,
      body: Container(
        decoration: BoxDecoration(color: ColorUtils.color_background_main),
        child: Column(
          children: [
            //搜索栏：
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
            noteList.length > 0 ? Expanded(
                child: ListView.separated(
              shrinkWrap: true,
              //加上这个就不会因为高度报错了
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
              itemCount: noteList.length,
              itemBuilder: getItemBuilder,
            )) : Padding(
              padding: EdgeInsets.fromLTRB(0,height*0.3,0,0),
              child: Text('点击右下角按钮添加新的备忘录~', style: TextStyle(fontSize: 16, color: ColorUtils.color_grey_666),),
            ),
          ],
        ),
      ),
    );
  }

  Widget getItemBuilder(context, index) {
    var e = noteList[index];
    var targetTime = selectType == 2 ? e.addTime : e.updateTime;
    var time1 = DateFormat("MM月dd日").format(DateTime.parse(targetTime));
    var time2 = DateFormat("MM月dd日").format(DateTime.now());
    var time3 = DateFormat("HH:mm").format(DateTime.parse(targetTime));
    var time4 = DateFormat("MM月dd日 HH:mm").format(DateTime.parse(targetTime));
    return getDismissible(context, e, time1, time2, time3, time4);
  }

  Dismissible getDismissible(context, NoteBeanEntity e, String time1,
      String time2, String time3, String time4) {
    return Dismissible(
        onDismissed: (_) {
          deleteById(e.noteId);
          noteList.remove(e);
          getAllNote();
        },
        key: Key(e.noteId.toString()),
        background: Container(color: ColorUtils.color_delete),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ElevatedButton(
            // minVerticalPadding: 0,
            onPressed: () {
              goToWriteNote(context, e);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: Container(
              height: height*0.1,
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: width * 0.7,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 5,),
                          Text("${e.title}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: ColorUtils.color_text)),
                          getListViewPadding(time1, time2, time3, time4, e),
                          SizedBox(height: 5,)
                        ]),
                  )
                ],
              ),
            ),
          ),
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
      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${time1 == time2 ? time3 : time4}",
            style: TextStyle(
              fontSize: 14,
              color: ColorUtils.color_grey_666,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            '  |  ',
            style: TextStyle(
              fontSize: 14,
              color: ColorUtils.color_grey_666,
              fontWeight: FontWeight.normal,
            ),
          ),
          Expanded(
              child: Text("${e.content}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorUtils.color_grey_666,
                    fontWeight: FontWeight.normal,
                  )))
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

  // void deleteAll() async {
  //   await sqliteHelper.open();
  //   await sqliteHelper.deleteAll();
  //   getAllNote();
  // }

  void deleteById(int id) async {
    await sqliteHelper.open();
    await sqliteHelper.delete(id).then((value) {
      if (value > 0) Toast.show("删除成功", context);
    });
  }

  showPicker(BuildContext context) {
    Picker picker = new Picker(
        adapter:
            PickerDataAdapter<String>(pickerdata: ["按照更新时间排序", "按照创建时间排序"]),
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
