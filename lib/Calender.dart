import 'package:flutter/material.dart';
import 'package:r_calendar/r_calendar.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  RCalendarController controller;

  @override
  void initState() {
    super.initState();
    controller = RCalendarController.multiple(selectedDates: [
      DateTime(2019, 12, 1),
      DateTime(2019, 12, 2),
      DateTime(2019, 12, 3),
    ]);
//    controller = RCalendarController.single(selectedDate: DateTime.now(),isAutoSelect: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RCalendarWidget(
        controller: controller,
        customWidget: DefaultRCalendarCustomWidget(),
        firstDate: DateTime(1970, 1, 1), //当前日历的最小日期
        lastDate: DateTime(2055, 12, 31),//当前日历的最大日期
      ),
    );
  }
}