class UserModel {
  String? uid;
  String? fullname;
  String? email;
  String? profilepic;
  String? status;

  UserModel({this.uid, this.fullname, this.email, this.profilepic,this.status});

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    fullname = map["fullname"];
    email = map["email"];
    profilepic = map["profilepic"];
    status = map["status"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullname": fullname,
      "email": email,
      "profilepic": profilepic,
      "status": status,
    };
  }
}