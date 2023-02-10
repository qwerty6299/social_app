import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/model/updatebiomodel.dart';
import 'package:socialapp/nearbypeople.dart';
import 'package:socialapp/uploadprofile.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'chatfirebase/models/UserModel.dart';


class EnterBio extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  EnterBio({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  State<EnterBio> createState() => _EnterBioState();
}

class _EnterBioState extends State<EnterBio> {
  String ttimg="";
  Future getphotoscreen()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
  String cc=  prefs.getString("mainpagepic").toString();
  setState(() {
    ttimg=cc;
  });
  print("the image is $ttimg");


  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getphotoscreen();
  }
  TextEditingController bio = TextEditingController();
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
                padding: const EdgeInsets.only(top: 40, left: 30),
                child: Row(
                  children: [
                    Text(
                      'Enter Bio',
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
                padding:  EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff4F4F4F)),
                      borderRadius: BorderRadius.circular(28)),
                  child: TextFormField(
                    controller: bio,
                    maxLines: 20,
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

                      hintText: 'Enter Bio',
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff4F4F4F)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(top: 108.16, left: 20),
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
                                image:AssetImage('asset/images/bluebutton.png'),
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
                      onTap: () {
                        if(bio.text.toString().isEmpty){
                           Fluttertoast.showToast(
                            msg: "Please Enter Bio",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        }
                        else{
                          uploadData(bio.text.toString()).then((value) async {
                          print(value.sTATUS);
                          if (value.sTATUS == "SUCCESS") {
                            Fluttertoast.showToast(
                                msg: value.mESSAGE!,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                  NearbyPeople(userModel: widget.userModel, firebaseUser: widget.firebaseUser)));
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
              )
            ],
          ),
        ),
      ),
    );
  }

    Future<UpdateBioModel> uploadData(String bio) async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('USER_ID') ?? '';
    String USERNAME = prefs.getString('USERNAME') ?? '';
    print(USERNAME);
   var headers = {
  'Content-Type': 'application/json',
  'Cookie': 'connect.sid=s%3AFPhX76679scJgzy8jQdikxfAZWVZMggs.hEQNqgT55WIv9G0pGQ3oZVF3fzFO29M9mAJ9sJRp%2FVY'
};
var request = http.Request('POST', Uri.parse('http://3.227.35.5:3001/api/user/updateBio'));
request.body = json.encode({
  "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
  "USERNAME": USERNAME,
  "ID": name,
  "BIO": bio
});
request.headers.addAll(headers);

http.StreamedResponse response = await request.send();
    var data = jsonDecode(await response.stream.bytesToString());
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!hjk");
      print(response.reasonPhrase);
      print(data);
      return UpdateBioModel.fromJson(data);
    } else {
      Navigator.of(context).pop();
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      print(response.reasonPhrase);
      return UpdateBioModel.fromJson(data);
    }
  }

}
