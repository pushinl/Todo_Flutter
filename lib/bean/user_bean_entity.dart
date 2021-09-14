import 'package:todo_flutter/generated/json/base/json_convert_content.dart';

class UserBeanEntity with JsonConvert<UserBeanEntity> {
	String message;
	UserBeanResult result;
	int code;
}

class UserBeanResult with JsonConvert<UserBeanResult> {
	String userNumber;
	String nickname;
	String telephone;
	String email;
	String token;
	String role;
	String realname;
	String gender;
	String department;
	String major;
	String stuType;
	String avatar;
	String campus;
	String idNumber;
}
