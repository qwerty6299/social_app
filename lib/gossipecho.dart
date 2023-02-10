import 'dart:collection';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/aaaaaaaa/bottom_navigation_page.dart';
import 'package:socialapp/homepage.dart';

import 'package:http/http.dart'as http ;

import 'chatfirebase/models/UserModel.dart';
import 'model/interestlistmodel.dart';
import 'model/user_model.dart';

class GossipEcho extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  GossipEcho({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  State<GossipEcho> createState() => _GossipEchoState();
}

class _GossipEchoState extends State<GossipEcho> {
  InterestListModel? interestlistmodel;
  List<InterestList> interestList=[];
  String icon="";
  String id="";
  String name="";
  HashSet selecteditem=new HashSet();
List<int> selectedCard =List.generate(2000, (index) => -1) ;
  @override
  void initState() {

    super.initState();
    print("vdvd");
    postgossip();

  }
  void domultiselection(int index){
    setState(() {
      if(selecteditem.contains(index)){
        selecteditem.remove(index);
      }
      else{
        selecteditem.add(index);
      }
    });
  }

  void postgossip()async{
    try {
      var response = await http.post(
          Uri.parse("http://3.227.35.5:3001/api/user/get-interests"),

          body: {"APP_KEY": "SpTka6TdghfvhdwrTsXl28P1"});
      print("tghnhggfhgfghh ${response.statusCode}");


      if (response.statusCode == 200) {
        print("---------- Success -----------");
        interestlistmodel = interestListModelFromJson(response.body);
        print(response.body);
        setState(() {
          for (int i = 0; i < interestlistmodel!.interestList.length; i++) {
            id =interestlistmodel!.interestList[i].id!;
            icon =interestlistmodel!.interestList[i].icon;
            name =interestlistmodel!.interestList[i].name;
            print("the name is $name");
          }
          interestList.add(InterestList(

              icon: icon,
              name: name));
        });



      }
      else {
        print(response.statusCode);
      }
    }catch(e){
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(

        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 45),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => BottomNavigationPage(userModel: widget.userModel, firebaseUser: widget.firebaseUser)),
                        (Route<dynamic> route) => false);
                  },
                  child: new Container(
                    width: size.width / 2,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: 55,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('asset/images/redbutton.png'),
                            fit: BoxFit.fill)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue',
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
        backgroundColor: Color(0xff0A0202),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xff0A0202),
        ),
        body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Gossip Echo',
                      style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                          color: Colors.white))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                  Divider(
                    thickness: 0,
                    color: Colors.white,
                  ),
                  Positioned(
                    right: 60,
                    left: 60,
                    // top: 7,
                    // bottom: 5,
                    child: Container(
                      color: Color(0xff0A0202),
                      child: Center(
                          child: Text(
                            'Choose your interest',
                            style: TextStyle(
                                color: Colors.white54,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  )
                ],
              ),
              Expanded(
                child:interestList.isNotEmpty? GridView.builder(
                  itemCount:interestlistmodel!.interestList.length,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3

                  ),
                  itemBuilder: (ctx,i){

                  return  GestureDetector(
                    onTap: (){
                     domultiselection(i);
                    },

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 80,
                          width: 70,

                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white),
                              color: selecteditem.contains(i) ? Colors.redAccent.withOpacity(0.8) :Color(0xff0A0202)),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                CachedNetworkImage (imageUrl:interestlistmodel!.interestList[i].icon,
                                  height: 30,
                                  width: 30,
                                  fit: BoxFit.cover,

                                  placeholder: (context, url) => Center(child: new CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => new Icon(Icons.person),),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${interestlistmodel!.interestList[i].name}',
                                  style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),


                      ],
                    ),
                  );
                }, ):Center(child: CircularProgressIndicator(),
              ),
              ),
            ],
              )
          ));



  }

}

