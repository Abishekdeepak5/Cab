import 'dart:convert';


class Login {
  String username;
  String password;
  Login({required this.username, required this.password});


  Map<String, dynamic> toJson() {
    return {"userName": username, "password": password};
  }

  @override
  String toString() {
    return 'users{userName: $username, password: $password}';
  }
}

String UserToJson(Login data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

class UserDetail{
  String firstname;
  String lastname;
  String token;
  UserDetail({required this.firstname,required this.lastname,required this.token});
  
   factory UserDetail.fromJson(Map<String, dynamic> map) {
     return UserDetail(firstname: map["firstName"], lastname: map["lastName"],token:map["token"]);
   }
}

UserDetail TokenFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return UserDetail.fromJson(data);
}