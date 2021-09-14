import 'package:flutter/material.dart';
import 'package:r_calendar/r_calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_flutter/bean/todo_bean_entity.dart';
import 'package:todo_flutter/pages/Color.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:todo_flutter/pages/Constants.dart';
import 'package:todo_flutter/pages/todopage/sqlite/TodoSqliteHelper.dart';
import 'package:toast/toast.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  var width, height;
  TodoBeanEntity arguments;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  TodoSqliteHelper todoSqliteHelper;
  List<TodoBeanEntity> todoList = <TodoBeanEntity>[];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    todoSqliteHelper = new TodoSqliteHelper();
    arguments = new TodoBeanEntity();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: ColorUtils.color_background_main),
      child: Column(
        children: <Widget>[
          TableCalendar(
            locale: 'zh_CN',
            focusedDay: _focusedDay,
            firstDay: DateTime(2021),
            lastDay: DateTime(2100),
            calendarStyle: CalendarStyle(
              selectedDecoration: const BoxDecoration(
                color: ColorUtils.color_blue_main,
                shape: BoxShape.circle,
              ),
            ),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  getEventsForDay(selectedDay);
                });
              }
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                color: ColorUtils.color_text,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                fontSize: 13,
                color: const Color(0xFF4F4F4F),
              ),
              weekendStyle: TextStyle(
                fontSize: 13,
                color: const Color(0xFF6A6A6A),
              )
            ),
          ),

          todoList.length > 0 ? Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              separatorBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Divider(
                    color: ColorUtils.color_grey_dd,
                    height: 10,
                  ),
                );
              },
              itemCount: todoList.length,
              itemBuilder: getItemBuilder,
            ),
          ) : Padding(
            padding: EdgeInsets.fromLTRB(0,height*0.15,0,0),
            child: Text('这天没有待办哦~', style: TextStyle(fontSize: 16, color: ColorUtils.color_grey_666),),
          )
        ],
      ),
    );
  }

  Future getEventsForDay(DateTime day) async {
    await todoSqliteHelper.open();
    List<TodoBeanEntity> list;
    list = await todoSqliteHelper.getTodoFromDate(day);
    setState(() {
      todoList.clear();
      todoList.addAll(list);
      // print(list);
    });
    await todoSqliteHelper.close();
  }

  Widget getItemBuilder(context, index) {
    var e = todoList[index];
    int importance = e.itemImportance;
    return getDismissible(context, e, importance);
  }

  Dismissible getDismissible(context, TodoBeanEntity e, int importance) {
    return e.itemStatus == 0
        ? Dismissible(
        onDismissed: (_) {
          deleteById(e.todoId);
          todoList.remove(e);
          getAllTodo();
        },
        key: Key(e.todoId.toString()),
        background: Container(color: ColorUtils.color_delete),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ElevatedButton(
            // minVerticalPadding: 0,
            onPressed: () {
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: Container(
              height: height * 0.08,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      arguments = e;
                      arguments.itemStatus = 1;
                      setTodoStatus();
                      getAllTodo();
                    },
                    child: getImage(e.itemImportance),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: width * 0.7,
                    child: Text("${e.content}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: ColorUtils.color_text)),
                  )
                ],
              ),
            ),
          ),
        ))
        : Dismissible(
        onDismissed: (_) {
          deleteById(e.todoId);
          todoList.remove(e);
          getAllTodo();
        },
        key: Key(e.todoId.toString()),
        background: Container(color: ColorUtils.color_delete),
        child: Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Container(
              width: width - 40,
              child: ElevatedButton(
                // minVerticalPadding: 0,
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                child: Container(
                  height: height*0.08,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          arguments = e;
                          arguments.itemStatus = 0;
                          setTodoStatus();
                          getAllTodo();
                        },
                        child: Image(
                          image: AssetImage("assets/circle/finished.png"),
                          width: 20,
                          height: 20,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: width * 0.7,
                        child: Text(
                          "${e.content}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.lineThrough,
                            color: ColorUtils.color_delete_text,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Image getImage(int image) {
    return Image.asset(
      'assets/circle/Todo_$image.png',
      width: 20,
      height: 20,
    );
  }

  void exit(BuildContext context) {
    Navigator.of(context).pop(Constants.REFRESH);
  }

  void getAllTodo() async {
    await todoSqliteHelper.open();
    List<TodoBeanEntity> list;
    list = await todoSqliteHelper.getTodoFromDate(_selectedDay);
    setState(() {
      todoList.clear();
      todoList.addAll(list);
    });
    await todoSqliteHelper.close();
  }

  void setTodoStatus() async {
    await todoSqliteHelper.open();
    await todoSqliteHelper.update(arguments);
    await todoSqliteHelper.close();
  }

  void deleteById(int id) async {
    await todoSqliteHelper.open();
    await todoSqliteHelper.delete(id).then((value) {
      if (value > 0) Toast.show("删除成功", context);
    });
    await todoSqliteHelper.close();
  }

}
