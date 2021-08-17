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
	if (json['datatime'] != null) {
		data.datatime = (json['datatime'] as List).map((v) => v.toString()).toList().cast<String>();
	}
	if (json['item_importance'] != null) {
		data.itemImportance = json['item_importance'] is String
				? int.tryParse(json['item_importance'])
				: json['item_importance'].toInt();
	}
	if (json['item_type_ddl_or_repeat'] != null) {
		data.itemTypeDdlOrRepeat = json['item_type_ddl_or_repeat'] is String
				? int.tryParse(json['item_type_ddl_or_repeat'])
				: json['item_type_ddl_or_repeat'].toInt();
	}
	if (json['item_type_person_or_team'] != null) {
		data.itemTypePersonOrTeam = json['item_type_person_or_team'] is String
				? int.tryParse(json['item_type_person_or_team'])
				: json['item_type_person_or_team'].toInt();
	}
	if (json['item_status'] != null) {
		data.itemStatus = json['item_status'] is String
				? int.tryParse(json['item_status'])
				: json['item_status'].toInt();
	}
	if (json['item_labels'] != null) {
		data.itemLabels = (json['item_labels'] as List).map((v) => v.toString()).toList().cast<String>();
	}
	return data;
}

Map<String, dynamic> todoBeanEntityToJson(TodoBeanEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['todo_id'] = entity.todoId;
	data['content'] = entity.content;
	data['datatime'] = entity.datatime;
	data['item_importance'] = entity.itemImportance;
	data['item_type_ddl_or_repeat'] = entity.itemTypeDdlOrRepeat;
	data['item_type_person_or_team'] = entity.itemTypePersonOrTeam;
	data['item_status'] = entity.itemStatus;
	data['item_labels'] = entity.itemLabels;
	return data;
}