import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/homepage.dart';
import 'package:socialapp/login.dart';
import 'package:socialapp/loginorsignup.dart';
import 'package:socialapp/model/signupmodel.dart';

import 'package:socialapp/verifyotp.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'Providers_google/loginsignin.dart';
import 'chatfirebase/models/UserModel.dart';

class Signup extends StatefulWidget {

  Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController email = TextEditingController();
  TextEditingController passwordd = TextEditingController();
  TextEditingController confirmpasswordd = TextEditingController();
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
                padding: const EdgeInsets.only(top: 45, left: 30),
                child: Row(
                  children: [
                    Text(
                      'Create an Account',
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
                padding: const EdgeInsets.only(left: 20, right: 20, top: 25),
                child: Container(
                  height: 51,

                  // width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff4F4F4F)),
                      borderRadius: BorderRadius.circular(28)),
                  child: TextFormField(
                    controller: email,
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

                      hintText: 'Phone or Email',
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff4F4F4F)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20.82, top: 25),
                child: Container(
                  height: 51,

                  // width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff4F4F4F)),
                      borderRadius: BorderRadius.circular(28)),
                  child: TextFormField(
                    obscureText: true,
                    controller: passwordd,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 10, left: 12),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff4F4F4F)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20.82, top: 25),
                child: Container(
                  height: 51,

                  // width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff4F4F4F)),
                      borderRadius: BorderRadius.circular(28)),
                  child: TextFormField(
                    obscureText: true,
                    controller: confirmpasswordd,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 10, left: 12),
                      hintText: 'Confirm Password',
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff4F4F4F)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'or signup with',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('asset/images/fb.png'),
                            fit: BoxFit.cover)),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context,AsyncSnapshot snapshot){
              if(snapshot.hasData){

                // return Waste(
                //     userModel: widget.userModel, firebaseUser: widget.firebaseUser);
              }
              else if(snapshot.hasError){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return     GestureDetector(
                onTap: (){
                  final provider = Provider.of<Googlesigninn>(
                      context, listen: false);
                  provider.googlelogin();
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('asset/images/google.png'),
                          fit: BoxFit.cover)),
                ),
              );


            }
                  ),

                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('asset/images/apple.png'),
                            fit: BoxFit.cover)),
                  ),
                ],
              ),
              SizedBox(
                height: 20.92,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (email.text.toString().isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Please Enter Email Id",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else if (passwordd.text.toString().isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Please Enter Password",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else if (confirmpasswordd.text.toString().isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Please Enter Confirm Password",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else if (confirmpasswordd.text.toString() !=
                          passwordd.text.toString()) {
                        Fluttertoast.showToast(
                            msg: "Password must be same",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else if (passwordd.text.length < 6) {
                        Fluttertoast.showToast(
                            msg: "Password should contain 6-20 characters",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else if (!passwordd.text.containsUppercase ||
                          !passwordd.text.containsLowercase ||
                          !passwordd.text.containsNumeric) {
                        Fluttertoast.showToast(
                            msg:
                                "Pssword should contain at least one numeric digit, one uppercase and one lowercase letter",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        signUpNow(email.text.toString(),
                                passwordd.text.toString())
                            .then((value) async {
                          print(value.sTATUS);
                          if (value.sTATUS == "SUCCESS") {
                            signUp(email.text.toString(),
                                passwordd.text.toString());
                            print(1);
                            print(value.dATA!.iD!);
                            final prefs = await SharedPreferences
                                .getInstance(); // Obtain shared preferences.
                            await prefs.setString('USER_ID', value.dATA!.iD!);
                            Fluttertoast.showToast(
                                msg: value.mESSAGE!,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);

                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => VerifyOtp(mobile: email.text,)));
                          } else if (value.sTATUS == "false") {
                            // Fluttertoast.showToast(msg: value.Er)

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

                            //  Navigator.push(
                            // context,
                            // MaterialPageRoute(
                            //     builder: (context) => VerifyOtp()));
                          }
                        });
                      }
                    },

                    // onTap: () {
                    //   Navigator.push(context,
                    //       MaterialPageRoute(builder: (context) => VerifyOtp()));
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
                            'Sign Up',
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
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You have an account?",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<SignUpModel> signUpNow(String email, String password) async {
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
    request.body = json.encode({
      "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
      "MOBILE": email,
      "PASSWORD": password,
      "SOCIAL_TYPE": "manual"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var data = jsonDecode(await response.stream.bytesToString());
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!hjk");
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

  void signUp(String email, String password) async {
    UserCredential? credential;

    //   UIHelper.showLoadingDialog(context, "Creating new account..");

    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(ex) {
    print(ex.code.toString());

      //  UIHelper.showAlertDialog(context, "An error occured", ex.message.toString());
    }

    if(credential != null) {
        String uid = credential.user!.uid;
        UserModel newUser = UserModel(
            uid: uid,
            email: email,
            fullname: "",
            profilepic: "",
          status: ""
        );
      await FirebaseFirestore.instance.collection("users").doc(uid).set(newUser.toMap()).then((value) {
        print("New User Created!");
        Navigator.popUntil(context, (route) => route.isFirst);
        print("sign up uid is ${uid}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) {
                return VerifyOtp(userModel: newUser, firebaseUser: credential!.user!, mobile: '9899787764',);
              }
          ),
        );
      });
    }

  }
 // Future<User> crteaccount(String name,String email,String profilepic,String password)async{
 //   FirebaseAuth _auth=FirebaseAuth.instance;
 //   try{
 //     User? user=(await _auth.createUserWithEmailAndPassword(email: email, password: password)).user;
 //   }catch(e){}
 // }
}

// class Waste extends StatefulWidget {
//
//
//    Waste({Key? key
//   }) : super(key: key);
//
//   @override
//   State<Waste> createState() => _WasteState();
// }
//
// class _WasteState extends State<Waste> {
//   SignUpModel? signupmodel;
//   Future settoken(token)async{
//     final prefs = await SharedPreferences
//         .getInstance(); // Obtain shared preferences.
//     await prefs.setString('USER_ID',token);
//   }
//   final user=FirebaseAuth.instance.currentUser;
//   void signupfirsttime()async{
//  var response= await http.post(Uri.parse("http://3.227.35.5:3001/api/user/signUp"),body: {
//    "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
//    "MOBILE": "vikram.b@winklix.com",
//    "PASSWORD": "123456Aa",
//    "SOCIAL_TYPE": "gmail"
//  });
//  signupmodel= SignUpModel.fromJson(json.decode(response.body));
//  String data=signupmodel!.dATA!.iD.toString();
//  print("the value of data is $data");
//
//  if(response.statusCode==200){
//    print(response.body);
// setState(() {
//   settoken(data);
//   Get.to(HomePage(userModel: widget.userModel, firebaseUser: widget.firebaseUser));
// });
//  }
//  else{
//    print("tfbdsbfjsdnf ${response.statusCode}");
//  }
//   }
//
//
//   @override
//   void initState() {
//     super.initState();
//     signupfirsttime();
//
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CircularProgressIndicator();
//   }
// }


extension StringValidators on String {
  bool get containsUppercase => contains(RegExp(r'[A-Z]'));
  bool get containsLowercase => contains(RegExp(r'[a-z]'));
  bool get containsNumeric => contains(RegExp(r'[0-9]'));
}
