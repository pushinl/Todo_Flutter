import 'package:flutter/material.dart';
import 'dart:math';

class ColorUtils{
  static const Color color_grey_dd = Color(0xFFEAEAEA);
  static const Color color_grey_999 = Color(0xff999999);
  static const Color color_grey_666 = Color(0xFF6C6C6C);
  static const Color color_black = Color(0xff000000);
  static const Color color_white = Color(0xffffffff);
  static const Color color_godden_dark = Color(0xffb68d45);
  static const Color color_orange_main = Color(0xffFF791B);
  static const Color color_blue_main = Color(0xFF536DFE);
  static const Color color_background_main = Color(0xFFF4F4F4);
  static const Color color_delete = Color(0xFFD9534F);
  static const Color color_text = Color(0xFF2A2A2A);
}

Color getColor(int type) {
  switch(type){
    case 1 : return Colors.blue;
    case 2 : return Colors.blueGrey;
    case 3 : return Colors.amber;
    case 4 : return Colors.green;
  }
  return Colors.black;
}