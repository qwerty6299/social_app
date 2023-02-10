class EnterDetailsModel {
  int? code;
  String? sTATUS;
  String? mESSAGE;
  DATA? dATA;

  EnterDetailsModel({this.code, this.sTATUS, this.mESSAGE, this.dATA});

  EnterDetailsModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sTATUS = json['STATUS'];
    mESSAGE = json['MESSAGE'];
    dATA = json['DATA'] != null ? new DATA.fromJson(json['DATA']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['STATUS'] = this.sTATUS;
    data['MESSAGE'] = this.mESSAGE;
    if (this.dATA != null) {
      data['DATA'] = this.dATA!.toJson();
    }
    return data;
  }
}

class DATA {
  String? iD;
  String? uSERNAME;
  String? fIRSTNAME;
  String? lASTNAME;
  int? pHONE;

  DATA({this.iD, this.uSERNAME, this.fIRSTNAME, this.lASTNAME, this.pHONE});

  DATA.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    uSERNAME = json['USERNAME'];
    fIRSTNAME = json['FIRST_NAME'];
    lASTNAME = json['LAST_NAME'];
    pHONE = json['PHONE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['USERNAME'] = this.uSERNAME;
    data['FIRST_NAME'] = this.fIRSTNAME;
    data['LAST_NAME'] = this.lASTNAME;
    data['PHONE'] = this.pHONE;
    return data;
  }
}