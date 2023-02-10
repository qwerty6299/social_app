import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/createpassword.dart';
import 'package:socialapp/model/enterdetailsmodel.dart';
import 'package:socialapp/uploadprofile.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'Utils/showsnackbar.dart';
import 'chatfirebase/models/UserModel.dart';
import 'model/user_model.dart';

class EnterDetails extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  EnterDetails({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  State<EnterDetails> createState() => _EnterDetailsState();
}

class _EnterDetailsState extends State<EnterDetails> {
  TextEditingController username = TextEditingController(); 
  TextEditingController firstname = TextEditingController(); 
TextEditingController lastname = TextEditingController(); 
TextEditingController mobilenumber = TextEditingController();

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
              Divider(
                height: 10,
                color: Color(0xff484848),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 38, left: 30),
                child: Row(
                  children: [
                    Text(
                      'Enter Details',
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
                padding: const EdgeInsets.only(left: 20, right: 20, top: 51),
                child: Container(
                  height: 51,

                  // width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff4F4F4F)),
                      borderRadius: BorderRadius.circular(28)),
                  child: TextFormField(
                    controller:username,
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

                      hintText: 'Enter Username(unique)',
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff4F4F4F)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20),
                child: Row(
                  children: [
                    Container(
                      height: 51,
                      width: size.width / 2.5,
                      // width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xff4F4F4F)),
                          borderRadius: BorderRadius.circular(28)),
                      child: TextFormField(
                        controller: firstname,
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

                          hintText: 'First Name',
                          hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff4F4F4F)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width / 12,
                    ),
                    Container(
                      height: 51,
                      width: size.width / 2.5,
                      // width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xff4F4F4F)),
                          borderRadius: BorderRadius.circular(28)),
                      child: TextFormField(
                        controller: lastname,
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

                          hintText: 'Last Name',
                          hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff4F4F4F)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Container(
                  height: 51,

                  // width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff4F4F4F)),
                      borderRadius: BorderRadius.circular(28)),
                  child: TextFormField(
                    controller: mobilenumber,
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

                      hintText: 'Mobile Number (optional)',
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff4F4F4F)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 108.16, left: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: new Container(
                        width: size.width / 2.5,
                        margin: EdgeInsets.only(left: 10, right: 10),
                        height: 48,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage('asset/images/bluebutton.png'),
                                fit: BoxFit.fill)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Skip',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(

                      onTap: () async{
    final result=await Connectivity().checkConnectivity();
    if(result==ConnectivityResult.wifi||result==ConnectivityResult.mobile) {
      if (username.text
          .toString()
          .isEmpty) {
        Fluttertoast.showToast(
            msg: "Please Enter User Name",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (firstname.text
          .toString()
          .isEmpty) {
        Fluttertoast.showToast(
            msg: "Please Enter First Name",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (lastname.text
          .toString()
          .isEmpty) {
        Fluttertoast.showToast(
            msg: "Please Enter Last Name",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        uploadData(username.text.toString(),
            firstname.text.toString(),
            lastname.text.toString())
            .then((value) async {
          print(value.sTATUS);
          if (value.sTATUS == "SUCCESS") {
            print(1);
            print(value.dATA!.iD!);
            final prefs = await SharedPreferences
                .getInstance(); // Obtain shared preferences.
            await prefs.setString('USER_ID', value.dATA!.iD!);
            await prefs.setString('USERNAME', "${value.dATA!.fIRSTNAME!} ${value.dATA!.lASTNAME!}" );
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
                    builder: (context) => UploadProfile(userModel: widget.userModel, firebaseUser: widget.firebaseUser)));
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
                      //           builder: (context) => UploadProfile()));
                      // },
                      child: new Container(
                        width: size.width / 2.5,
                        margin: EdgeInsets.only(left: 10, right: 10),
                        height: 48,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('asset/images/redbutton.png'),
                                fit: BoxFit.fill)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next',
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
              )
            ],
          ),
        ),
      ),
    );
  }
  void showconnectivitysnackbar(BuildContext context,
      ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;
    final message = hasInternet ? "connection restored" :
    "No internet connection";
    final color = hasInternet ? Colors.green : Colors.red;
    Utils.showsnackbar(context, message, color);
  }
  Future<EnterDetailsModel> uploadData(String username,String firstname,String lastname) async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('USER_ID') ?? '';
    print(name);
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('http://3.227.35.5:3001/api/user/signUpStep2'));
    request.body = json.encode({
      "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
      "USERNAME": username,
      "ID": name,
      "FIRST_NAME": firstname,
      "LAST_NAME": lastname
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var data = jsonDecode(await response.stream.bytesToString());
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!hjk");
      print(response.reasonPhrase);
      print(data);
      return EnterDetailsModel.fromJson(data);
    } else {
      Navigator.of(context).pop();
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      print(response.reasonPhrase);
      return EnterDetailsModel.fromJson(data);
    }
  }



}
