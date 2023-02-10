import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../chatfirebase/models/UserModel.dart';
import 'Chatpage2.dart';

class chatpage extends StatefulWidget {
  final UserModel targetUser;
   chatpage({Key? key,required this.targetUser}) : super(key: key);

  @override
  State<chatpage> createState() => _chatpageState();
}

class _chatpageState extends State<chatpage> {
  TextEditingController editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff161730),
  body: Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            IconButton(onPressed: (){
              Get.back();
            }, icon:Icon(Icons.arrow_back_ios,color: Colors.white,)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0,left: 8.0,right: 15.0,bottom: 15.0),
                child: SizedBox(
                  height: 40,
                  child: TextField(

                    onChanged: (value) {
                      setState(() {});
                    },
                    controller: editingController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        hintText: "Search",
                        hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5)
                        ),
                        prefixIcon: Icon(Icons.search,color: Colors.white.withOpacity(0.5),),
                        enabledBorder: const OutlineInputBorder(
                          // width: 0.0 produces a thin "hairline" border
                          borderSide: const BorderSide(color: Colors.white, width: 0.0),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white, width: 0.0),

                            borderRadius: BorderRadius.only(topRight: Radius.circular(15.0),
                                topLeft:Radius.circular(15.0),bottomRight: Radius.circular(15.0),bottomLeft: Radius.circular(15.0) ))),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height*0.05,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(padding: EdgeInsets.only(left: 12.0),child:
            Text('New message',style: TextStyle(
                color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold
            ),),)

          ],
        ),
        SizedBox(
          height: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10,right: 10),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey
                ),

                width: MediaQuery.of(context).size.width*0.9,
                child: TextButton(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Create a group chat', style: TextStyle(fontSize: 16)),
                            Icon(Icons.arrow_circle_down_rounded,size: 16,)

                          ],
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(16)),
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.5)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                             ))),
                    onPressed: () {}),
              ),
            ),
          ],
        ),
        Expanded(
            child: GestureDetector(
              onTap: (){
                Get.to(Chattttt());
              },
              child: ListView.separated(
          physics: BouncingScrollPhysics(),
          itemCount: 20,
              itemBuilder: (context,i){
          return Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10,right: 10),
                  child: Row(
                    children: [
                      // FullScreen(
                      //   child: Container(
                      //     width: 50,
                      //     height: 50,
                      //     decoration: BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       image: DecorationImage(
                      //           image: AssetImage('asset/images/img.png'),
                      //           fit: BoxFit.fill
                      //       ),
                      //     ),
                      //   ),
                      // ) ,
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('Vikram Bhandari',style: TextStyle(
                              color: Colors.white,fontSize: 16
                            ),),
                            Text('bhandari',style: TextStyle(
                                color: Colors.white,fontSize: 16
                            ),),
                          ],
                        ),
                      ),

                    ],
                  ),
                )

              ],
          );
        }, separatorBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  SizedBox(
                    height:8
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey.withOpacity(0.8),
                  ),
                ],
              );
        },),
            ))


      ],
  ),
      ),
    );
  }
}
