import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/followtab/followertabscreen.dart';
import 'package:socialapp/followtab/followingtabscreen.dart';
import 'package:socialapp/profile.dart';

import 'chatfirebase/models/UserModel.dart';

class FollowerScreen extends StatefulWidget {
  int selectedpage;
  final UserModel userModel;
  final User firebaseUser;
  FollowerScreen({Key? key,required this.selectedpage
    ,required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  State<FollowerScreen> createState() => _FollowerScreenState();
}

class _FollowerScreenState extends State<FollowerScreen> {
  String names="";

  @override
  void initState() {
    super.initState();
    getstringname();
  }

  void getstringname() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString("name").toString();
    print("private screen uid is $name");
    setState(() {
      names=name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.selectedpage,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: BackButton(
              color: Theme.of(context).hoverColor ,
            ),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text('$names',style: TextStyle(
              color: Theme.of(context).hoverColor,
            ),),
            bottom: TabBar(
              indicatorColor: Theme.of(context).hoverColor ,
              labelColor:Theme.of(context).hoverColor ,

              tabs: [
                Tab(text: "followers"),
                Tab(text: "following"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              FollowerTabScreen(userModel: widget.userModel, firebaseUser: widget.firebaseUser,),
              FollowingTabScreen(userModel: widget.userModel, firebaseUser: widget.firebaseUser,),
            ],
          ),
        ));
  }
}
