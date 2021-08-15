import 'package:todo_flutter/bean/note_bean_entity.dart';
import 'package:todo_flutter/bean/todo_bean_entity.dart';

noteBeanEntityFromJson(NoteBeanEntity data, Map<String, dynamic> json) {
	if (json['note_id'] != null) {
		data.noteId = json['note_id'] is String
				? int.tryParse(json['note_id'])
				: json['note_id'].toInt();
	}
	if (json['title'] != null) {
		data.title = json['title'].toString();
	}
	if (json['content'] != null) {
		data.content = json['content'].toString();
	}
	if (json['add_time'] != null) {
		data.addTime = json['add_time'].toString();
	}
	if (json['update_time'] != null) {
		data.updateTime = json['update_time'].toString();
	}
	if (json['note_code'] != null) {
		data.noteCode = json['note_code'].toString();
	}
	return data;
}

todoBeanEntityFromJson(TodoBeanEntity data, Map<String, dynamic> json) {
	if (json['todo_id'] != null) {
		data.todoId = json['todo_id'] is String
				? int.tryParse(json['todo_id'])
				: json['todo_id'].toInt();
	}
	if(json['content'] !=null) {
		data.content = json['content'].toString();
	}
	//TODO: qwq
}

Map<String, dynamic> noteBeanEntityToJson(NoteBeanEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['note_id'] = entity.noteId;
	data['title'] = entity.title;
	data['content'] = entity.content;
	data['add_time'] = entity.addTime;
	data['update_time'] = entity.updateTime;
	data['note_code'] = entity.noteCode;
	return data;
}

Map<String, dynamic> todoBeanEntityToJson(TodoBeanEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['note_id'] = entity.todoId;
	data['content'] = entity.content;
	data['date_time'] = entity.dateTime;
	//TODO: entity
	return data;
}