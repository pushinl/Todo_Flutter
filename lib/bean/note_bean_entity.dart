import 'package:todo_flutter/generated/json/base/json_convert_content.dart';
import 'package:todo_flutter/generated/json/base/json_field.dart';

class NoteBeanEntity with JsonConvert<NoteBeanEntity> {
  @JSONField(name: "note_id")
  int noteId;
  String title;
  String content;
  @JSONField(name: "add_time")
  String addTime;
  @JSONField(name: "update_time")
  String updateTime;
  @JSONField(name: "note_code")
  String noteCode;
}
