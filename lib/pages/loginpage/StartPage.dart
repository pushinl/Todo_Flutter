import 'package:flutter/material.dart';
import 'package:todo_flutter/pages/Color.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(30, 50, 0, 0),
            child: Text("Hello,\n搞咩",
                style: TextStyle(
                    color: Color.fromRGBO(98, 103, 124, 1),
                    fontSize: 50,
                    fontWeight: FontWeight.w300)),
          ),
          Expanded(child: Text(""), flex: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 100,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context,'/Login'),
                  child: Text('登录',
                      style: TextStyle(
                          color: ColorUtils.color_text, fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                ),
              ),
              Container(
                height: 50,
                width: 100,
                margin: const EdgeInsets.only(left: 50),
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/Login'),
                  child: Text('注册',
                      style: TextStyle(
                          color: ColorUtils.color_text, fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                ),
              ),
            ],
          ),
          // Padding(
          //   padding: EdgeInsets.only(top: 30),
          //   child: Text('text1',
          //       textAlign: TextAlign.center,
          //       style: TextStyle(
          //           fontSize: 11, color: Color.fromRGBO(98, 103, 124, 1))),
          // ),
          Expanded(child: Text(""), flex: 2)
        ],
      ),
    );
  }
}