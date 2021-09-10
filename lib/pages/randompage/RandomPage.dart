import 'package:flutter/material.dart';
import 'package:todo_flutter/pages/Color.dart';

class RandomPage extends StatefulWidget {
  const RandomPage({Key key}) : super(key: key);

  @override
  _RandomPageState createState() => _RandomPageState();
}

class _RandomPageState extends State<RandomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorUtils.color_background_main,
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
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: ElevatedButton(
            onPressed: () {

            },
            child: Text('点击随机抽取一个待办开始干吧！'),
            style: ElevatedButton.styleFrom(
            ),
          ),
        )
      ),
    );
  }


}

