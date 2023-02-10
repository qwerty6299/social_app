import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/homepage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:socialapp/postview.dart';
import 'package:socialapp/profile_tab/privateecoscreen.dart';
import 'package:socialapp/profile_tab/privatephotoscreen.dart';
import 'package:socialapp/profile_tab/publicecoscreen.dart';
import 'package:socialapp/profile_tab/publicphotoscreen.dart';
import 'package:socialapp/followerscreen.dart';
import 'package:socialapp/settingscreen.dart';
import 'package:http/http.dart' as http;

import 'EditScreen.dart';
import 'Utils/showsnackbar.dart';
import 'chatfirebase/models/UserModel.dart';
import 'model/profile_model.dart';
import 'model/user_model.dart';



class Profile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  Profile({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ProfileModel? profileModel;
  String name="";
  String postcount="";
  String followercount="";
  String followingcount="";
  String profilepic="";
  late TransformationController controller;
  @override
  void initState() {
    okkprofile();
    super.initState();
    controller=TransformationController();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();

  }
  void showconnectivitysnackbar(BuildContext context,
      ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;
    final message = hasInternet ? "connection restored" :
    "No internet connection";
    final color = hasInternet ? Colors.green : Colors.red;
    Utils.showsnackbar(context, message, color);
  }
  Future  okkprofile()async{
    final result=await Connectivity().checkConnectivity();
    if(result==ConnectivityResult.wifi||result==ConnectivityResult.mobile) {
      await getProfile();
    }else{
      showconnectivitysnackbar(context, result);
    }
  }
  Future setStringname() async{
   final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("name", name) ;
  }

  Future<http.Response> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("USER_ID").toString();
    print("private screen uid is $userId");


    var data={
      "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",

      "ID": "$userId"
    };

    // print("value of data is $body");
    var response=await http.post(Uri.parse("http://3.227.35.5:3001/api/user/fetch_profile"),body:data);


    if (response.statusCode == 200) {
      // print("the response is ${response.body}");
      setState((){
        profileModel=profileModelFromJson(response.body);

        name=profileModel!.data.name.toString();
        postcount=profileModel!.data.postsCount.toString();
        followercount=profileModel!.data.followerCount.toString();
        followingcount=profileModel!.data.followingCount.toString();
        profilepic=profileModel!.data.profilePic.toString();
      });


      return response;
    } else {
      throw Text('no result found');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      bottom: false,
      child: Scaffold(
        extendBody: true,
        backgroundColor: Theme.of(context).bottomAppBarColor,

        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 284,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color:Theme.of(context).errorColor),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0,right: 10,top: 15,bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                   ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(100)),
                                      child:profilepic==null?
                                          Image.asset('asset/images/dummyimage-removebg-preview.png',width: 60,height: 50,):




                                         GestureDetector(
                                           onTap: (){
                                             profilepic!=null?   Navigator.of(context).push(
                                                 MaterialPageRoute(
                                                   builder: (_) => IMage(
                                                     imageUrl: "$profilepic",
                                                   ),
                                                 )
                                             ): null;
                                           },
                                           child: CachedNetworkImage (imageUrl: "$profilepic",width: 60,height: 60,
                                              placeholder: (context, url) => new CircularProgressIndicator(),
                                              errorWidget: (context, url, error) => new Icon(Icons.person),),
                                         ),


                                    ),

                                ],
                              ),
                              SizedBox(
                                width: size.width / 30,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$name',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).disabledColor),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context).disabledColor),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context).disabledColor),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context).disabledColor),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.blue),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: size.width / 12,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.menu,
                                      color: Theme.of(context).disabledColor,
                                      size: 25,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 23, left: 26),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      '$postcount',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context).disabledColor),
                                    ),
                                    Text(
                                      'Post',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context).disabledColor),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: size.width / 6,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setStringname();
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => FollowerScreen( userModel: widget.userModel, firebaseUser: widget.firebaseUser,selectedpage: 0,)));
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        '$followercount',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context).disabledColor),
                                      ),
                                      Text(
                                        'Followers',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context).disabledColor),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: size.width / 6,
                                ),
                                GestureDetector(
                                  onTap: (){
                                    setStringname();
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => FollowerScreen(userModel: widget.userModel, firebaseUser: widget.firebaseUser, selectedpage: 1,)));
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        '$followingcount',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context).disabledColor),
                                      ),
                                      Text(
                                        'Following',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context).disabledColor),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditScreen(userModel: widget.userModel, firebaseUser: widget.firebaseUser),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 35,
                                  width: size.width / 2,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color(0xff262626)),
                                  child: Center(
                                    child: Text(
                                      'Edit profile',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white38),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: size.width / 12,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SettingScreen()));
                                },
                                child: Container(
                                  height: 35,
                                  width: size.width / 5,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color(0xff262626)),
                                  child: Center(
                                    child: Icon(
                                      Icons.settings,
                                      color: Colors.white38,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _tabSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabSection(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            // width: 2.w,
            child: TabBar(
                indicatorColor: Theme.of(context).disabledColor,
                isScrollable: true,
                labelStyle:
                    TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                labelColor: Theme.of(context).disabledColor,
                tabs: [
                  Tab(
                    text: "Private Eco",
                  ),
                  Tab(text: "Public Eco"),
                  Tab(text: "Private Photo"),
                  Tab(text: "Public Photo"),
                ]),
          ),
          Container(
            //Add this to give height
            height: MediaQuery.of(context).size.height,
            child: TabBarView(children: [
              PrivateEcoScreen(),
              PublicEcoScreen(),
              PrivatePhotoScreen(),
              PublicPhotoScreen(),
            ]),
          ),
        ],
      ),
    );
  }


}

class IMage extends StatelessWidget {
  final String imageUrl;
  const IMage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}

