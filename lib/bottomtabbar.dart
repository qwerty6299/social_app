import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/chatscreen.dart';
// import 'package:socialapp/chatscreen.dart';
import 'package:socialapp/homepage.dart';
import 'package:socialapp/hometabscreen.dart';
import 'package:socialapp/profile.dart';
import 'package:socialapp/search_screen/treanding_search.dart';
import 'package:socialapp/settingscreen.dart';

import 'chatfirebase/models/ChatRoomModel.dart';
import 'chatfirebase/models/UserModel.dart';
import 'model/user_model.dart';

class BottomTabBar extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  final UserModel targetUser;
  final ChatRoomModel chatroom;
  BottomTabBar({Key? key,  required this.userModel,  required this.firebaseUser,required this.chatroom,required this.targetUser}) : super(key: key);

  @override
  State<BottomTabBar> createState() => _BottomTabBarState();
}

class _BottomTabBarState extends State<BottomTabBar> {
  int currentTab = 0;
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final List<Widget> screens = [Profile(userModel: widget.userModel, firebaseUser: widget.firebaseUser,
    ), Profile(
        userModel: widget.userModel, firebaseUser: widget.firebaseUser), TreandingSearch(userModel: widget.userModel,
      firebaseUser: widget.firebaseUser,)];


  }


  @override
  Widget build(BuildContext context) {
    Widget currentScreen =Profile(
        userModel: widget.userModel, firebaseUser: widget.firebaseUser);
    return Scaffold(

      body: PageStorage(bucket: bucket, child: currentScreen),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {

        },
        child: Image.asset(
          'asset/images/floating.png',
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      bottomNavigationBar: BottomAppBar(

        color: Color(0xff262626),
        shape: CircularNotchedRectangle(),

        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        currentScreen = HomePage(userModel: widget.userModel,
                          firebaseUser: widget.firebaseUser);
                        currentTab = 0;
                      });
                    },
                    minWidth: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home_outlined,
                            color: currentTab == 0 ? Colors.red : Colors.grey)
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        currentScreen = SettingScreen();
                        currentTab = 1;
                      });
                    },
                    minWidth: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.dashboard,
                            color: currentTab == 1 ? Colors.red : Colors.grey)
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        currentScreen = ChatScreen();
                        currentTab = 2;
                      });
                    },
                    minWidth: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat,
                            color: currentTab == 2 ? Colors.red : Colors.grey)
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        currentScreen = Profile(
                            userModel: widget.userModel, firebaseUser: widget.firebaseUser);
                        currentTab = 3;
                      });
                    },
                    minWidth: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person,
                            color: currentTab == 3 ? Colors.red : Colors.grey)
                      ],
                    ),
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
