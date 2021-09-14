import 'package:flutter/material.dart';
import 'package:todo_flutter/pages/Color.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorUtils.color_background_main,
        leading: IconButton(
          iconSize: 36,
          icon: Image.asset('assets/back.png', width: 25, height: 20,),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ),
      body: Container(
        height: height,
        width: width,
        color: ColorUtils.color_background_main,
        child: SizedBox(
          height: height * 0.8,
          width: width * 0.8,
          child: Column(
            children: [
              Text('请加入官方社区QQ群以反馈问题~'),
              Image.asset('assets/qrcode.png')
            ],
          ),
        ),
      ),
    );
  }
}

