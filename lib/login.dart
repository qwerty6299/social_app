  import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/aaaaaaaa/bottom_navigation_page.dart';
import 'package:socialapp/forgetpassword.dart';
import 'package:socialapp/homepage.dart';
import 'package:socialapp/loginorsignup.dart';
import 'package:socialapp/model/loginmodel.dart';
import 'package:socialapp/signup.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'Utils/showsnackbar.dart';
import 'chatfirebase/models/UserModel.dart';
import 'model/user_model.dart';

class Login extends StatefulWidget {

  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController passwordd = TextEditingController();
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
                      'Login',
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
                padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
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

                      hintText: ' Email',

                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff4F4F4F)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20.82, top: 30),
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
                padding: const EdgeInsets.only(top: 13.45, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgetPassword(

                                   )));
                      },
                      child: Text(
                        'Forget password?',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 24.38,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'or login with',
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
                    width: 25,
                  ),
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('asset/images/google.png'),
                            fit: BoxFit.cover)),
                  ),
                  SizedBox(
                    width: 25,
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
                height: 35.92,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async{
    final result=await Connectivity().checkConnectivity();
    if(result==ConnectivityResult.wifi||result==ConnectivityResult.mobile) {
      if (email.text
          .toString()
          .isEmpty) {
        Fluttertoast.showToast(
            msg: "Please enter Email Id",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (passwordd.text
          .toString()
          .isEmpty) {
        Fluttertoast.showToast(
            msg: "Please enter Password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        uploadData(email.text.toString(),
            passwordd.text.toString())
            .then((value) async {
          if (value.sTATUS == "SUCCESS") {

            final prefs = await SharedPreferences
                .getInstance(); // Obtain shared preferences.
            await prefs.setString(
                'USER_ID', value.data!.sId.toString());

            Fluttertoast.showToast(
                msg: value.mESSAGE!,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
            email.text.toString()=="";
            passwordd.text.toString()=="";
            fff(email.text.toString(),
                passwordd.text.toString());

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
    }else{
      showconnectivitysnackbar(context, result);
    }
                    },
                    // onTap: () {
                    //   Navigator.push(context,
                    //       MaterialPageRoute(builder: (context) => Login()));
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
                            'Log In',
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
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Signup()));
                    },
                    child: Text(
                      'SignUp',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  )
                ],
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
  Future<LoginModel> uploadData(String email, String password) async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie':
          'connect.sid=s%3AtVnLmITSn_zletRj2nMA2yCjWafW69aY.vufwo%2Fh45zhYEp06x9RKcV0mhk2DkYDZ1twbPiJRp5Y'
    };
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    var request = http.Request(
        'POST', Uri.parse('http://3.227.35.5:3001/api/user/login'));
    request.body = json.encode({
      "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
      "MOBILE": email,
      "PASSWORD": password
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!hjk");
      return LoginModel.fromJson(
          jsonDecode(await response.stream.bytesToString()));
    } else {
      Navigator.of(context).pop();
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      print(response.reasonPhrase);
      return LoginModel.fromJson(
          jsonDecode(await response.stream.bytesToString()));
    }
  }
  void fff(String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential != null) {
        String uid = credential.user!.uid;

        DocumentSnapshot userData =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
        UserModel userModel =
        UserModel.fromMap(userData.data() as Map<String, dynamic>);
        print("Log In Successful! firebase");
        print("login UID ${userModel.uid}");
        print("login UID ${userModel.email}");
        print("login UID ${userModel.fullname}");
        print("login UID ${userModel.profilepic}");
        setname("${userModel.fullname}","${userModel.profilepic}", "${userModel.uid}","${userModel.email}");

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BottomNavigationPage(
                    userModel: userModel, firebaseUser: credential!.user!)));
      }
    } on FirebaseAuthException catch (ex) {
      print("exeption $ex");
    }


  }
  void setname(String loginname,String loginpic,String loginuid,String loginemail)async{
    final prefs=await SharedPreferences.getInstance();
    prefs.setString("loginname", loginname).toString();
    prefs.setString("loginpic", loginpic).toString();
   prefs.setString("loginuid", loginuid).toString();
   prefs.setString("loginemail", loginemail).toString();

  }
}
