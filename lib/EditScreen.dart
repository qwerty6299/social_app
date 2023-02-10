import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_s3/simple_s3.dart';
import 'package:socialapp/aaaaaaaa/bottom_navigation_page.dart';
import 'package:socialapp/enterdetails.dart';
import 'package:socialapp/enterbio.dart';
import 'package:socialapp/model/uploadprofilepicmodel.dart';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'bucketmodel/Bucketmodel.dart';
import 'chatfirebase/models/UserModel.dart';
import 'homepage.dart';
import 'model/updateprofile.dart';
import 'model/user_detail_model.dart';
import 'model/user_model.dart';

class EditScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  EditScreen({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  File imageFile = File("");
  String? businessimage;
  ImagePicker picker = ImagePicker();
  SimpleS3 _simpleS3 = SimpleS3();
  bool isLoading = false;
  bool uploaded = false;
  final editfname=TextEditingController();
  final editlname=TextEditingController();
  final editusername=TextEditingController();
  final editbio=TextEditingController();
  String idd="";
  String fname="";
  String lname="";
  String pp="";
  String bio="";
  String username="";
  UserdetailModel? userdetailModel;
  Future getid()async{
    final prefs= await SharedPreferences.getInstance();
    final showhome=prefs.getString("USER_ID")??'';
    print(showhome);
    setState(() {
      idd=showhome;
    });
  }
   Future<UserdetailModel?> getuserprofile()async{
    var response= await http.post(Uri.parse("http://3.227.35.5:3001/api/user/get_user_detailsF"),body: {

        "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
        "ID":"$idd"

    });
    if(response.statusCode==200){
      print(response.body);

      setState(() {
        userdetailModel=userdetailModelFromJson(response.body);
        fname=userdetailModel!.data.firstName.toString();
        lname=userdetailModel!.data.lastName.toString();
        username=userdetailModel!.data.username.toString();
        pp= userdetailModel!.data.profilePic;
        bio=userdetailModel!.data.bio.toString();


      });
    }else{
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getbucketapi();

    getid().whenComplete(()async{
      await getuserprofile();
      editfname.value = new TextEditingController.fromValue(new TextEditingValue(text: "$fname")).value;
      editlname.value = new TextEditingController.fromValue(new TextEditingValue(text: "$lname")).value;
      editusername.value = new TextEditingController.fromValue(new TextEditingValue(text: "$username")).value;
      editbio.value = new TextEditingController.fromValue(new TextEditingValue(text: "$bio")).value;
    });

  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff161730),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 54,
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: Row(
                        children: [
                          InkWell(
                            onTap:(){
                              Get.back();
                            },
                            child: Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Text('Edit Profile',style: TextStyle(
                            color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16
                          ),)
                        ],
                      ),
                    )
                  ],
                ),
              ),



              SizedBox(height: 10,),


              Stack(
                children: [
                  Center(
                    child: InkWell(
                      onTap: () {
                        _pickImage();
                      },
                      child: CircleAvatar(
                        radius: 60.0,
                        backgroundColor: Colors.white,
                        child: imageFile.path == ""
                            ?
                        Container(

                              child: ClipRRect(
                          borderRadius:
                          BorderRadius.all(Radius.circular(100)),
                              child: CachedNetworkImage(imageUrl: pp,width:125,height: 125,
                                fit: BoxFit.fill,
                                placeholder: (context, url) => Center(child: new CircularProgressIndicator()),
                                errorWidget: (context, url, error) => new Icon(Icons.person),
                              ),),
                            )
                            :Container(child:  ClipRRect(
                          borderRadius:
                          BorderRadius.all(Radius.circular(100)),
                          child: Image.file(
                           imageFile,

                            fit: BoxFit.fill,
                            height: 125,
                            width: 125,
                          ),
                        ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 8,
                      right: 105,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 12,
                        child: IconButton(
                            onPressed: () {
                              _pickImage();
                            },
                            icon: Icon(
                              Icons.edit,
                              size: 12,
                              color: Colors.black,
                            )),
                      )),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width*0.4  ,

                    // width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff4F4F4F)),
                        borderRadius: BorderRadius.circular(28)),
                    child: TextFormField(

                      controller: editfname,
                      maxLines: 2,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      textAlign: TextAlign.start,

                      decoration: InputDecoration(


                        border: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,

                        // contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        contentPadding: EdgeInsets.only(top: 16, left: 16),


                        hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff4F4F4F)),
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width*0.4,

                    // width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff4F4F4F)),
                        borderRadius: BorderRadius.circular(28)),

                      child: TextFormField(
                        controller: editlname,

                        maxLines: 20,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,

                          // contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          contentPadding: EdgeInsets.only(top: 16, left: 16),


                          hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff4F4F4F)),
                        ),
                      ),

                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Container(
                  height: 51,

                  // width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff4F4F4F)),
                      borderRadius: BorderRadius.circular(28)),
                  child: TextFormField(
                    controller: editusername,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,

                      // contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      contentPadding: EdgeInsets.only(top: 4, left: 12),


                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff4F4F4F)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Container(
                  height: 250,

                  // width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff4F4F4F)),
                      borderRadius: BorderRadius.circular(28)),
                  child: TextFormField(
                    controller: editbio,
                    maxLines: 20,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,

                      // contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      contentPadding: EdgeInsets.only(top: 10, left: 12),


                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff4F4F4F)),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: (){

                  uploadeditData(id:"$idd").then((value) async{
                      print(value.status);
                    //uploadData2();
                      if(value.status=="SUCCESS"){
                        Fluttertoast.showToast(
                            msg: "profile updated successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>BottomNavigationPage (userModel: widget.userModel, firebaseUser: widget.firebaseUser)));

                      }

                    });

                },
                child: Container(
                  width: size.width / 2.5,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  height: 48,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('asset/images/redbutton.png'),
                          fit: BoxFit.fill)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Save Changes',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      )
                    ],
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    try {
      ImagePicker picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {

          imageFile = File(pickedFile.path);
        });
        _uploadBusinessLicense();
      }
    } catch (e) {
      print("Image picker error " + e.toString());
    }
  }
  Bucketmodel? bucketmodel;
  Future getbucketapi()async{
    var response = await http.get(Uri.parse("http://3.227.35.5:3001/api/user/credentials"));
    if(response.statusCode==200){
      setState((){
        bucketmodel=bucketmodelFromJson(response.body);
        print(response.body);
      });

    }
    else{
      print(response.statusCode);
    }
  }
  Future<String?> _uploadBusinessLicense() async {
    String? result;

    if (result == null) {
      try {
        setState(() {
          isLoading = true;
        });
        result = await _simpleS3.uploadFile(
          imageFile,
          "${bucketmodel!.data.bucket.toString()}",
          "${bucketmodel!.data.poolId.toString()}",
          AWSRegions.apSouth1,
          debugLog: true,
          s3FolderPath:"image" ,
        );

        print("https://winklixsocial.s3.ap-south-1.amazonaws.com/image/" +
            "${imageFile.path.split("/").last}");
        businessimage = ("https://winklixsocial.s3.ap-south-1.amazonaws.com/" +
            "image/${imageFile.path.split("/").last}");

        setState(() {
          uploaded = true;
          isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    }
    return result;
  }



  Future<UpdateprofileModel> uploadeditData({required String id}) async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String name = prefs.getString('USER_ID') ?? '';
    // String USERNAME = prefs.getString('USERNAME') ?? '';
    // print(USERNAME);
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'connect.sid=s%3AKYD3R_7kk1XhzCMf8CEaV2RYGNIVVfTh.69ePnjPYBrCquGgmleunT9UiRbaxxNMoskCdkc7sJYE'
    };
    var request = http.Request('POST', Uri.parse('http://3.227.35.5:3001/api/user/update-profile'));
    request.body = json.encode({
    "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
    "ID":"$id",
    "FIRST_NAME":editfname.text,
    "LAST_NAME":editlname.text,
    "USERNAME":editusername.text,
    "BIO":editbio.text,
    "PROFILE_PIC":businessimage

    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var data = jsonDecode(await response.stream.bytesToString());
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!hjk");
      print(response.reasonPhrase);
      print(data);
      return UpdateprofileModel.fromJson(data);
    } else {
      Navigator.of(context).pop();
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      print(response.reasonPhrase);
      return UpdateprofileModel.fromJson(data);
    }
  }
  void uploadData2() async {
    UserCredential? credential;

    widget.userModel.fullname = editusername.text.trim().toString();
    widget.userModel.profilepic = businessimage;
    print("asdvfbgnhgfd${widget.userModel.profilepic}");

    await FirebaseFirestore.instance.collection("users").doc(widget.userModel.uid).set(widget.userModel.toMap()).then((value) {
      // log("Data uploaded!");
      // Navigator.popUntil(context, (route) => route.isFirst);
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) {
      //     return HomePage(userModel: widget.userModel, firebaseUser: widget.firebaseUser);
      //   }),
      // );


    });
  }

}
