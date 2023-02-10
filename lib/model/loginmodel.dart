class LoginModel {
  int? code;
  String? sTATUS;
  String? mESSAGE;
  Data? data;

  LoginModel({this.code, this.sTATUS, this.mESSAGE, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sTATUS = json['STATUS'];
    mESSAGE = json['MESSAGE'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['STATUS'] = this.sTATUS;
    data['MESSAGE'] = this.mESSAGE;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? username;
  String? email;
  String? firstName;
  String? lastName;
  String? profilePic;
  int? contactNumber;
  String? bio;
  String? socialId;
  int? otp;
  int? isVerifiedOtp;
  int? status;
  String? isFacebook;
  String? isApple;
  String? loginKey;
  String? password;
  String? socialType;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? token;

  Data(
      {this.sId,
      this.username,
      this.email,
      this.firstName,
      this.lastName,
      this.profilePic,
      this.contactNumber,
      this.bio,
      this.socialId,
      this.otp,
      this.isVerifiedOtp,
      this.status,
      this.isFacebook,
      this.isApple,
      this.loginKey,
      this.password,
      this.socialType,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.token});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profilePic = json['profile_pic'];
    contactNumber = json['contact_number'];
    bio = json['bio'];
    socialId = json['social_id'];
    otp = json['otp'];
    isVerifiedOtp = json['is_verified_otp'];
    status = json['status'];
    isFacebook = json['is_facebook'];
    isApple = json['is_apple'];
    loginKey = json['login_key'];
    password = json['password'];
    socialType = json['social_type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['profile_pic'] = this.profilePic;
    data['contact_number'] = this.contactNumber;
    data['bio'] = this.bio;
    data['social_id'] = this.socialId;
    data['otp'] = this.otp;
    data['is_verified_otp'] = this.isVerifiedOtp;
    data['status'] = this.status;
    data['is_facebook'] = this.isFacebook;
    data['is_apple'] = this.isApple;
    data['login_key'] = this.loginKey;
    data['password'] = this.password;
    data['social_type'] = this.socialType;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['token'] = this.token;
    return data;
  }
}