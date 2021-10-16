import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:todo_flutter/bean/user_bean_entity.dart';
import 'package:todo_flutter/pages/color_utils.dart';
import 'package:todo_flutter/service/service.dart';

import '../../main.dart';
import '../constants.dart';

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
    // var gm = GmLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('注册'),
        elevation: 0,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Image.asset('assets/twt_assets/twt.png', height: 200,),
              Text(
                '注册搞咩账号',
                style: TextStyle(
                    fontSize: 22,
                    color: ColorUtils.color_text
                ),
              ),
              SizedBox(
                height: 8,
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
                padding: const EdgeInsets.only(top: 25),
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(height: 55.0),
                  child: ElevatedButton(
                    onPressed: _onRegister,
                    child: Text('注册'),
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
      var response = await Dio().post("http://121.43.164.122:3389/user/register",
          options: Options(headers: headers),
          queryParameters: {
            "account": _unameController.text,
            "password": _pwdController.text
          });
      Global.user.account = _unameController.text;
      Global.user.password = _pwdController.text;
      result = CommonBody.fromJson(response.data);
      print(result.message);
      if (result.errorCode == 0) {
        Toast.show('注册成功', context);
        Global.isLogin = true;
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (context) => new MyApp()
            ), (route) => route == null);
      } else {
        Toast.show('发生了一些错误~', context);
      }
      // if ( _unameController.text == 'a'&& _pwdController.text == 'a') {
      //   Global.isLogin = true;
      //   Global.user = new UserBeanResult();
      //   Global.user.realname = 'a';
      //   Global.user.userNumber = '123';
      //   Toast.show('成功', context);
      //   Navigator.of(context).pushAndRemoveUntil(
      //       new MaterialPageRoute(builder: (context) => new MyApp()
      //       ), (route) => route == null);
      // } else {
      //   Toast.show('错误', context);
      // }
    }
  }
}
