import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:todo_flutter/pages/color_utils.dart';
import 'package:todo_flutter/service/error_interceptor.dart';
import 'package:todo_flutter/service/service.dart';

import '../../main.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

const APP_KEY = "banana";
const APP_SECRET = "37b590063d593716405a2c5a382b1130b28bf8a7";
const DOMAIN = "weipeiyang.twt.edu.cn";

class _RegisterPageState extends State<RegisterPage> {

  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  bool pwdShow = false; //密码是否显示明文
  GlobalKey _formKey = new GlobalKey<FormState>();
  bool _nameAutoFocus = true;

  @override
  void initState() {
    if (_unameController.text != null) {
      _nameAutoFocus = false;
    }
    super.initState();
  }

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
          icon: Image.asset(
            'assets/back.png',
            width: 25,
            height: 20,
          ),
        ),
      ),
      body: Container(
        color: ColorUtils.color_background_main,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SizedBox(
            height: MediaQuery.of(context).size.height*0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 120,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '创建搞咩账号',
                      style: TextStyle(
                        fontSize: 30,
                        color: ColorUtils.color_blue_main,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                TextFormField(
                    autofocus: _nameAutoFocus,
                    controller: _unameController,
                    cursorColor: ColorUtils.color_blue_main,
                    cursorHeight: 23,
                    decoration: InputDecoration(
                      labelText: '用户名',
                      hintText: '用户名',
                      prefixIcon: Icon(
                        Icons.person,
                        color: ColorUtils.color_blue_main,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorUtils.color_grey_666),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    // 校验用户名（不能为空）
                    validator: (v) {
                      return v
                          .trim()
                          .isNotEmpty ? null : '账号不能为空';
                    }),
                TextFormField(
                  controller: _pwdController,
                  autofocus: !_nameAutoFocus,
                  cursorColor: ColorUtils.color_blue_main,
                  cursorHeight: 23,
                  decoration: InputDecoration(
                    labelText: '密码',
                    hintText: '密码',
                    prefixIcon: Icon(
                      Icons.lock,
                      color: ColorUtils.color_blue_main,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        pwdShow ? Icons.visibility_off : Icons.visibility,
                        color: ColorUtils.color_blue_main,
                      ),
                      onPressed: () {
                        setState(() {
                          pwdShow = !pwdShow;
                        });
                      },
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorUtils.color_grey_666),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  obscureText: !pwdShow,
                  //校验密码（不能为空）
                  validator: (v) {
                    return v
                        .trim()
                        .isNotEmpty ? null : '密码不能为空';
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.expand(height: 55.0),
                    child: ElevatedButton(
                      onPressed: _onRegister,
                      child: Text('创建并登录',style: TextStyle(fontSize: 18),),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            )
                        ),
                        backgroundColor:
                        MaterialStateProperty.all(ColorUtils.color_blue_main),
                        foregroundColor:
                        MaterialStateProperty.all(ColorUtils.color_white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onRegister() async {
    // 提交前，先验证各个表单字段是否合法
    if ((_formKey.currentState as FormState).validate()) {
      // UserBeanResult user;
      CommonBody result;
      String ticket = base64Encode(utf8.encode(APP_KEY + '.' + APP_SECRET));
      //print(ticket);
      Map<String, String> headers = {"DOMAIN": DOMAIN, "ticket": ticket};
      var response = await Dio().post("http://121.43.164.122:3391/user/register",
          options: Options(headers: headers),
          queryParameters: {
            "account": _unameController.text,
            "password": _pwdController.text
          });
      Global.user.account = _unameController.text;
      Global.user.password = _pwdController.text;
      result = CommonBody.fromJson(response.data);
      print(result.message);
      switch (result.errorCode) {
        case 0:
          Toast.show('注册成功', context);
          Global.isLogin = true;
          Global.user.account = _unameController.text;
          Global.user.password = _pwdController.text;
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => new MyApp()
              ), (route) => route == null);
          break;
        case 40002:
          Toast.show('该用户不存在', context);
          throw TodoDioError(error: "该用户不存在");
        case 40003:
          Toast.show('用户名或密码错误', context);
          throw TodoDioError(error: "用户名或密码错误");
        case 40004:
          Toast.show('用户名已存在', context);
          throw TodoDioError(error: "用户名已存在");
      }
    }
  }
}
