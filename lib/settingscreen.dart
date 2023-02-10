import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/login.dart';
import 'package:socialapp/profile_tab/Privacypage.dart';
import 'package:socialapp/settingnotification.dart';
import 'package:socialapp/settingscreen.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:socialapp/theme_manager/theme2.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool val1 = true;
  bool clicked=true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
         automaticallyImplyLeading: false,
          title: Text(
            'Settings',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).hoverColor),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text(
                      'Settings',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).hoverColor),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 100,
                color: Theme.of(context).dividerColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Image.asset('asset/images/profile.png'),
                      ),
                      title: Text(
                        'Profile',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).hoverColor),
                      ),
                      subtitle: Text(
                        'username,Bio,profile',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        size: 25,
                        color: Colors.grey,
                      )),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                  child: Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.nightlight_round,
                      size: 20,
                      color: Theme.of(context).hoverColor,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    // Text(
                    //   'Light Mode',
                    //   style: TextStyle(
                    //       fontSize: 15,
                    //       fontWeight: FontWeight.w500,
                    //       color: Theme.of(context).hoverColor),
                    // ),
                    Container(
                      height: 40,
                        child: Row(
                          children: [
                        Text('Light mode',style: TextStyle(
                              color:Theme.of(context).hoverColor
                          ),),

                          ],
                        )),
                    Expanded(
                      child: Container(
                        height: 40,
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ChangeThemeButtomWidget(),
                        ],
                      )),
                    ),
                  ],
                ),
              )),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingNotificationScreen()));
                },
                child: Container(
                  color:Theme.of(context).dividerColor,
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none,
                          size: 20,
                          color: Theme.of(context).hoverColor,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          'Notifications',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).hoverColor),
                        ),
                        SizedBox(
                          width: size.width / 1.8,
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 25,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.block,
                        size: 20,
                        color: Theme.of(context).hoverColor,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        'Blocked User',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).hoverColor),
                      ),
                      SizedBox(
                        width: size.width / 1.8,
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 25,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ExpandTapWidget(
                onTap: () {
                Get.to(Privacy());
                },
                tapPadding: EdgeInsets.only(right: 10,left: 6),
                child: Container(
                  color: Theme.of(context).dividerColor,
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock,
                          size: 20,
                          color: Theme.of(context).hoverColor,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          'Privacy',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).hoverColor),
                        ),
                        SizedBox(
                          width: size.width / 1.55,
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 25,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ExpandTapWidget(
                  tapPadding: EdgeInsets.all(10.0),
                onTap: (){
                    showExitPopup();

                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.login,
                              size: 20,
                              color: Theme.of(context).hoverColor,
                            ),
                            SizedBox(
                              width: 6,
                            ),

                            Text(
                              'Log Out',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).hoverColor),
                            ),
                          ],
                        ),


                        Icon(
                          Icons.chevron_right,
                          size: 25,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<bool> showExitPopup() async {
    return await showDialog(
      //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromARGB(255, 236, 236, 236),
        title: Text('Logout Social App'),
        content: Text('Do you really want to Logout?'),
        actions: [
          OutlinedButton(
            style: ButtonStyle(
              // backgroundColor:
              //     MaterialStateProperty.all(Color(0xff161730)),
                foregroundColor:
                MaterialStateProperty.all(Color(0xff161730))),
            onPressed: () => Navigator.of(context).pop(false),
            //return false when click on "NO"
            child: Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              logout();
            },
            style: ElevatedButton.styleFrom(
              primary: Color(0xff161730),
            ),
            //return true when click on "Yes"
            child: Text('Yes'),
          ),
        ],
      ),
    ) ??
        false; //if showDialouge had returned null, then return false
  }
  Widget customSwitch(String text, bool val, Function onChangeMethod) {
    return Padding(
      padding: EdgeInsets.only(top: 22, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).hoverColor),
          ),
          Spacer(),
          CupertinoSwitch(
              trackColor: Colors.grey,
              activeColor: Theme.of(context).hoverColor,
              value: val,
              onChanged: (newValue) {
                onChangeMethod(newValue);
              })
        ],
      ),
    );
  }
  Future logout()async{
    final prefs= await SharedPreferences.getInstance();
    prefs.remove("USER_ID")??'';
    prefs.remove("USERNAME")??'';
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>Login()));
    });
  }
}
