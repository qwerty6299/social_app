import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Googlesigninn extends ChangeNotifier{
  final googlesignin=GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user=> _user!;

  Future googlelogin() async{
    final googleuser=await googlesignin.signIn();
    if(googleuser==null){
      return ;
    }
    _user=googleuser;

    final googleauth = await googleuser.authentication;
    final creds = GoogleAuthProvider.credential(
      accessToken: googleauth.accessToken,
      idToken: googleauth.idToken,);
    await FirebaseAuth.instance
        .signInWithCredential(
        creds);

    notifyListeners();

  }
}