import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:todo_flutter/pages/Color.dart';

import '../../main.dart';
import '../Constants.dart';

class PersonPage extends StatefulWidget {
  const PersonPage({Key key}) : super(key: key);
  @override
  _PersonPageState createState() => _PersonPageState();
}

var userAvatar;
var userName;
var titles = ["登录"];
var titleTextStyle = new TextStyle(fontSize: 16.0);

class _PersonPageState extends State<PersonPage> {
  var width, height;


  @override
  void initState() {
    super.initState();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Scaffold(
      backgroundColor: ColorUtils.color_background_main,
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          height: height * 0.43,
          width: width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: SizedBox(
            child: Column(
              children: [
                Container(
                  width: width * 0.7,
                  height: height * 0.15,
                  child: Global.isLogin ? _getUserProfile(context) : ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/Login').then((value) {
                        if (value == Constants.REFRESH) {
                          setState(() {});
                        }
                      });
                    },
                    child: Text('请登录', style: TextStyle(fontSize: 25),),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.03,),
                SizedBox(
                  width: width * 0.55,
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, "/feedback");
                    },
                    leading: Image.asset('assets/twt_assets/feedback.png', width: 25, height: 25,),
                    title: Text('用户反馈', style: TextStyle(fontSize: 15),),
                  ),
                ),
                SizedBox(
                  width: width * 0.55,
                  child: ListTile(
                    onTap: () async {
                      const APP_KEY = "banana";
                      const APP_SECRET = "37b590063d593716405a2c5a382b1130b28bf8a7";
                      const DOMAIN = "weipeiyang.twt.edu.cn";
                      String ticket = base64Encode(utf8.encode(APP_KEY + '.' + APP_SECRET));
                      Map<String, String> headers = {"DOMAIN": DOMAIN, "ticket": ticket};
                      var result = await Dio().post("http://42.193.115.210:8080/api/logout",
                          options: Options(headers: headers),
                          queryParameters: {});
                      print(result);
                      Navigator.of(context).pushAndRemoveUntil(
                          new MaterialPageRoute(builder: (context) => new MyApp()
                          ), (route) => route == null);
                      Global.isLogin = false;
                    },
                    leading: Image.asset('assets/twt_assets/logout.png', width: 25, height: 25,),
                    title: Text('登出', style: TextStyle(fontSize: 15),),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

ElevatedButton _getUserProfile(BuildContext context){
  return ElevatedButton(
    onPressed: () {
      Toast.show('你的身份证号是：${Global.user.idNumber}', context);
    },
    child: Row(
      children: [
        Image.asset('assets/images/avatar_default.jpg', width: 60, height: 60,),
        SizedBox(width: 25,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${Global.user.realname}', style: TextStyle(color: Color(0xFF222222), fontSize: 22, fontWeight: FontWeight.normal),),
            Text('${Global.user.userNumber}', style: TextStyle(color: Color(0xFF222222), fontSize: 18, fontWeight: FontWeight.normal),),
          ],
        ),
      ],
    ),
    style: ElevatedButton.styleFrom(
      elevation: 0,
    ),
  );
}
