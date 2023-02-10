class VerifyOtpModel {
  int? code;
  String? sTATUS;
  String? mESSAGE;

  VerifyOtpModel({this.code, this.sTATUS, this.mESSAGE});

  VerifyOtpModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sTATUS = json['STATUS'];
    mESSAGE = json['MESSAGE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['STATUS'] = this.sTATUS;
    data['MESSAGE'] = this.mESSAGE;
    return data;
  }
}