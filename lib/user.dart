class userModel {
  int id;
  String userName;
  String email;
  String password;
  userModel({this.id, this.email, this.userName, this.password});

  userModel.fromMap(Map<dynamic, dynamic> data) {
    if (data == null) return;
    id = data['userId'];
    userName = data['userName'];
    email = data['email'];
    password = data['password'];
  }
  toMap() {
    return {
      'userId': id,
      'userName': userName,
      'email': userName,
      'password': password,
    };
  }
}
