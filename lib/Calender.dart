import 'package:flutter/material.dart';
import 'package:r_calendar/r_calendar.dart';


class CalenderPage extends StatefulWidget {
  @override
  _CalenderPageState createState() => _CalenderPageState();
}
class _CalenderPageState extends State<CalenderPage> {
  RCalendarController controller;

  @override
  void initState() {
    super.initState();
    controller = RCalendarController.multiple(selectedDates: [


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

      body: Calendershow()
    );
  }
  Widget Calendershow(){
    return RCalendarWidget(
      controller: controller,
      customWidget: DefaultRCalendarCustomWidget(),
      firstDate: DateTime(1970, 1, 1), //当前日历的最小日期
      lastDate: DateTime(2055, 12, 31),
    );
  }

}
