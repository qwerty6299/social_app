// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sizer/sizer.dart';
// import 'package:socialapp/profile.dart';
// import 'package:http/http.dart' as http;
//
// import '../model/profile_model.dart';
//
// class PrivatePhotoScreen extends StatefulWidget {
//   PrivatePhotoScreen({Key? key}) : super(key: key);
//
//   @override
//   State<PrivatePhotoScreen> createState() => _PrivatePhotoScreenState();
// }
//
// class _PrivatePhotoScreenState extends State<PrivatePhotoScreen> {
//   ProfileModel? _profileData;
//
//   void initState() {
//     _getData();
//
//     super.initState();
//   }
//
//   void _getData() async {
//     _profileData = (await getProfileService().getProfile());
//     Future.delayed(const Duration(seconds: 0)).then((value) => setState(() {}));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xff262626),
//       body: SingleChildScrollView(
//         child: Container(
//           height: 90.h,
//           // padding: EdgeInsets.all(12.0),
//           child: GridView.builder(
//             physics: BouncingScrollPhysics(),
//             scrollDirection: Axis.vertical,
//             shrinkWrap: true,
//             itemCount: _profileData?.data.posts.length,
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisSpacing: 0,
//               mainAxisSpacing: 0,
//               crossAxisCount: 3,),
//             itemBuilder: (BuildContext context, int index) {
//               return _profileData == null || _profileData!.data.posts.isEmpty
//                   ? Center(
//                       heightFactor: 14,
//                       child: CircularProgressIndicator(),
//                     )
//                   : Padding(
//                       padding: const EdgeInsets.only(left: 0.0),
//                       child: Stack(children: [
//                         Container(
//                           width: MediaQuery.of(context).size.width/2,
//                           child: CachedNetworkImage (imageUrl: _profileData!.data.posts[index].backgroundImage,
//                             height: 200,
//                             fit: BoxFit.cover,
//
//                             placeholder: (context, url) => Center(child: new CircularProgressIndicator()),
//                             errorWidget: (context, url, error) => new Icon(Icons.person),),
//                         ),
//
//                         // Align(
//                         //     alignment: Alignment.center,
//                         //     child: Padding(
//                         //       padding: EdgeInsets.only(bottom: 6.0),
//                         //       child: Text(
//                         //         _profileData!.data.posts[index].title,
//                         //
//                         //         style: TextStyle(
//                         //
//                         //             overflow: TextOverflow.ellipsis,
//                         //             fontSize: 12,
//                         //             fontWeight: FontWeight.w500,
//                         //             color: Colors.white),
//                         //       ),
//                         //     )),
//                         //
//                         // Align(
//                         //     alignment: Alignment.bottomCenter,
//                         //     child: Padding(
//                         //       padding: EdgeInsets.only(bottom: 6.0),
//                         //       child: Text(
//                         //   _profileData!.data.posts[index].category.toString(),
//                         //
//                         //         style: TextStyle(
//                         //
//                         //             overflow: TextOverflow.ellipsis,
//                         //             fontSize: 12,
//                         //             fontWeight: FontWeight.w500,
//                         //             color: Colors.white),
//                         //       ),
//                         //     )),
//
//                       ]),
//                     );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class getProfileService {
//   Future<ProfileModel?> getProfile() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String userId = prefs.getString("USER_ID").toString();
//     print(userId);
//
//     try {
//       print("trying to Profile");
//
//       var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.profileEndPoint);
//
//       var response = await http.post(url,
//           headers: {
//             'Content-Type': 'application/json',
//             'Cookie':
//                 'connect.sid=s%3AtVnLmITSn_zletRj2nMA2yCjWafW69aY.vufwo%2Fh45zhYEp06x9RKcV0mhk2DkYDZ1twbPiJRp5Y'
//           },
//           body: json
//               .encode({"APP_KEY": "SpTka6TdghfvhdwrTsXl28P1", "ID": userId}));
//       print(response.statusCode);
//       print(response.body);
//
//       if (response.statusCode == 200) {
//         print("---------- Success -----------");
//
//         ProfileModel _model = profileModelFromJson(response.body);
//         return _model;
//       }
//     } catch (e) {
//       log(e.toString());
//     }
//   }
// }
//
// class ApiConstants {
//   static String baseUrl = 'http://3.227.35.5:3001/api/user/';
//   static String profileEndPoint = 'fetch_profile';
// }

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/my_profile_model.dart';
import '../privateeeeeeeeeee/privatephotomodel.dart';
import 'bigprivatephotoscreen.dart';


class PrivatePhotoScreen extends StatefulWidget {
  const PrivatePhotoScreen({Key? key}) : super(key: key);

  @override
  State<PrivatePhotoScreen> createState() => _PrivatePhotoScreenState();
}

class _PrivatePhotoScreenState extends State<PrivatePhotoScreen> {
  String idtoken="";
  String navigateprivatepic="";
  String backgroundimage="";

  Future setphotoscreen(String img)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("privatephoto",img);


  }
  Future getuserid()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("USER_ID").toString();

    setState((){
      idtoken=userId;
    });
    print("the private photo token us $idtoken");
  }
  @override
  void initState() {
    super.initState();

    getuserid().whenComplete(() async{
      getprivatePhoto();
    });


  }
  // Future getprivatePhoto() async {
  //   try {
  //     var url = Uri.parse("http://3.227.35.5:3001/api/user/my_profile");
  //     var data={
  //       "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
  //       "ID": "$idtoken"
  //     };
  //
  //     var response = await http.post(url, body: data);
  //     if (response.statusCode == 200) {
  //       print("wweewewew${myProfile!.status}");
  //       print("the response isss${response.body}");
  //       print("imgggg ${myProfile!.privatePhoto[0].backgroundImage}");
  //       print("the lenggggggggggggggggggg is ${myProfile!.privatePhoto.length}");
  //       myProfile=myPrModelFromJson(response.body);
  //       setState(() {
  //         for(int i=0;i<myProfile!.privatePhoto.length;i++){
  //           backgroundimage=myProfile!.privatePhoto[i].backgroundImage;
  //           privatePhoto.add(Photo(backgroundImage: backgroundimage,
  //           ));
  //         }
  //       });
  //
  //     }
  //     else{
  //       print("111111111111${response.statusCode}");
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }
  PrivatephotoModel? privatephotoModel;
  List<PrivatePhoto> privatennPhoto=[];
  getprivatePhoto()async{
    var data={
      "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
      "ID": "$idtoken"
    };
    var response=await http.post(Uri.parse("http://3.227.35.5:3001/api/user/my_profile"),body: data);
    if(response.statusCode==200){
      print("the data is $data");
      print("1222${response.body}");
      privatephotoModel=privatephotoModelFromJson(response.body);
      setState(() {
        for(int i=0;i<privatephotoModel!.privatePhoto.length;i++){
          backgroundimage=privatephotoModel!.privatePhoto[i].backgroundImage.toString();
          privatennPhoto.add(PrivatePhoto(backgroundImage: backgroundimage));
          print("12345678${backgroundimage}");
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).bottomAppBarColor,
      body: SingleChildScrollView(
        child: privatephotoModel==null?Center(
          child: CircularProgressIndicator(),
        ):privatennPhoto.length==0?Center(
          heightFactor: 18,
          child: Text("No result found"),
        ):Container(
          child: GridView.builder(
            itemCount: privatennPhoto.length,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            crossAxisCount: 3,
          ), itemBuilder: (BuildContext context, int index){
            return  GestureDetector(
              onTap: (){
                setphotoscreen("${ privatephotoModel!.privatePhoto[index].backgroundImage}");
                Get.to(BigPrivatePhotoScreen());
              },
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.all(Radius.circular(15)),
                  child: CachedNetworkImage(imageUrl: privatephotoModel!.privatePhoto[index].backgroundImage,width:125,height: 125,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Center(child: new CircularProgressIndicator()),
                    errorWidget: (context, url, error) => new Icon(Icons.person),
                  ),),
              ),
            );
          }),
        ),
      ),
    );
  }
}

