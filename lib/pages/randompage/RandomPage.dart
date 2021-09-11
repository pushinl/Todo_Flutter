import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_flutter/pages/Color.dart';
import 'package:todo_flutter/pages/todopage/sqlite/TodoSqliteHelper.dart';
import '../../bean/todo_bean_entity.dart';
import 'dart:math';
import 'package:sensors/sensors.dart';
import 'package:vibration/vibration.dart';

class RandomPage extends StatefulWidget {
  const RandomPage({Key key}) : super(key: key);

  @override
  _RandomPageState createState() => _RandomPageState();
}

class _RandomPageState extends State<RandomPage> {

  StreamSubscription _streamSubsciption;
  TodoSqliteHelper todoSqliteHelper;
  List<TodoBeanEntity> todoList = <TodoBeanEntity>[];
  int flag = 0;
  var _lastTime = 0;
  static const int SHAKE_TIMEOUT = 500;
  static const double SHAKE_THRESHOLD = 3.25;

  @override
  void initState() {
    todoSqliteHelper = new TodoSqliteHelper();
    getAllTodo();
    super.initState();

    _streamSubsciption = accelerometerEvents.listen((AccelerometerEvent event) {
      var now = DateTime.now().millisecondsSinceEpoch;
      if ((now - _lastTime) > SHAKE_TIMEOUT) {
        // 摇一摇阀值,不同手机能达到的最大值不同，如某品牌手机只能达到20。
        int value = 20;
        var x = event.x;
        var y = event.y;
        var z = event.z;
        double acce =
            sqrt(x * x + y * y + z * z) - 9.8; //9.8是g，加速度公式，貌似是初中的物理，反正我是忘了
        if (acce > SHAKE_THRESHOLD){
          Vibration.vibrate();
          _lastTime = now;
          setState(() {
            flag = 1;
          });
        }
      }
    });
  }


  @override
  void dispose() {
    super.dispose();
    _streamSubsciption.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorUtils.color_background_main,
        title: Text('摇一摇抽取待办！'),
        leading: IconButton(
          iconSize: 36,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset('assets/back.png', width: 25, height: 20,),
        ),
      ),
      
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: ColorUtils.color_background_main,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                flag = 1;
              });
            },
            child: getRandomTodo(),
            style: ElevatedButton.styleFrom(
              elevation: 0,
            ),
          ),
        )
      ),
    );
  }

  int getRandom(int length){
    return Random().nextInt(length);
  }

  void getAllTodo() async {
    await todoSqliteHelper.open();
    List<TodoBeanEntity> list;
    list = await todoSqliteHelper.getAllTodo(233);
    setState(() {
      todoList.clear();
      todoList.addAll(list);
    });
    await todoSqliteHelper.close();
  }

  Text getRandomTodo() {
    if(flag == 0) return Text('选择困难？点击/摇一摇抽取一个待办吧！:)', style: TextStyle(fontSize: 20),);
    return todoList.length > 0 ?
      Text('就决定是你了！ ${todoList[getRandom(todoList.length)].content}', style: TextStyle(fontSize: 20),)
        : Text('当前没有需要完成的待办哦:)', style: TextStyle(fontSize: 20),);
  }
}

