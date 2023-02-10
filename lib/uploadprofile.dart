import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_s3/simple_s3.dart';
import 'package:socialapp/enterdetails.dart';
import 'package:socialapp/enterbio.dart';
import 'package:socialapp/model/uploadprofilepicmodel.dart';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'bucketmodel/Bucketmodel.dart';
import 'chatfirebase/models/UIHelper.dart';
import 'chatfirebase/models/UserModel.dart';
import 'model/user_model.dart';

class UploadProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  UploadProfile({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  State<UploadProfile> createState() => _UploadProfileState();
}

class _UploadProfileState extends State<UploadProfile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getbucketapi();
  }
  File imageFile = File("");
  String? businessimage;
  ImagePicker picker = ImagePicker();
  SimpleS3 _simpleS3 = SimpleS3();
  bool isLoading = false;
  bool uploaded = false;
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 10),
                          child: Column(
                            children: [
                              Icon(
                                Icons.arrow_back_ios_rounded,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Divider(
                height: 10,
                color: Color(0xff484848),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 30),
                child: Row(
                  children: [
                    Text(
                      'Upload Profile Pic',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  ],
                ),
              ),

              SizedBox(height: 60,),

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
                          ? Icon(
                              Icons.person,
                              size: 100,
                              color: Color(0xff161730),
                            )
                          : ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              child: Image.file(
                                imageFile,
                                fit: BoxFit.cover,
                                height: 125,
                                width: 125,
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
              isLoading==true?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitThreeBounce(
                    size: 20,

                    itemBuilder: (BuildContext context, int index) {
                      return DecoratedBox(

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index.isEven ? Colors.redAccent :Theme.of(context).hoverColor,
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Uploading....',style: TextStyle(
                    color:Theme.of(context).hoverColor,
                  ),)
                ],
              ):Container(),
            
             Padding(
                padding: const EdgeInsets.only(top: 108.16, left: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {

                         Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EnterBio(userModel: widget.userModel, firebaseUser: widget.firebaseUser)));
                      },
                      child: new Container(
                        width: size.width / 2.5,
                        margin: EdgeInsets.only(left: 10, right: 10),
                        height: 48,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage('asset/images/bluebutton.png'),
                                fit: BoxFit.fill)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Skip',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    ),

                    GestureDetector(
                       onTap: () {
                     {
                        uploadData().then((value) async {
                          print(value.sTATUS);
                          if (value.sTATUS == "SUCCESS") {
                            setphotoscreen(businessimage.toString());
                            uploadData2();
                            Fluttertoast.showToast(
                                msg: value.mESSAGE!,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EnterBio(userModel: widget.userModel, firebaseUser: widget.firebaseUser)));
                          } else {
                            print(1);
                            print(value.sTATUS);

                            Fluttertoast.showToast(
                                msg: value.mESSAGE!,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        });
                      }
                    },

                      // onTap: () {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => EnterBio()));
                      // },
                      child: new Container(
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
                              'Next',
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
              )
            ],
          ),
        ),
      ),
    );
  }
Future<File> customCompressed({required File imagepathtocompress, quality=100,percentage=10})async{
var path = await FlutterNativeImage.compressImage(imagepathtocompress.absolute.path,quality: 100,percentage: 10);
return path;
}
  void _pickImage() async {
    try {
      ImagePicker picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
File img= File(pickedFile.path);


          print("before compressed ${img.lengthSync()/ (1024 * 1024)}");
          File compressedimage=await customCompressed(imagepathtocompress: img);
          print("compressed image is ${compressedimage.lengthSync()/ (1024 * 1024)}");
          setState(() {
    imageFile=compressedimage;
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
          s3FolderPath: "user",
          accessControl: S3AccessControl.publicRead,
        );

        print("https://winklixsocial.s3.ap-south-1.amazonaws.com/" +
            "user/${imageFile.path.split("/").last}");
        businessimage = ("https://winklixsocial.s3.ap-south-1.amazonaws.com/" +
            "user/${imageFile.path.split("/").last}");

        setState(() {
          uploaded = true;
          isLoading = false;
        });
      } catch (e) {
        print("print ${e.toString()}");
      }
    }
    return result;
  }
  Future setphotoscreen(String img)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("mainpagepic",img);


  }

   Future<UploadProfilePicModel> uploadData() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('USER_ID') ?? '';
    String USERNAME = prefs.getString('USERNAME') ?? '';
    print(USERNAME);
   var headers = {
  'Content-Type': 'application/json',
  'Cookie': 'connect.sid=s%3AKYD3R_7kk1XhzCMf8CEaV2RYGNIVVfTh.69ePnjPYBrCquGgmleunT9UiRbaxxNMoskCdkc7sJYE'
};
var request = http.Request('POST', Uri.parse('http://3.227.35.5:3001/api/user/updateProfilePic'));
request.body = json.encode({
  "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
  "USERNAME": USERNAME,
  "ID": name,
  "PROFILE_PIC": businessimage
});
request.headers.addAll(headers);

http.StreamedResponse response = await request.send();
    var data = jsonDecode(await response.stream.bytesToString());
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!hjk");
      print(response.reasonPhrase);
      print(data);
      return UploadProfilePicModel.fromJson(data);
    } else {
      Navigator.of(context).pop();
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      print(response.reasonPhrase);
      return UploadProfilePicModel.fromJson(data);
    }
  }
  void uploadData2() async {
    UserCredential? credential;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('USER_ID') ?? '';
    String USERNAME = prefs.getString('USERNAME') ?? '';
    print(USERNAME);

    // UIHelper.showLoadingDialog(context, "Uploading image..");
    //
    // UploadTask uploadTask = FirebaseStorage.instance.ref("profilepictures").child(widget.userModel.uid.toString()).putFile(imageFile);
    //
    // TaskSnapshot snapshot = await uploadTask;
    //
    // String? imageUrl = await snapshot.ref.getDownloadURL();
    String? fullname = USERNAME;

    widget.userModel.fullname = fullname;
     widget.userModel.profilepic = businessimage;
    print("asdvfbgnhgfdsfghjm,kjhgfdsfghjhgf${ widget.userModel.fullname}");

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
