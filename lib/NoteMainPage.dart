import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_flutter/Color.dart';
import 'package:todo_flutter/sqlite/SqliteHelper.dart';
import 'package:toast/toast.dart';

import 'Constants.dart';
import 'package:todo_flutter/bean/note_bean_entity.dart';
import 'package:flutter_picker/flutter_picker.dart';

class NoteMainPage extends StatefulWidget {
  const NoteMainPage({Key key}) : super(key: key);

  @override
  _NoteMainPageState createState() => _NoteMainPageState();

}



class _NoteMainPageState extends State<NoteMainPage> {

  TabController _controller;


  var keyWord; //关键字
  SqliteHelper sqliteHelper;
  List<NoteBeanEntity> noteList = <NoteBeanEntity>[];
  var selectType = 1; //1 按编辑日期 2 按创建日期 3 按标题
  static GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  bool isListView = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _controller = TabController(
    //   length: _tabValues.length,
    //   vsync: ScrollableState(),
    // );
    sqliteHelper = new SqliteHelper();
    getAllNote();
  }


  //点击导航项是要显示的页面


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text("备忘录"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/writeNote").then((value) {
                  if (value == Constants.REFRESH) {
                    getAllNote();
                  }
                });
              },
              icon: Icon(Icons.add)),
        ],
      // bottom: TabBar(
      //   tabs: _tabValues.map((f){
      //     return Text(f);
      //   } ).toList(),
      //   controller: _controller,
      //   indicatorColor: Colors.black,
      //   indicatorSize: TabBarIndicatorSize.tab,
      //   isScrollable: true,
      //     labelColor: Colors.red,
      //     unselectedLabelColor: Colors.black,
      //     indicatorWeight: 5.0,
      //     labelStyle: TextStyle(height: 2),
      //
      // ),
      ),
      body:

      Container(
        decoration: BoxDecoration(color: ColorUtils.color_white),
        child: Column(
          children: [
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
                                    color: ColorUtils.color_grey_666)))),
                    Image.asset  (
                      "assets/images/search_search.png",
                      width: 25,
                      height: 25,
                    )
                  ],
                ),
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
              child: Text("${noteList.length}个备忘录",
                  style:
                      TextStyle(fontSize: 10, color: ColorUtils.color_white)),
              alignment: Alignment.center,
            )
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
        adapter: PickerDataAdapter<String>(
            pickerdata: ["按照dd排序", "按照优先级排序"]),
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
