import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:socialapp/postview.dart';
import 'package:socialapp/hometabscreen.dart';
import 'package:socialapp/search_screen/treanding_search.dart';
import 'package:socialapp/thrillerscreen.dart';
import 'package:socialapp/educationscreen.dart';
import 'package:socialapp/actionscreen.dart';
import 'package:socialapp/testscreen.dart';
import 'package:socialapp/notification.dart';
import 'package:socialapp/profile.dart';

import 'aaaaaaaa/ChatPage.dart';
import 'chatfirebase/models/ChatRoomModel.dart';
import 'chatfirebase/models/UserModel.dart';
import 'chatfirebase/pages/ChatRoomPage.dart';
import 'chatfirebase/pages/LoginPage.dart';
import 'chatfirebase/pages/ShowChatPage.dart';
import 'hometabscreen2.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';


import 'my_icons_icons.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

    HomePage({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String status="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    status="Online";
  }
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   // TODO: implement didChangeAppLifecycleState
  //   super.didChangeAppLifecycleState(state);
  //   if(state==AppLifecycleState.resumed){
  //     setState((){
  //       status="online";
  //     });
  //   }
  //   else{
  //     setState((){
  //     status="offline";
  //     });
  //   }
  // }

  void updatestatus() async {
    UserCredential? credential;
       widget.userModel.status = status;
    print("agf${widget.userModel.status}");

    await FirebaseFirestore.instance.collection("users").doc(widget.userModel.uid).update({
      "status":status,

    });



  }
//   void setStatus(String status) async{
// await firestore.collection("users").doc(firebaseAuth.currentUser!.uid).update({
// "status":status,
// });
//   }
  Widget buildheader(BuildContext context)=>Container(
    color: Theme.of(context).scaffoldBackgroundColor,
    padding: EdgeInsets.only(
      top: 10+ MediaQuery.of(context).padding.top,
      bottom: 24
    ),
    child: Column(
      children: [
        CircleAvatar(
          radius: 52,
          backgroundImage: AssetImage("asset/images/dummyimage-removebg-preview.png"),
        ),
        SizedBox(
          height: 12,
        ),
        Text("Vikram",style: TextStyle(
          color: Theme.of(context).hoverColor,
        ),),
        Text('bhandari.vikram13@gmail.com',style: TextStyle(
          color: Theme.of(context).hoverColor,
        ),),

      ],
    ),
  );
  Widget buildMenuItem(BuildContext context)=>Container(
    padding: EdgeInsets.only(left: 6,top: 10),
    child: Wrap(
      runSpacing: 8,
      children: [
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          onTap: (){

          },
        ),
        ListTile(
          leading: Icon(Icons.favorite),
          title: Text('Favourites'),
          onTap: (){

          },
        ),
        ListTile(
          leading: Icon(Icons.workspaces_filled),
          title: Text('Workflow'),
          onTap: (){

          },
        ),
        ListTile(
          leading: Icon(Icons.update),
          title: Text('Update'),
          onTap: (){

          },
        ),
        const Divider(
          color: Colors.black54,
        ),
        ListTile(
          leading: Icon(Icons.notifications_active_outlined),
          title: Text('Notification'),
          onTap: (){

          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: (){

          },
        ),

      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    Future<bool> showExitPopup() async {
      return await showDialog(
            //show confirm dialogue
            //the return value will be from "Yes" or "No" options
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text('Exit Social App',style: TextStyle(
                color:  Theme.of(context).accentColor
              ),),
              content: Text('Do you really want to exit?',style: TextStyle(
                  color:  Theme.of(context).accentColor
              ),),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).scaffoldBackgroundColor
                  ),
                  //return true when click on "Yes"
                  child: Text('No',style: TextStyle(
                      color: Theme.of(context).hoverColor
                  ),),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).scaffoldBackgroundColor
                  ),
                  //return true when click on "Yes"
                  child: Text('Yes',style: TextStyle(
                      color: Theme.of(context).hoverColor
                  ),),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      child: DefaultTabController(

        length: 5,
        child: SafeArea(
          bottom: false,
          child: Scaffold(
            key: _scaffoldKey,

            drawer: Container(
              width: MediaQuery.of(context).size.width*0.60,
              child: Drawer(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildheader(context),
                      buildMenuItem(context)
                    ],
                  ),
                ),
              ),
            ),
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              leading:

              ExpandTapWidget(
                  onTap: (){
                    _scaffoldKey.currentState?.openDrawer();

                  },
                  tapPadding: EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    "asset/images/noti.svg",
                    height: 5, width: 5,
                    fit: BoxFit.scaleDown,

                    color: Theme.of(context).hoverColor,
                  ),
                ),


              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: ExpandTapWidget(
                        tapPadding: EdgeInsets.only(right: 1,left: 4),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Notification2()));
                        },
                        child: SvgPicture.asset(
                         "asset/images/newnoti.svg",
                          color: Theme.of(context).hoverColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(right: 15.0),
                      child: ExpandTapWidget(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TreandingSearch(userModel: widget.userModel,
                                    firebaseUser: widget.firebaseUser,)));
                        },
                        tapPadding: EdgeInsets.only(right: 5,left: 1),
                        child:  SvgPicture.asset(
                         "asset/images/searc.svg",
                          color: Theme.of(context).hoverColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              bottom: TabBar(
                labelColor: Theme.of(context).hoverColor,
                padding: EdgeInsets.only(),
                indicatorColor:Theme.of(context).hoverColor,
                isScrollable: true,
                tabs: [
                  Tab(text: "Home",),
                  Tab(text: "Thriller"),
                  Tab(text: "Education"),
                  Tab(text: "Action"),
                  Tab(text: "Test"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                HomeTabScreen(userModel: widget.userModel,firebaseUser: widget.firebaseUser),
                ThrillerScreen(),
                EducationScreen(),
                ActionScreen(),
                TestScreen(),

              ],
            ),
          ),
        ),
      ),
    );
  }

}
