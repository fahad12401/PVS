LoginResponse loginresponse = LoginResponse();
UpdateApplication update = UpdateApplication();

class LoginResponse {
  String? message;
  User? user;
  LoginResponse({this.message, this.user});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? userName;
  String? passwordHash;
  int? branchId;
  String? firstName;
  String? lastName;
  String? code;
  User(
      {this.id,
      this.userName,
      this.passwordHash,
      this.branchId,
      this.firstName,
      this.lastName,
      this.code});

  User.fromJson(
    Map<String, dynamic> json,
  ) {
    id = json['Id'];
    userName = json['UserName'];
    passwordHash = json['PasswordHash'];
    branchId = json['BranchId'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['UserName'] = this.userName;
    data['PasswordHash'] = this.passwordHash;
    data['BranchId'] = this.branchId;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['code'] = this.code;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'UserName': userName,
      'PasswordHash': passwordHash,
      'BranchId': branchId,
      'FirstName': firstName,
      'LastName': lastName,
      'code': code,
    };
  }
}

class UpdateApplication {
  String? URL;
  int? appVersion;
  String? userId;
  String? message;
  UpdateApplication({this.URL, this.appVersion, this.message, this.userId});
  UpdateApplication.fromJson(Map<String, dynamic> json) {
    URL = json['URL'];
    appVersion = json['appVersion'];
    userId = json['userId'];
    message = json['message'];
  }
}
