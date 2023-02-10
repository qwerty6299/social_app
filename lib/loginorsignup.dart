import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/login.dart';
import 'package:socialapp/signup.dart';
import 'package:socialapp/skip3.dart';

import 'Providers_google/loginsignin.dart';
import 'chatfirebase/models/UserModel.dart';
import 'model/user_model.dart';

class LoginOrSignup extends StatefulWidget {

  LoginOrSignup({Key? key
   }) : super(key: key);

  @override
  State<LoginOrSignup> createState() => _LoginOrSignupState();
}

class _LoginOrSignupState extends State<LoginOrSignup> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff161730),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 180),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'asset/images/smalllogo.png',
                      height: 120,
                      width: 150,
                      fit: BoxFit.fill,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 180,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                              create: (_) => new Googlesigninn(),
                              child: Signup(
                                 ))));
                    },
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
                            'Create an account',
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
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login(

                               )));
                      },
                      child: new Container(
                        width: size.width / 2,
                        margin: EdgeInsets.only(left: 10, right: 10),
                        height: 55,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage('asset/images/bluebutton.png'),
                                fit: BoxFit.fill)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Login',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
