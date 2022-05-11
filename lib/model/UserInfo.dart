class UserInfo {
  String userAccount;
  String userEmail;
  String userName;
  String userPhone;
  String userPwd;

  UserInfo({
    required this.userAccount,
    required this.userEmail,
    required this.userName,
    required this.userPhone,
    required this.userPwd,
  });

  ToJson() {
    return {
      'userAccount': userAccount,
      'userEmail': userEmail,
      'userName': userName,
      'userPhone': userPhone,
      'userPwd': userPwd,
    };
  }

  UserInfo.fromJson(dynamic json)
      : userAccount = json['userAccount'],
        userName = json['userName'],
        userEmail = json['userEmail'],
        userPhone = json['userPhone'],
        userPwd = json['userPwd'];
}
