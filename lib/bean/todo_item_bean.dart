
class TodoItemBean {
  static const int ITEM_TYPE_REPEAT = 2;
  static const int ITEM_TYPE_ONE_DDL = 1;

  String content;
  DateTime dateTime;
  DateTime reminderTime;
  int itemType;//两种类型：单一ddl && 重复类型
  int itemStatus;//完成与否
  List<String> itemLabels;

  //TODO: itemType=ONE_DDL

  //TODO: itemType=REPEAT

}