import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Chattttt extends StatefulWidget {
  const Chattttt({Key? key}) : super(key: key);

  @override
  State<Chattttt> createState() => _ChatttttState();
}

class _ChatttttState extends State<Chattttt> {
  bool _showBottom=false;
  final chat=TextEditingController();
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
               }, icon: Icon(Icons.arrow_back_ios,size: 16,color: Colors.white,)),
               CircleAvatar(
                 backgroundColor: Colors.red,
                 radius: 30,
                 child: Image.asset("asset/images/apple.png"),
               ) ,
               SizedBox(
                 width: 14,
               ),
               Column(

                 children: [
                   Text('Vikram Bhandari',style: TextStyle(
                       color: Colors.white,fontSize: 15
                   ),),
                   Text('Active 45 m ago',style: TextStyle(
                       color: Colors.white,fontSize: 15
                   ),),
                 ],
               ),

                   Expanded(
                     child: Padding(
                       padding: EdgeInsets.only(bottom: 10.0),
                       child: Column(
                       crossAxisAlignment: CrossAxisAlignment.end,
                       children: [
                         IconButton(onPressed: (){}, icon:  Icon(Icons.more_vert,color: Colors.white,)),
                       ],
                     ),
                     ),
                   )
             ],
           ),
            Divider(
              color: Colors.grey.withOpacity(0.8),
              height: 20,
            ),
            Expanded(child: ListView.builder(
              itemCount: 20,
                itemBuilder: (ctx,i){
                return Column(
                  children: [
                    Padding(
                      padding:EdgeInsets.symmetric(vertical:10,horizontal: 30),
                      child: Row(
                      mainAxisAlignment:  i%2==0? MainAxisAlignment.end:MainAxisAlignment.start,
                        children: [
                        Flexible(
                          child: Container(
                            constraints: BoxConstraints.loose(Size(
                                200.0, 450.0
                            )),
                            decoration: BoxDecoration(
                              color: i%2==0?Colors.blue.withOpacity(0.6): Colors.grey,
                              borderRadius: BorderRadius.only(
                                bottomLeft: i%2==0?Radius.circular(20.0):Radius.circular(20.0),
                                topLeft:i%2==0? Radius.circular(20.0):Radius.circular(0.0),
                                topRight:  Radius.circular(20.0),
                                bottomRight: i%2==0?Radius.circular(0.0):Radius.circular(20.0),
                              ),

                            ),
                            child: Padding(
                              padding: EdgeInsets.all(13.0),
                              child:i%2==0? Text('Lets go on vacation. i have excited plans!',  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 50, style: TextStyle(
                                fontSize: 14,color: Colors.white,
                              ),):Text('Sed ut perspiciatis unde',  softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 50, style: TextStyle(
                                  fontSize: 14,color: Colors.white,
                                ),)
                            ),
                          ),
                        )
                        ],
                      ),
                    )
                  ],
                );
            })),
            Container(

              margin: EdgeInsets.all(4.0),
              height: 61,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35.0),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 3),
                              blurRadius: 5,
                              color: Colors.grey)
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.face), onPressed: () {}),
                          Expanded(
                            child: TextField(
                              controller:chat ,
                              decoration: InputDecoration(
                                  hintText: "Type Something...",
                                  border: InputBorder.none),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.photo_camera),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.attach_file),
                            onPressed: () {},
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        color: Colors.redAccent, shape: BoxShape.circle),
                    child: InkWell(
                      child: Icon(
                      chat.text.toString()==""?  Icons.keyboard_voice:Icons.send,
                        color: Colors.white,
                      ),
                      onLongPress: () {
                        setState(() {
                          _showBottom = true;
                        });
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    chat.addListener(() {
      setState(() {

      });
    });
  }
}
