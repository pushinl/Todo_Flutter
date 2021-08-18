import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_flutter/pages/Color.dart';
import 'package:todo_flutter/pages/Constants.dart';
import 'package:todo_flutter/pages/notepage/sqlite/NoteSqliteHelper.dart';

import '../../bean/note_bean_entity.dart';
import 'package:toast/toast.dart';

class WriteNotePage extends StatefulWidget {
  final arguments;

  const WriteNotePage({Key key, this.arguments}) : super(key: key);

  @override
  _WriteNotePageState createState() =>
      _WriteNotePageState(arguments: this.arguments);
}

class _WriteNotePageState extends State<WriteNotePage> {
  NoteBeanEntity arguments;
  NoteSqliteHelper noteSqliteHelper;
  TextEditingController title;

  TextEditingController content;

  _WriteNotePageState({this.arguments});

  @override
  void initState() {
    super.initState();
    noteSqliteHelper = new NoteSqliteHelper();
    if (arguments != null) {
      title = new TextEditingController(text: arguments.title);
      content = new TextEditingController(text: arguments.content);
    } else {
      title = new TextEditingController();
      content = new TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(arguments == null ? "新增" : "编辑"),
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
                    if (title.text=='' || content.text=='') {
                      Toast.show("标题或内容不能为空", context, gravity: Toast.CENTER);
                    }else {
                      if (arguments != null ) {
                        updateNote();
                      } else {
                        addNote();
                      }
                    }
                  },
                  icon: Image.asset('assets/images/icon_ok.png')
              )
            ],
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: ColorUtils.color_white),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ListView(
                children: [
                  TextField(
                    style: TextStyle(fontSize: 35),
                    cursorColor: ColorUtils.color_black,
                    controller: title,
                    decoration: buildInputDecoration("请输入标题"),
                  ),
                  TextField(
                    style: TextStyle(fontSize: 15),
                    cursorColor: ColorUtils.color_black,
                    controller: content,
                    minLines: 6,
                    maxLines: 20,
                    decoration: buildInputDecoration("请输入内容"),
                  )
                ],
              ),
            ),
          ),
        ),
        onWillPop: () {
          exit(context);
        });
  }

  void exit(BuildContext context) {
    Navigator.of(context).pop(Constants.REFRESH);
  }

  InputDecoration buildInputDecoration(text) {
    return InputDecoration(
        // enabledBorder: OutlineInputBorder(
        //     borderSide: BorderSide(color: ColorUtils.color_grey_dd),
        //     borderRadius: BorderRadius.all(Radius.circular(10))),
        // focusedBorder: OutlineInputBorder(
        //     borderSide: BorderSide(color: ColorUtils.color_grey_dd),
        //     borderRadius: BorderRadius.all(Radius.circular(10))),
        hintText: text,
        border: InputBorder.none,
        hintStyle: TextStyle(color: ColorUtils.color_grey_dd));
  }

  void addNote() async {
    await noteSqliteHelper.open();
    NoteBeanEntity noteBeanEntity = new NoteBeanEntity();
    noteBeanEntity.title = title.text;
    noteBeanEntity.content = content.text;
    noteBeanEntity.noteCode = DateTime.now().toString();
    noteBeanEntity.addTime =
        DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    noteBeanEntity.updateTime =
        DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    await noteSqliteHelper.insert(noteBeanEntity).then((value) {
      print(value.noteId);
      if (value.noteId > 0) {
        Toast.show("新增成功", context, gravity: Toast.CENTER);
        exit(context);
      }
    });
    await noteSqliteHelper.close();
  }

  void updateNote() async {
    await noteSqliteHelper.open();
    arguments.content = content.text;
    arguments.title = title.text;
    arguments.updateTime =
        DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    await noteSqliteHelper.update(arguments).then((value) {
      if (value > 0) {
        Toast.show("修改成功", context, gravity: Toast.CENTER);
        exit(context);
      }
    });
  }
}
