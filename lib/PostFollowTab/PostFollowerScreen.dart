import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../chatfirebase/models/UserModel.dart';
import 'PostFollowerTabScreen.dart';
import 'PostFollowingTabScreen.dart';

class PostFollowerscreen extends StatefulWidget {
  int selectedpage;
  final UserModel userModel;
  final User firebaseUser;
   PostFollowerscreen({Key? key, required this.selectedpage,required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  State<PostFollowerscreen> createState() => _PostFollowerscreenState();
}

class _PostFollowerscreenState extends State<PostFollowerscreen> {
  String names="";

  @override
  void initState() {
    super.initState();
    getfetchresponse();
  }

  void getfetchresponse() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString("fetchname").toString();
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
            backgroundColor:  Theme.of(context).scaffoldBackgroundColor,
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
              PostFollowerTabScreen(userModel: widget.userModel, firebaseUser: widget.firebaseUser,),
              PostFollowingTabScreen(userModel: widget.userModel, firebaseUser: widget.firebaseUser,),
            ],
          ),
        ));
  }
}
