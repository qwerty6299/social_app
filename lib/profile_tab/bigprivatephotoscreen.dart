import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../likeindex_apicall/like.dart';
class BigPrivatePhotoScreen extends StatefulWidget {
  const BigPrivatePhotoScreen({Key? key}) : super(key: key);

  @override
  State<BigPrivatePhotoScreen> createState() => _BigPrivatePhotoScreenState();
}

class _BigPrivatePhotoScreenState extends State<BigPrivatePhotoScreen> {
  String img="";
  Future getprivatephotoscreen()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("privatephoto").toString();
    setState((){
      img=userId;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getprivatephotoscreen();

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xff161730),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(25.0),
                      topRight:Radius.circular(25.0),bottomLeft:Radius.circular(25.0),
                      bottomRight: Radius.circular(25.0)
                  ),
    ),
              child: Column(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6.0,right: 6.0,top: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(topLeft:Radius.circular(20.0),
                            topRight: Radius.circular(20.0)),
                        child:img==""?Container(): CachedNetworkImage(imageUrl: img,
                          fit: BoxFit.fill,
                          width: double.infinity,
                          placeholder: (context, url) => Center(child: new Icon(Icons.person)),
                          errorWidget: (context, url, error) => new Icon(Icons.person),
                        ),),
                    ),
                  ),
                  Padding(
                    padding:EdgeInsets.only(left: 5.5,right: 5.5) ,
                    child: Container(
                      padding:EdgeInsets.only(bottom: 6.0) ,
                      decoration: BoxDecoration(

                          color: Color(0xff2F2F2F)),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 10, left: 10),
                        child: Row(children: [
                          Icon(
                            Icons.favorite,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 18,
                          ),
                          GestureDetector(
                            onTap: () {

                            },
                            child: Icon(
                              Icons.comment_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        
                          SizedBox(width: MediaQuery.of(context).size.width / 50),
                          GestureDetector(
                            onTap: () {
                            },
                            child: Text(
                              'comments',
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xffD1D1D1)),
                            ),
                          ),
                          SizedBox(
                            width:  MediaQuery.of(context).size.width / 12,
                          ),
                          Icon(
                            Icons.send,
                            color: Color.fromARGB(
                                255, 155, 152, 152),
                            size: 28,
                          ),
                          SizedBox(
                            width:  MediaQuery.of(context).size.width / 3.8,
                          ),
                         Icon(
                           Icons.bookmark_add
                         )
                        ]),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}
