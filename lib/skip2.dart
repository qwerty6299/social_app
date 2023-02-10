import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/chatfirebase/models/UserModel.dart';
import 'package:socialapp/skip1.dart';
import 'package:socialapp/skip3.dart';

import 'model/user_model.dart';

class Skip2 extends StatefulWidget {

  Skip2({Key? key}) : super(key: key);

  @override
  State<Skip2> createState() => _Skip2State();
}

class _Skip2State extends State<Skip2> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff161730),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 20, right: 20),
          child: Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: size.width / 2.5,
                      margin: EdgeInsets.only(left: 10, right: 10),
                      height: 48,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('asset/images/bluebutton.png'),
                              fit: BoxFit.fill)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Skip',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Skip3(
                            )));
                    },
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
            ],
          )),
        ),
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
              SizedBox(
                height: 20.96,
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
                padding: const EdgeInsets.only(top: 80, bottom: 30,left: 30,right: 30),
                child: Container(
                  width: size.width,
                  child: Row(
                    children: [
                      Image.asset(
                        'asset/images/skip2.png',
                        height:250,
                        width: size.width-60,
                        fit: BoxFit.fill,
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to Gossip Echo',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                ],
              ),
              SizedBox(
                height: 13.84,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lorem ipsum dolor sir amet,consecteture ',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff969696)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'iusmod adipiscing elit, sed do ',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff969696)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
