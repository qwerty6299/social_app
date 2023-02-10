import 'dart:convert';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:http/http.dart' as http;

import '../chatfirebase/models/ChatRoomModel.dart';
import '../chatfirebase/models/UserModel.dart';
import '../chatfirebase/pages/ShowChatPage.dart';
import '../homepage.dart';
import '../hometabscreen.dart';
import '../hometabscreen2.dart';
import '../my_icons_icons.dart';
import '../postview.dart';
import '../profile.dart';


class BottomNavigationPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  BottomNavigationPage({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {



  Color colorDark = Color(0xff2867B4);
  Color colorLight = Color(0xffc0eeff);
  Color colorLightSecond = Color(0xffE5F8FF);
  var height = AppBar().preferredSize.height;
  int selectedIndex = 0;
  final Screens = [
    // HomePage(),
    // LiveQuizzesPage(),
    // LeaderboardPage(),
    // UserProfile()
  ];

  List<Widget> ScreensPre=[];




  @override
  void initState() {
    // TODO: implement initState



    ScreensPre =[
      HomePage(userModel: widget.userModel, firebaseUser: widget.firebaseUser),
      HOmetabscreen2(userModel: widget.userModel, firebaseUser: widget.firebaseUser,),
      ShowChatPage(userModel: widget.userModel, firebaseUser: widget.firebaseUser),
      Profile(userModel: widget.userModel, firebaseUser: widget.firebaseUser),

      // HomePage(),
      // LiveQuizzesPage(),
      // PremiumQuizes(),
      // LeaderboardPage(),
      // UserProfile()
    ];

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,

      child: Scaffold(


        extendBody: true,
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => PostView(userModel: widget.userModel, firebaseUser: widget.firebaseUser)));
          },
          child:new Image.asset(
            'asset/images/floating.png',
          ),
        ),
      //  backgroundColor: colorDark,
        body: Stack(
            children: [
              IndexedStack(
                index: selectedIndex,
                children: ScreensPre,
              ),


            ]
        ),
        bottomNavigationBar:AnimatedBottomNavigationBar( //navigation bar
          icons: iconList,
          inactiveColor: Colors.white,
          activeColor: Colors.white,
          activeIndex: 0,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          onTap: (index){
              setState(() {
                selectedIndex=index;
              });
            // if(index==0){
            //   setState(() {
            //     HomeTabScreen();
            //
            //   });
            // }
            // else if(index==1){
            //   setState(() {
            //     Navigator.push(
            //         context, MaterialPageRoute(builder: (context) => HOmetabscreen2()));
            //   });
            // }
            // else if(index==2){
            //
            //   setState(() {
            //     //updatestatus();
            //     Navigator.push(
            //         context, MaterialPageRoute(builder: (context) => ShowChatPage(userModel: widget.userModel, firebaseUser: widget.firebaseUser)));
            //   });
            //
            //
            // }else if(index==3){
            //   setState(() {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => Profile(userModel: widget.userModel, firebaseUser: widget.firebaseUser)));
            //   });
            //
            // }

            //setState(() => _bottomNavIndex = index;
          } ,
          backgroundColor:Color(0xff262626),

        ),
      ),
    );
  }
  List<IconData> iconList = [
    MyIcons.homepageone,
    MyIcons.homepagetwo,
    MyIcons.homepagethree,
    MyIcons.homepagefour,


  ];
  @override
  bool get wantKeepAlive => true;
}