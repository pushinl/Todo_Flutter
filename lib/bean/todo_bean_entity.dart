import 'package:todo_flutter/generated/json/base/json_convert_content.dart';
import 'package:todo_flutter/generated/json/base/json_field.dart';

class TodoBeanEntity with JsonConvert<TodoBeanEntity> {
	@JSONField(name: "todo_id")
	int todoId;
	String content;
	@JSONField(name: "item_datetime")
	String itemDatetime;
	@JSONField(name: "item_importance")
	int itemImportance;
	@JSONField(name: "item_type_ddl_or_repeat")
	int itemTypeDdlOrRepeat;
	@JSONField(name: "item_type_person_or_team")
	int itemTypePersonOrTeam;
	@JSONField(name: "item_status")
	int itemStatus;
	@JSONField(name: "item_labels")
	int itemLabels;
}
