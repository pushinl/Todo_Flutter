import 'package:todo_flutter/bean/user_bean_entity.dart';

userBeanEntityFromJson(UserBeanEntity data, Map<String, dynamic> json) {
	if (json['message'] != null) {
		data.message = json['message'].toString();
	}
	if (json['result'] != null) {
		data.result = UserBeanResult().fromJson(json['result']);
	}
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	return data;
}

Map<String, dynamic> userBeanEntityToJson(UserBeanEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['message'] = entity.message;
	data['result'] = entity.result?.toJson();
	data['code'] = entity.code;
	return data;
}

userBeanResultFromJson(UserBeanResult data, Map<String, dynamic> json) {
	if (json['userNumber'] != null) {
		data.userNumber = json['userNumber'].toString();
	}
	if (json['nickname'] != null) {
		data.nickname = json['nickname'].toString();
	}
	if (json['telephone'] != null) {
		data.telephone = json['telephone'].toString();
	}
	if (json['email'] != null) {
		data.email = json['email'].toString();
	}
	if (json['token'] != null) {
		data.token = json['token'].toString();
	}
	if (json['role'] != null) {
		data.role = json['role'].toString();
	}
	if (json['realname'] != null) {
		data.realname = json['realname'].toString();
	}
	if (json['gender'] != null) {
		data.gender = json['gender'].toString();
	}
	if (json['department'] != null) {
		data.department = json['department'].toString();
	}
	if (json['major'] != null) {
		data.major = json['major'].toString();
	}
	if (json['stuType'] != null) {
		data.stuType = json['stuType'].toString();
	}
	if (json['avatar'] != null) {
		data.avatar = json['avatar'].toString();
	}
	if (json['campus'] != null) {
		data.campus = json['campus'].toString();
	}
	if (json['idNumber'] != null) {
		data.idNumber = json['idNumber'].toString();
	}
	return data;
}

Map<String, dynamic> userBeanResultToJson(UserBeanResult entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['userNumber'] = entity.userNumber;
	data['nickname'] = entity.nickname;
	data['telephone'] = entity.telephone;
	data['email'] = entity.email;
	data['token'] = entity.token;
	data['role'] = entity.role;
	data['realname'] = entity.realname;
	data['gender'] = entity.gender;
	data['department'] = entity.department;
	data['major'] = entity.major;
	data['stuType'] = entity.stuType;
	data['avatar'] = entity.avatar;
	data['campus'] = entity.campus;
	data['idNumber'] = entity.idNumber;
	return data;
}