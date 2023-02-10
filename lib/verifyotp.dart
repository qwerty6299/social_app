import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/model/verifyotpmodel.dart';
import 'package:socialapp/signup.dart';
import 'package:socialapp/enterdetails.dart';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';

import 'Utils/showsnackbar.dart';
import 'chatfirebase/models/UserModel.dart';
import 'model/signupmodel.dart';
import 'model/user_model.dart';


class VerifyOtp extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  VerifyOtp({required this.mobile, Key? key,required this.userModel, required this.firebaseUser}) : super(key: key);

  final String mobile;
  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  TextEditingController otp = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff161730),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 54,
                width: size.width,
                child: Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 10),
                          child: Column(
                            children: [
                              Icon(
                                Icons.arrow_back_ios_rounded,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'asset/images/smalllogo.png',
                    height: 100,
                    width: 150,
                    fit: BoxFit.fill,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 58, left: 30),
                child: Row(
                  children: [
                    Text(
                      'Verify OTP',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 45),
                child: Container(
                  height: 51,

                  // width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff4F4F4F)),
                      borderRadius: BorderRadius.circular(28)),
                  child: TextFormField(
                    controller: otp,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,

                      // contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      contentPadding: EdgeInsets.only(top: 10, left: 12),

                      hintText: 'Enter OTP',
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff4F4F4F)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 17.45, left: 30, right: 35),
                child: Row(
                  children: [
                    Text(
                      "Haven't recive an otp?",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70),
                    ),
                    SizedBox(
                      width: size.width / 3,
                    ),
                    Text(
                      'Resend',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ).onTap(() {
                      resendOtp(email: widget.mobile);
                    }),
                  ],
                ),
              ),
              SizedBox(
                height: 62.19,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async{
        final result=await Connectivity().checkConnectivity();
        if(result==ConnectivityResult.wifi||result==ConnectivityResult.mobile) {
          if (otp.text
              .toString()
              .isEmpty) {
            Fluttertoast.showToast(
                msg: "Please Enter OTP",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            signUpNow(otp.text.toString()).then((value) async {
              print(value.sTATUS);
              if (value.sTATUS == "SUCCESS") {
                Fluttertoast.showToast(
                    msg: value.mESSAGE!,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EnterDetails(userModel: widget.userModel, firebaseUser:widget.firebaseUser)));
              } else {
                print(1);
                print(value.sTATUS);

                Fluttertoast.showToast(
                    msg: value.mESSAGE!,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            });
          }
        }else{
          showconnectivitysnackbar(context, result);
        }
                    },

                    // onTap: () {
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => EnterDetails()));
                    // },
                    child: new Container(
                      width: size.width / 2,
                      margin: EdgeInsets.only(left: 10, right: 10),
                      height: 55,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('asset/images/redbutton.png'),
                              fit: BoxFit.fill)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Verify',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<VerifyOtpModel> signUpNow(String otp) async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    var headers = {
      'Content-Type': 'application/json',
      'Cookie':
          'connect.sid=s%3A95Ql9qpNjq74kS6dJxTK9TsNVBdFBmNU.oXnfXLYo828yQQRZLueQlWdOpCUyqS6AVQk71tr2SPU'
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('USER_ID') ?? '';
    print(name);
    var request = http.Request('POST',
        Uri.parse('http://3.227.35.5:3001/api/user/appotpVerification'));
    request.body = json.encode(
        {"APP_KEY": "SpTka6TdghfvhdwrTsXl28P1", "OTP": otp, "ID": name});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var data = jsonDecode(await response.stream.bytesToString());
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!hjk");
      print(response.reasonPhrase);
      print(data);
      return VerifyOtpModel.fromJson(data);
    } else {
      Navigator.of(context).pop();
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      print(response.reasonPhrase);
      return VerifyOtpModel.fromJson(data);
    }
  }
  void showconnectivitysnackbar(BuildContext context,
      ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;
    final message = hasInternet ? "connection restored" :
    "No internet connection";
    final color = hasInternet ? Colors.green : Colors.red;
    Utils.showsnackbar(context, message, color);
  }
  Future<SignUpModel> resendOtp({required String email}) async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    var headers = {
      'Content-Type': 'application/json',
      'Cookie':
          'connect.sid=s%3AsF7mSBl-RSfKIzGREUEEqXcMhhaEZYpw.pOOhVQkm3lsnGYBZZ6f8YCy1A5PVa%2FQu17YYhF52sRo'
    };
    var request = http.Request(
        'POST', Uri.parse('http://3.227.35.5:3001/api/user/signUp'));
    request.body =
        json.encode({"APP_KEY": "SpTka6TdghfvhdwrTsXl28P1", "MOBILE": email});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var data = jsonDecode(await response.stream.bytesToString());
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      print("!!!!!!!!!!!!!--OTP Sent--!!!!!!!!!!!!!!!!!");
      print(response.reasonPhrase);
      print(data);
      return SignUpModel.fromJson(data);
    } else {
      Navigator.of(context).pop();
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      print(response.reasonPhrase);
      return SignUpModel.fromJson(data);
    }
  }
}
