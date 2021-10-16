import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:todo_flutter/pages/color_utils.dart';

import '../../main.dart';
import '../constants.dart';

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
      appBar: AppBar(
        backgroundColor: ColorUtils.color_background_main,
        elevation: 0,
        toolbarHeight: 10,
      ),
      backgroundColor: ColorUtils.color_background_main,
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Container(
                width: width * 0.8,
                height: height * 0.18,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [Color(0xFF656DFD), Color(0xFF6BAEF0)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                ),
                child: Row(
                  children: [
                    SizedBox(width: 25,),
                    Image.asset('assets/images/avatar_default.png', width: 60, height: 60,),
                    SizedBox(width: 25,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${Global.user.account}', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ],
                )
            ),
            SizedBox(height: 15,),
            Container(
              height: height * 0.08,
              width: width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              alignment: Alignment.center,
              child: SizedBox(
                width: width * 0.7,
                child: ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, "/feedback");
                  },
                  leading: Image.asset('assets/twt_assets/feedback.png', width: 25, height: 25,),
                  title: Text('用户反馈', style: TextStyle(fontSize: 15, color: ColorUtils.color_text),),
                ),
              ),
            ),
            SizedBox(height: 13,),
            Container(
              height: height * 0.08,
              width: width * 0.8,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: SizedBox(
                width: width * 0.7,
                child: ListTile(
                  onTap: () async {
                    Navigator.of(context).pushAndRemoveUntil(
                        new MaterialPageRoute(builder: (context) => new MyApp()
                        ), (route) => route == null);
                    Global.isLogin = false;
                  },
                  leading: Image.asset('assets/twt_assets/logout.png', width: 25, height: 25,),
                  title: Text('登出', style: TextStyle(fontSize: 15, color: ColorUtils.color_text),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}