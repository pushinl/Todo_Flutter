import 'package:todo_flutter/bean/todo_bean_entity.dart';

todoBeanEntityFromJson(TodoBeanEntity data, Map<String, dynamic> json) {
	if (json['todo_id'] != null) {
		data.todoId = json['todo_id'] is String
				? int.tryParse(json['todo_id'])
				: json['todo_id'].toInt();
	}
	if (json['content'] != null) {
		data.content = json['content'].toString();
	}
	if (json['item_datetime'] != null) {
		data.itemDatetime = json['item_datetime'].toString();
	}
	if (json['item_importance'] != null) {
		data.itemImportance = json['item_importance'] is String
				? int.tryParse(json['item_importance'])
				: json['item_importance'].toInt();
	}
	if (json['item_status'] != null) {
		data.itemStatus = json['item_status'] is String
				? int.tryParse(json['item_status'])
				: json['item_status'].toInt();
	}
	if (json['item_labels'] != null) {
		data.itemLabels = json['item_labels'] is String
				? int.tryParse(json['item_labels'])
				: json['item_labels'].toInt();
	}
	return data;
}

Map<String, dynamic> todoBeanEntityToJson(TodoBeanEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['todo_id'] = entity.todoId;
	data['content'] = entity.content;
	data['item_datetime'] = entity.itemDatetime;
	data['item_importance'] = entity.itemImportance;
	data['item_status'] = entity.itemStatus;
	data['item_labels'] = entity.itemLabels;
	return data;
}