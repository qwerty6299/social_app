import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:socialapp/splashscreen.dart';
import 'package:socialapp/theme_manager/Theme.dart';
import 'package:http/http.dart'as http;
import 'aaaaaaaa/bottom_navigation_page.dart';
import 'chatfirebase/models/UserModel.dart';
import 'homepage.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final prefs= await SharedPreferences.getInstance();
    final showhome=prefs.getString("USER_ID")??'';
  final loginpic=prefs.getString("loginpic")??'';
  final loginname=prefs.getString("loginname")??'';
  final loginuid=prefs.getString("loginuid")??'';
  final loginemail=prefs.getString("loginemail")??'';

  print(showhome);

    runApp( MyApp(showhome: showhome,loginemail:loginemail,loginname:loginname,loginpic:loginpic,loginuid:loginuid,));


}

class MyApp extends StatelessWidget {
String showhome;
String loginname,loginpic,loginuid,loginemail;


  MyApp({Key? key,required this.showhome,required this.loginname,required this.loginpic,required this.loginuid,required this.loginemail}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      print("gfhjgfdseghfdseghn${FirebaseAuth.instance.currentUser?.uid}");
    }

    return Sizer(builder: (context, orientation, deviceType) {

      return OverlaySupport(
        child:MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_)=> ThemeManager()),
          ],
          child: Builder(builder: (BuildContext context){
            final themeManager = Provider.of<ThemeManager>(context);
            return GetMaterialApp(

                themeMode: themeManager.themeMode,
                theme: MyThemes.lightTheme,
                darkTheme: MyThemes.darkTheme,

                debugShowCheckedModeBanner: false,

                home:showhome!=""?BottomNavigationPage(userModel: UserModel(uid: loginuid,email: loginemail,fullname: loginname,profilepic: loginpic), firebaseUser: FirebaseAuth.instance.currentUser!): SplashScreen(),
            );
          }),
        ),
          // GetMaterialApp(
          //   title: 'Social App',
          //   debugShowCheckedModeBanner: false,
          //   theme: ThemeData(
          //     primarySwatch: Colors.blue,
          //   ),
          //
          //
          // ),

      );
    });
  }
}

