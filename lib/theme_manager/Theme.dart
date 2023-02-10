import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ThemeManager with  ChangeNotifier{
  ThemeMode themeMode = ThemeMode.system;



  bool get isDarkMode => themeMode == ThemeMode.dark;


  void toggleTheme(bool isOn){
    themeMode =  isOn? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

}

class MyThemes{
  static final darkTheme = ThemeData(
      brightness: Brightness.dark,
      hoverColor:Color(0xff161730),

      // splashFactory: NoSplash.splashFactory,
      // splashColor: Colors.transparent,
      // canvasColor: colorLight1,
      // textSelectionTheme: TextSelectionThemeData(
      //     // cursorColor: colorDark3,
      //     // selectionColor: colorLight3
      // ),
      // cardColor: colorLight2,
      // brightness: Brightness.dark,
      // fontFamily: 'NotoSans',
      //brightness: Brightness.light,
      // primaryColor: primaryColor,
      // disabledColor: colorLight3,
      scaffoldBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
      accentColor: Colors.black,
      bottomAppBarColor: Colors.white,
      disabledColor:  Color(0xff262626),

      errorColor:Colors.white,
      dividerColor: Colors.black.withOpacity(0.2)
    // iconTheme: IconThemeData(
    //     color: colorDark1
    // ),
    // primaryIconTheme: IconThemeData(
    //     color: colorDark3
    // ),
    // textTheme: TextTheme(
    //   button: TextStyle(
    //     color: colorLightWhite,
    //     fontSize: 14,
    //     letterSpacing: 0.8,
    //     fontWeight: FontWeight.w500,
    //   ),
    //   headline4: TextStyle(
    //     fontWeight: FontWeight.w600,
    //     color: colorDark1,
    //     fontSize: 32,
    //   ),
    //   headline5: TextStyle(
    //       fontWeight: FontWeight.w500,
    //       color: colorDark1,
    //       fontSize: 24
    //   ),
    //   headline6: TextStyle(
    //     fontWeight: FontWeight.w500,
    //     color: colorDark1,
    //     fontSize: 20,
    //   ),
    //   bodyText1 : TextStyle(
    //       fontSize: 16,
    //       color: colorDark3,
    //       fontWeight: FontWeight.w400
    //   ),
    //   bodyText2 : TextStyle(
    //       fontSize: 14,
    //       color: colorDark3,
    //       fontWeight: FontWeight.w400
    //   ),
    //   subtitle2: TextStyle(
    //       fontSize: 14,
    //       color: colorDark1,
    //       fontWeight: FontWeight.w500
    //   ),
    //   subtitle1: TextStyle(
    //       fontSize: 16,
    //       color: colorDark1,
    //       fontWeight: FontWeight.w500
    //   ),
    //   caption: TextStyle(
    //       fontSize: 12,
    //       fontWeight: FontWeight.w400,
    //       color: colorDark3
    //   ),
    //   overline: TextStyle(
    //       fontSize: 10  ,
    //       fontWeight: FontWeight.w500,
    //       color: colorLight3
    //   ),
    // )
  );

  static final lightTheme =
  ThemeData(
    // splashColor: Colors.transparent,
    // splashFactory: NoSplash.splashFactory,
    // canvasColor: darkModeSectionColor1,
      hoverColor: Colors.white,
      brightness: Brightness.light,
      //   fontFamily: 'NotoSans',
      // //  primaryColor: primaryColor,
      // disabledColor: darkModeTextLight3,
      // cardColor: darkModeSectionColor,
      scaffoldBackgroundColor: Color(0xff161730),
      backgroundColor: Colors.black,
      accentColor: Colors.white,
      bottomAppBarColor: Color(0xff262626),
    disabledColor: Colors.white38,
      errorColor:  Color(0xff1D1D1D),
      dividerColor: Color(0xff1C1C29),


      // textSelectionTheme: TextSelectionThemeData(
      //     // cursorColor: darkModeTextLight1,
      //     // selectionColor: darkModeTextLight3
      // ),
      // primaryIconTheme: IconThemeData(
      //     // color: darkModeTextLight2
      // ),
      // iconTheme: IconThemeData(
      //     // color: colorLightWhite
      // ),
      // textTheme: TextTheme(
      //   button: TextStyle(
      //     // color: colorLightWhite,
      //     fontSize: 14,
      //     letterSpacing: 0.8,
      //     fontWeight: FontWeight.w500,
      //   ),
      //   headline4: TextStyle(
      //     fontWeight: FontWeight.w600,
      //     // color: colorLightWhite,
      //     fontSize: 32,
      //   ),
      //   headline5: TextStyle(
      //       fontWeight: FontWeight.w500,
      //       // color: colorLightWhite,
      //       fontSize: 24
      //   ),
      //   // headline6: TextStyle(
      //   //   fontWeight: FontWeight.w500,
      //   //   color: colorLightWhite,
      //   //   fontSize: 20,
      //   // ),
      //   // bodyText1 : TextStyle(
      //   //     fontSize: 16,
      //   //     color: darkModeTextLight2,
      //   //     fontWeight: FontWeight.w400
      //   // ),
      //   // bodyText2 : TextStyle(
      //   //     fontSize: 14,
      //   //     color: darkModeTextLight2,
      //   //     fontWeight: FontWeight.w400
      //   // ),
      //   // subtitle2: TextStyle(
      //   //     fontSize: 14,
      //   //     color: colorLightWhite,
      //   //     fontWeight: FontWeight.w500
      //   // ),
      //   // subtitle1: TextStyle(
      //   //     fontSize: 16,
      //   //     color: colorLightWhite,
      //   //     fontWeight: FontWeight.w500
      //   // ),
      //   // caption: TextStyle(
      //   //     fontSize: 12,
      //   //     fontWeight: FontWeight.w400,
      //   //     color: darkModeTextLight2
      //   // ),
      //   // overline: TextStyle(
      //   //     fontSize: 10  ,
      //   //     fontWeight: FontWeight.w500,
      //   //     color: darkModeTextLight3
      //   // ),
      // ),


  );
}