
import 'package:todo_flutter/generated/json/base/json_convert_content.dart';
import 'package:todo_flutter/generated/json/base/json_field.dart';

class TodoBeanEntity with JsonConvert<TodoBeanEntity> {

  @JSONField(name: "todo_id")
  int todoId;
  String content;
  @JSONField(name: "date_time")
  List<DateTime> dateTime;
  @JSONField(name: "item_importance")
  int itemImportance;//1 2 3数字越大越重要
  @JSONField(name: "item_type")
  int itemType;//两种类型：单一ddl && 重复类型
  @JSONField(name: "item_status")
  int itemStatus;//完成与否
  @JSONField(name: "item_labels")
  List<String> itemLabels;

}