import 'package:todo_flutter/bean/note_bean_entity.dart';

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