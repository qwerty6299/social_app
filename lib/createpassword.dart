import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/login.dart';
import 'package:socialapp/model/verifyotpmodel.dart';
import 'package:socialapp/otpverify2.dart';
import 'package:socialapp/enterdetails.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';




class CreatePassword extends StatefulWidget {

  CreatePassword({Key? key}) : super(key: key);

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  TextEditingController passworddd= TextEditingController();
   TextEditingController re_enterpassworddd= TextEditingController();
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
                      'Create Password',
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
                    controller: passworddd,
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

                      hintText: 'Enter Password',
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff4F4F4F)),
                    ),
                  ),
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
                    controller: re_enterpassworddd,
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

                      hintText: 'Enter New Password',
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff4F4F4F)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 77.64,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                       onTap: () {
                            if (passworddd.text.toString().isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please Enter Password",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } 
                            else if (re_enterpassworddd.text.toString().isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please Enter Re_Enter Password",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                            else if (passworddd.text.toString() !=
                                      re_enterpassworddd.text.toString()) {
                                    Fluttertoast.showToast(
                                        msg: "Password must be same",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                            else {
                              updatePassword(passworddd.text.toString())
                                  .then((value) async {
                                if (value.sTATUS == "SUCCESS") {
                                  Fluttertoast.showToast(
                                      msg: value.mESSAGE!,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  // Obtain shared preferences.

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                               Login()));
                                } else {
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
                            'Proceed',
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
   Future<VerifyOtpModel> updatePassword(String PASSWORD) async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
   var headers = {
  'Content-Type': 'application/json',
  'Cookie': 'connect.sid=s%3ACLO23Afl5SelmLoYv2_xQXYDxRt7FhuZ.p%2BkhIL57UgRSTiqUw1HB5jutrAIuIKunNBiyRBitfP4'
};
SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('USER_ID') ?? '';
    print(name);
var request = http.Request('POST', Uri.parse('http://3.227.35.5:3001/api/user/reset-password'));
request.body = json.encode({
  "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
  "PASSWORD": PASSWORD,
  "ID": name
});
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


}
