
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';

import 'package:socialapp/chatfirebase/models/ChatRoomModel.dart';

import 'package:socialapp/chatfirebase/models/UserModel.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:socialapp/chatfirebase/pages/ShowChatPage.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:uuid/uuid.dart';

import 'package:video_player/video_player.dart';
import '../../chat_bubble.dart';

import '../../model/message_model.dart';
import '../../pdf_viewer/PDFViewerPage.dart';
import '../../pdf_viewer/chatvideodisplay.dart';
import '../../pdf_viewer/chewiwvideo.dart';
import '../../pdf_viewer/pdf_api.dart';
import 'ReplyMessageWidget.dart';



class ChatRoomPage extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatroom;
  final UserModel userModel;
  final User firebaseUser;

  const
  ChatRoomPage({Key? key, required this.targetUser, required this.chatroom, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late final ValueChanged<Message> onSwipedMessage;
  String? replymessage;

  @override
  void initState() {
    super.initState();
    print("budsvuds${widget.firebaseUser.displayName}");
    print("budsvuds${widget.firebaseUser.email}");
    print("theeeeeeeeeeeeeeeeeeeeeeee${widget.targetUser.fullname.toString()}");
    print("theeeeeeeeeeeeeeeeeeeeeeee${widget.chatroom.chatroomid.toString()}");

    messageController.addListener((){
      //here you have the changes of your textfield
      print("value: ${messageController.text}");
      if(messageController.text.length>0){
        setState(() {
btnenabled=true;
        });
      }else{
        setState(() {
          btnenabled=false;
        });
      }

    });
    _initialiseController();
  }

  FilePickerResult? result;
  File? docfile;
  _pickfiles()async{
    result = await FilePicker.platform.pickFiles( allowedExtensions: ['pdf'],type: FileType.custom,allowMultiple: false);

    if (result != null) {
      final path=result!.files.single.path!;
      setState(() {
      docfile =File(path);

      uploadfiles();


      });

    } else {
      // User canceled the picker
    }
  }



  TextEditingController messageController = TextEditingController();
  bool emojiShowing = false;
  bool btnenabled=false;
  bool attachmentsenabled=false;
  // void sendMessage() async {
  //   String msg = messageController.text.trim();
  //   messageController.clear();
  //
  //   if(msg != "") {
  //     // Send Message
  //     MessageModel newMessage = MessageModel(
  //         messageid: uuid.v1(),
  //         sender: widget.userModel.uid,
  //         createdon: DateTime.now(),
  //         text: msg,
  //         seen: false
  //     );
  //
  //     FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid).collection("messages").doc(newMessage.messageid).set(newMessage.toMap());
  //
  //     widget.chatroom.lastMessage = msg;
  //     FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid).set(widget.chatroom.toMap());
  //
  //     log("Message Sent!");
  //   }
  // }
  var latitude = "";
  var longitude = "";
  findlocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    if(permission==LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    latitude = position.latitude.toString();
    longitude = position.longitude.toString();
    sendlocation();
    print("the latitude is $latitude");
    print("the latitude is $longitude");


  }

  bool showdelete=false;
  File? imageFile;
  File? _video;
  final picker =ImagePicker();
   VideoPlayerController? _videoPlayerController;
 late  Future<void> _initializeVideoPlayerFuture;
  _pickvideo()async{
  await  picker.pickVideo(source: ImageSource.gallery).then((value){
      if(value!=null){
        _video=File(value.path);
        _videoPlayerController=VideoPlayerController.file(_video!)..initialize();
        _initializeVideoPlayerFuture =VideoPlayerController.file(_video!).initialize().then((_) {
          setState(() {});
        });
        //uploadvideo();

      }
    });



  }
  PlatformFile? pickeddfile;
  UploadTask? uploadTask;
  Future selecttfile()async{
    final resultt= await FilePicker.platform.pickFiles(allowMultiple: false,allowedExtensions: ['mp4'] , type: FileType.custom);
    if(resultt==null)return;
    setState(() {
      pickeddfile=resultt.files.first;
      uploaddvideo();
    });
  }
  Future uploaddvideo()async{
    String fileName = Uuid().v1();
    int status = 1;

    await _firestore
        .collection('chatrooms')
        .doc("${widget.chatroom.chatroomid}")
        .collection('users')
        .doc(fileName)
        .set({
      "sendby": widget.targetUser.uid,
      "message": "",
      "type": "video",
      "time": FieldValue.serverTimestamp(),
    });
    final file=File(pickeddfile!.path!);
    final path= '${pickeddfile!.name}';


  final ref =   FirebaseStorage.instance.ref().child("videos").child(path);

    var uploadTask = await ref.putFile(file).catchError((error) async {
      await _firestore
          .collection('chatrooms')
          .doc("${widget.chatroom.chatroomid}")
          .collection('users')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {

      String imageUrl = await uploadTask.ref.getDownloadURL();

      await _firestore
          .collection('chatrooms')
          .doc("${widget.chatroom.chatroomid}")
          .collection('users')
          .doc(fileName)
          .update({"message": imageUrl,"namevideo":pickeddfile!.name});

      print("the video url is $imageUrl");
    }





  }
  Future deleteData(String id) async{
    try {
      await  FirebaseFirestore.instance
          .collection("chatrooms")
          .doc("${widget.chatroom.chatroomid}")
          .collection("users")
          .doc(id)
          .delete();
    }catch (e){
      return false;
    }
  }
  Future getImage() async {
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  late final RecorderController recorderController;
  late final PlayerController playerController;


  void _initialiseController() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;
    playerController = PlayerController();


  }
  Future sendlocation()async{
    String fileName = Uuid().v1();
    await _firestore
        .collection('chatrooms')
        .doc("${widget.chatroom.chatroomid}")
        .collection('users')
        .doc(fileName)
        .set({
      "sendby": widget.targetUser.uid,
      "message": "",
      "type": "location",
      "time": FieldValue.serverTimestamp(),
    });
  }
// Future uploadvideo()async{
//   String fileName = Uuid().v1();
//   int status = 1;
//   await _firestore
//       .collection('chatrooms')
//       .doc("${widget.chatroom.chatroomid}")
//       .collection('users')
//       .doc(fileName)
//       .set({
//     "sendby": widget.targetUser.uid,
//     "message": "",
//     "type": "video",
//     "time": FieldValue.serverTimestamp(),
//   });
//   var ref =
//   FirebaseStorage.instance.ref().child('videos').child("$fileName.mp4");
//
//   var uploadTask = await ref.putFile(_video!).catchError((error) async {
//     await _firestore
//         .collection('chatrooms')
//         .doc("${widget.chatroom.chatroomid}")
//         .collection('users')
//         .doc(fileName)
//         .delete();
//
//     status = 0;
//   });
//
//   if (status == 1) {
//     String imageUrl = await uploadTask.ref.getDownloadURL();
//
//     await _firestore
//         .collection('chatrooms')
//         .doc("${widget.chatroom.chatroomid}")
//         .collection('users')
//         .doc(fileName)
//         .update({"message": imageUrl});
//
//     print(imageUrl);
//   }
// }

  Future uploadfiles() async {
    String fileName = Uuid().v1();
    int status = 1;

    await _firestore
        .collection('chatrooms')
        .doc("${widget.chatroom.chatroomid}")
        .collection('users')
        .doc(fileName)
        .set({
      "sendby": widget.targetUser.uid,
      "message": "",
      "type": "files",
      "time": FieldValue.serverTimestamp(),
    });

    var ref =
    FirebaseStorage.instance.ref().child('files').child("$fileName.pdf");

    var uploadTask = await ref.putFile(docfile!).catchError((error) async {
      await _firestore
          .collection('chatrooms')
          .doc("${widget.chatroom.chatroomid}")
          .collection('users')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();
      String ffileName = result!.files.first.name;


      await _firestore
          .collection('chatrooms')
          .doc("${widget.chatroom.chatroomid}")
          .collection('users')
          .doc(fileName)
          .update({"message": imageUrl,"namepdf":ffileName});
      print("the name is $ffileName");
      print("the document url is $imageUrl");
    }
  }
  Future uploadImage() async {
    String fileName = Uuid().v1();
    int status = 1;

    await _firestore
        .collection('chatrooms')
        .doc("${widget.chatroom.chatroomid}")
        .collection('users')
        .doc(fileName)
        .set({
      "sendby": widget.targetUser.uid,
      "message": "",
      "type": "img",
      "reply": replymessage,
      "time": FieldValue.serverTimestamp(),
    });

    var ref =
    FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await _firestore
          .collection('chatrooms')
          .doc("${widget.chatroom.chatroomid}")
          .collection('users')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await _firestore
          .collection('chatrooms')
          .doc("${widget.chatroom.chatroomid}")
          .collection('users')
          .doc(fileName)
          .update({"message": imageUrl});

      print(imageUrl);
    }
  }
  sendAudioMsg(String audioMsg) async {
    String fileName = Uuid().v4();
    if (audioMsg.isNotEmpty) {
      var ref = FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.chatroom.chatroomid)
          .collection("users")
          .doc(fileName);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(ref, {
          "sendby": widget.targetUser.uid,
          "message": "",
          "type": audioMsg,
          "time": FieldValue.serverTimestamp(),

        });
      }).then((value) {
        setState(() {
          isSending = false;
        });
      });
      scrollController.position.maxScrollExtent;

    } else {
      print("Hello");
    }
  }
  void onSendMessage() async {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": widget.targetUser.uid,
        "message": messageController.text,
        "type": "text",
        "reply": replymessage,
        "time": FieldValue.serverTimestamp(),
      };
      onCancelReply();

      messageController.clear();
      await _firestore
          .collection('chatrooms')
          .doc(widget.chatroom.chatroomid)
          .collection('users')
          .add(messages);
      FocusManager.instance.primaryFocus?.unfocus();
      setState(() {

      });
    } else {
      print("Enter Some Text");
    }
  }
  void replyToMessage(String message) {
    setState(() {
      replymessage=message;
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }
  void onCancelReply(){
    setState(() {
      replymessage=null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isReplying= replymessage!=null;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body:
       Column(

            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  IconButton(onPressed: (){
                 Navigator.of(context).pop(true);
                  }, icon: Icon(Icons.arrow_back_ios,size: 16,color: Theme.of(context).accentColor,)),
                  widget.targetUser.profilepic.toString()==null?Container() :   ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    child: CachedNetworkImage(imageUrl: widget.targetUser.profilepic.toString(),width:25,height:25,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Center(child: new CircularProgressIndicator()),
                      errorWidget: (context, url, error) => new Icon(Icons.person),
                    ),),
                  SizedBox(
                    width: 14,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text('${widget.targetUser.fullname}',style: TextStyle(
                          color: Theme.of(context).accentColor,fontSize: 15
                      ),),
                      Text('${widget.targetUser.status}',style: TextStyle(
                          color: Theme.of(context).accentColor,fontSize: 15
                      ),),
                    ],
                  ),




                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(onPressed: (){}, icon:  Icon(Icons.more_vert,color: Theme.of(context).accentColor,)),

                        ],
                      ),
                    ),
                  )
                ],
              ),
              // This is where the chats will go
              Divider(
                color: Colors.grey.withOpacity(0.8),
                height: 20,
              ),

              Expanded(
                child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10
                    ),
                    child:
                    Container(
                      height: size.height / 1.25,
                      width: size.width,

                      child: StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('chatrooms')
                            .doc(widget.chatroom.chatroomid)
                            .collection('users')
                            .orderBy("time", descending: false)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.data != null) {
                            return ListView.builder(
                              controller: scrollController,

                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {

                                Map<String, dynamic> map = snapshot.data!.docs[index]
                                    .data() as Map<String, dynamic>;
                                return SwipeTo(
                                    // onRightSwipe: (){
                                    //
                                    //   replyToMessage(map['message']);
                                    //
                                    //
                                    // },
                                    child: map["time"]!=null?messages(size, map, context,snapshot.data!.docs[index].id):Container());
                              },
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),

                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child:    Column(
                  children: [
                    attachmentsenabled==true?
                    Padding(
                      padding: EdgeInsets.only(right: 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.85,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Color.fromRGBO(189, 42, 26, 1),
                        ),
                        child: Padding(
                          padding:  EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                  onTap: (){
                                    selecttfile();
                                    setState(() {
                                      attachmentsenabled=false;
                                    });
                                  },
                                  child: SvgPicture.asset('asset/images/secndchatt.svg',width: 15,height: 20,fit: BoxFit.scaleDown,)),
                              GestureDetector(onTap:(){
                                setState(() {
                                  attachmentsenabled=false;
                                });
                                _pickfiles();
                              },child: SvgPicture.asset('asset/images/firstchatt.svg',width: 15,height: 20,fit: BoxFit.scaleDown,)),
                              GestureDetector(
                                  onTap: (){
                                    findlocation();
                                    setState(() {
                                      attachmentsenabled=false;
                                    });
                                  },
                                  child: SvgPicture.asset('asset/images/thrdchat.svg',width: 15,height: 20,fit: BoxFit.scaleDown,)),
                              SvgPicture.asset('asset/images/lastchat.svg',width: 15,height: 20,fit: BoxFit.scaleDown,),





                            ],
                          ),
                        ),
                      ),
                    ):(  attachmentsenabled==false)?Container():Container(),

                    Column(
                      children: [
                        if(isReplying)buildReply(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Container(
                            height: 70,
                            child:
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // isRecording?AudioWaveforms(
                                    //   enableGesture: true,
                                    //   size: Size(MediaQuery.of(context).size.width / 2, 50),
                                    //   recorderController: recorderController,
                                    //   waveStyle: const WaveStyle(
                                    //     waveColor: Theme.of(context).accentColor,
                                    //     extendWaveform: true,
                                    //     showMiddleLine: false,
                                    //   ),
                                    //   decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(12.0),
                                    //     color: const Color(0xFF1E1B26),
                                    //   ),
                                    //   padding: const EdgeInsets.only(left: 18),
                                    //   margin: const EdgeInsets.symmetric(horizontal: 15),
                                    // ):
                                    isRecording?AudioWaveforms(
                                      enableGesture: true,
                                      size: Size(MediaQuery.of(context).size.width / 2, 50),
                                      recorderController: recorderController,
                                      waveStyle:  WaveStyle(
                                        waveColor:Theme.of(context).accentColor,
                                        extendWaveform: true,
                                        showMiddleLine: false,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12.0),
                                        color: const Color(0xFF1E1B26),
                                      ),
                                      padding: const EdgeInsets.only(left: 18),
                                      margin: const EdgeInsets.symmetric(horizontal: 15),
                                    ):   Container(
                                      height: size.height / 17,
                                      width: size.width / 1.3,

                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(49, 49, 49, 1),
                                        borderRadius: BorderRadius.circular(35.0),

                                      ),
                                      child:

                                      TextField(
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 5,

                                        cursorColor: Theme.of(context).accentColor,
                                        style: TextStyle(

                                            color: Theme.of(context).accentColor
                                        ),
                                        focusNode: _focusNode,
                                        onTap: (){
                                          setState((){
                                            emojiShowing=false;
                                          });

                                        },
                                        controller: messageController,
                                        decoration: InputDecoration(
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            contentPadding: EdgeInsetsDirectional.only(start: 2.0,top: 10.0),
                                            prefixIcon:  GestureDetector(
                                              onTap: (){
                                                setState(() {

                                                  emojiShowing = !emojiShowing;
                                                  if(emojiShowing){
                                                    _focusNode.unfocus();
                                                  }
                                                  else{
                                                    FocusScope.of(context).requestFocus(_focusNode);
                                                  }
                                                });
                                              },
                                              child: SvgPicture.asset(
                                                "asset/images/emojiicon.svg",
                                                height: 12,
                                                width: 12,
                                                fit: BoxFit.scaleDown,


                                              ),
                                            ),

                                            suffixIcon: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                                              mainAxisSize: MainAxisSize.min,
                                              children: [

                                                btnenabled==true?Container():   GestureDetector(
                                                  onTap: (){
                                                    getImage();

                                                  },
                                                  child: SvgPicture.asset(
                                                    "asset/images/camerachat.svg",
                                                    height: 20,
                                                    width: 20,
                                                    fit: BoxFit.scaleDown,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.add_circle_outline,color: Colors.grey,), onPressed: () {
                                                  setState((){
                                                    attachmentsenabled = !attachmentsenabled;
                                                    print("the value of attachment is $attachmentsenabled");
                                                  });

                                                  print("hiee iam clicked");
                                                },
                                                ),
                                              ],
                                            ),
                                            hintText: "Type a message...",
                                            hintStyle: TextStyle(
                                                color: Theme.of(context).accentColor
                                            )
                                        ),
                                      ),
                                    ),

                                    btnenabled==true?Container(
                                      width: 40,
                                      height: 40,
                                      child: ElevatedButton(
                                          onPressed: (){
                                            scrollController.animateTo(scrollController.position.maxScrollExtent,
                                                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                                            onSendMessage();

                                          },

                                          style: ElevatedButton.styleFrom(

                                            shape: CircleBorder(),
                                            padding: EdgeInsets.all( 8),
                                            backgroundColor: Color.fromRGBO(49, 49, 49, 1),

                                          ),
                                          child: Center(child: Icon(Icons.send,color: Colors.white,size: 16,))),
                                    ):
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Color.fromRGBO(49, 49, 49, 1), shape: BoxShape.circle),
                                      child: GestureDetector(
                                        onLongPress: (){
                                          startRecord();

                                          setState(() {
                                            HapticFeedback.vibrate();
                                            isRecording = true;
                                          });

                                        },
                                        onLongPressEnd: (details) {
                                          stopRecord();
                                          setState(() {
                                            isRecording = false;
                                          });
                                        },


                                        child: SvgPicture.asset(
                                          "asset/images/auidochat.svg",
                                          height: 20,
                                          width: 20,
                                          fit: BoxFit.scaleDown,


                                        ),
                                      ),
                                    )

                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Container(
              //
              //   height: size.height / 10,
              //   width: size.width,
              //   alignment: Alignment.center,
              //   child: Container(
              //     height: size.height / 12,
              //     width: size.width,
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         isRecording?AudioWaveforms(
              //           enableGesture: true,
              //           size: Size(MediaQuery.of(context).size.width / 2, 50),
              //           recorderController: recorderController,
              //           waveStyle: const WaveStyle(
              //             waveColor: Colors.white,
              //             extendWaveform: true,
              //             showMiddleLine: false,
              //           ),
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(12.0),
              //             color: const Color(0xFF1E1B26),
              //           ),
              //           padding: const EdgeInsets.only(left: 18),
              //           margin: const EdgeInsets.symmetric(horizontal: 15),
              //         ):
              //         Container(
              //           height: size.height / 17,
              //           width: size.width / 1.3,
              //
              //           decoration: BoxDecoration(
              //             color: Color.fromRGBO(49, 49, 49, 1),
              //             borderRadius: BorderRadius.circular(35.0),
              //
              //           ),
              //           child:
              //
              //          TextField(
              //            cursorColor: Colors.white,
              //             style: TextStyle(
              //               color: Colors.white
              //             ),
              //             focusNode: _focusNode,
              //             onTap: (){
              //               setState((){
              //                 emojiShowing=false;
              //               });
              //
              //             },
              //             controller: messageController,
              //             decoration: InputDecoration(
              //                 focusedBorder: InputBorder.none,
              //                 enabledBorder: InputBorder.none,
              //                 contentPadding: EdgeInsetsDirectional.only(start: 2.0,top: 10.0),
              //               prefixIcon:  GestureDetector(
              //                 onTap: (){
              //                   setState(() {
              //                     emojiShowing = !emojiShowing;
              //                     if(emojiShowing){
              //                       _focusNode.unfocus();
              //                     }
              //                     else{
              //                       FocusScope.of(context).requestFocus(_focusNode);
              //                     }
              //                   });
              //                 },
              //                 child: SvgPicture.asset(
              //                   "asset/images/emojiicon.svg",
              //                   height: 12,
              //                   width: 12,
              //                   fit: BoxFit.scaleDown,
              //
              //
              //                 ),
              //               ),
              //
              //                 suffixIcon: Row(
              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
              //                   mainAxisSize: MainAxisSize.min,
              //                   children: [
              //
              //                     GestureDetector(
              //                       onTap: (){
              //                         getImage();
              //
              //                       },
              //                       child: SvgPicture.asset(
              //                         "asset/images/camerachat.svg",
              //                         height: 20,
              //                         width: 20,
              //                         fit: BoxFit.scaleDown,
              //                       ),
              //                     ),
              //                     IconButton(
              //                       icon: Icon(Icons.add_circle_outline,color: Colors.grey,), onPressed: () {
              //                         setState((){
              //                           attachmentsenabled = !attachmentsenabled;
              //                           print("the value of attachment is $attachmentsenabled");
              //                         });
              //
              //                         print("hiee iam clicked");
              //                     },
              //                     ),
              //                   ],
              //                 ),
              //                 hintText: "Type a message...",
              //               hintStyle: TextStyle(
              //                 color: Colors.white
              //               )
              //                ),
              //           ),
              //         ),
              //
              //         btnenabled==true?Container(
              //           width: 40,
              //           height: 40,
              //           child: ElevatedButton(
              //               onPressed: (){
              //                 onSendMessage();
              //
              //               },
              //
              //               style: ElevatedButton.styleFrom(
              //
              //                 shape: CircleBorder(),
              //                 padding: EdgeInsets.all( 8),
              //                 backgroundColor: Color.fromRGBO(49, 49, 49, 1),
              //
              //               ),
              //               child: Center(child: Icon(Icons.send,color: Colors.white,size: 16,))),
              //         ):
              //         Container(
              //           width: 40,
              //           height: 40,
              //           decoration: BoxDecoration(
              //               color: Color.fromRGBO(49, 49, 49, 1), shape: BoxShape.circle),
              //               child: GestureDetector(
              //           onLongPress: (){
              //               startRecord();
              //
              //               setState(() {
              //               HapticFeedback.vibrate();
              //                 isRecording = true;
              //               });
              //
              //           },
              //           onLongPressEnd: (details) {
              //               stopRecord();
              //               setState(() {
              //                 isRecording = false;
              //               });
              //           },
              //
              //
              //                 child: SvgPicture.asset(
              //           "asset/images/auidochat.svg",
              //           height: 20,
              //           width: 20,
              //           fit: BoxFit.scaleDown,
              //
              //
              //         ),
              //               ),
              //             )
              //
              //       ],
              //     ),
              //   ),
              // ),
              Offstage(
                offstage: !emojiShowing,
                child: SizedBox(
                    height: 250,

                    child: EmojiPicker(
                      textEditingController: messageController,
                      config: Config(
                        columns: 7,
                        // Issue: https://github.com/flutter/flutter/issues/28894
                        emojiSizeMax: 32 *
                            (foundation.defaultTargetPlatform ==
                                TargetPlatform.iOS
                                ? 1.30
                                : 1.0),
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        gridPadding: EdgeInsets.zero,
                        initCategory: Category.RECENT,
                        bgColor: const Color(0xFFF2F2F2),
                        indicatorColor: Colors.blue,
                        iconColor: Colors.grey,
                        iconColorSelected: Colors.blue,
                        backspaceColor: Colors.blue,
                        skinToneDialogBgColor: Colors.white,
                        skinToneIndicatorColor: Colors.grey,
                        enableSkinTones: true,
                        showRecentsTab: true,
                        recentsLimit: 28,
                        replaceEmojiOnLimitExceed: false,
                        noRecents: const Text(
                          'No Recents',
                          style: TextStyle(fontSize: 20, color: Colors.black26),
                          textAlign: TextAlign.center,
                        ),
                        loadingIndicator: const SizedBox.shrink(),
                        tabIndicatorAnimDuration: kTabScrollDuration,
                        categoryIcons: const CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL,
                        checkPlatformCompatibility: true,
                      ),
                    )),
              ),

            ],
          ),

      ),
    );
  }
  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }
  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_${i++}.mp3";
  }
  String recordFilePath="";

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      recordFilePath = await getFilePath();
      await recorderController.record(path: recordFilePath);
      RecordMp3.instance.start(recordFilePath, (type) {

        setState(() {});
      });
    } else {}
    setState(() {});
  }

  void stopRecord() async {
    bool s = RecordMp3.instance.stop();
    if (s) {
      setState(() {
        isSending = true;
      });
      await uploadAudio();

      setState(() {
        isPlayingMsg = false;
      });
    }
  }
  int? selectedIndex;
  Future<void> play() async {
    if (recordFilePath != null && File(recordFilePath).existsSync()) {
      AudioPlayer audioPlayer = AudioPlayer();
      await audioPlayer.play(
        UrlSource(recordFilePath)

      );
      audioPlayer.onPlayerComplete.listen((duration) {
        setState(() {
          selectedIndex = -1;
        });
      });

    }
  }
  ScrollController scrollController = ScrollController();
  bool isPlayingMsg = false, isRecording = false, isSending = false;



  uploadAudio() {
    final Reference  firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child(
        'profilepics/audio${DateTime.now().millisecondsSinceEpoch.toString()}}.jpg');

    UploadTask  task = firebaseStorageRef.putFile(File(recordFilePath));
    task.whenComplete(() {

    }).then((value) async {
      print('##############done#########');
      var audioURL = await value.ref.getDownloadURL();
      String strVal = audioURL.toString();
      print("the audio is $strVal");
      await sendAudioMsg(strVal);
    }).catchError((e) {
      print(e);
    });
  }
  Future _loadFile(String url) async {
    final bytes = await readBytes(Uri.parse(url));
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/audio.mp3');

    await file.writeAsBytes(bytes);
    if (await file.exists()) {
      setState(() {
        recordFilePath = file.path;

        isPlayingMsg = true;
        print("music is pla $isPlayingMsg");
      });
      await play();

      setState(() {
        isPlayingMsg = false;
        print("music not pla $isPlayingMsg");
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    recorderController.dispose();
    _videoPlayerController!.dispose();
    playerController.dispose();
  }
  final _focusNode = FocusNode();
  Widget messages(Size size, Map<String, dynamic> map, BuildContext context,String idd) {
    Timestamp t= map["time"] as Timestamp;

    DateFormat("h:mm a").format(t.toDate());
    return map['type'] == "text"
        ?
    GestureDetector(
      onLongPress: (){
        map['sendby'] == widget.targetUser.uid?    showDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                content: Text('Are you sure you want to delete?'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('No')),
                  TextButton(
                    onPressed: () {
                      deleteData("$idd");


                      Navigator.pop(context);
                    },
                    child: Text('Yes'),
                  )
                ],
              );
            }):null;

      },
      child: Row(

            children: [
              map['sendby'] == widget.targetUser.uid  ?Row(

                mainAxisAlignment: map['sendby'] == widget.targetUser.uid?MainAxisAlignment.spaceAround:MainAxisAlignment.spaceAround ,
                children: [
                  Container(
                    child: Text(
                    t!=null?  DateFormat("h:mma").format(t.toDate()):'',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ):Container(),
              Expanded(
                child: Row(
                  mainAxisAlignment:map['sendby'] == widget.targetUser.uid?MainAxisAlignment.end:MainAxisAlignment.start ,
                  children: [
                    Container(
                            constraints:  BoxConstraints(
                              maxWidth: size.width*0.65,

                            ),
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                                colors:  (map['sendby'] == widget.targetUser.uid) ? [Colors.grey ,Colors.grey]: [Color.fromRGBO(64, 123, 185, 1),Color.fromRGBO(36, 171, 151, 1)]
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: map['sendby'] == widget.targetUser.uid?Radius.circular(20.0):Radius.circular(20.0),
                              topLeft:map['sendby'] == widget.targetUser.uid? Radius.circular(0.0):Radius.circular(20.0),
                              topRight:  Radius.circular(20.0),
                              bottomRight: map['sendby'] == widget.targetUser.uid?Radius.circular(20.0):Radius.circular(0.0),
                            ),
                            color: Colors.white,
                          ),
                          child:  map['reply']==null ?
                          Column(
                            children: [
                              Text(
                                map['message'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ):
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [


                              Container(


                                margin: EdgeInsets.only(bottom: 8),

                                child: ReplyMessageWidget(message: map['reply'], onCancelReply: () {
                                  onCancelReply();
                                }

                                ),
                              ),
                              SizedBox(
                                height: size.height / 200,
                              ),
                             Text(
                                map['message'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                    ),
                  ],
                ),
              ),
              map['sendby'] == widget.targetUser.uid ?Container():Row(

                mainAxisAlignment: map['sendby'] == widget.targetUser.uid?MainAxisAlignment.spaceEvenly:MainAxisAlignment.spaceEvenly ,
                children: [
                  Container(
                    child: Text(
                      t!=null?    DateFormat("h:mma").format(t.toDate()):'',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
    ):(map['type'] == "img")?
    GestureDetector(
      onLongPress: (){
        map['sendby'] == widget.targetUser.uid?    showDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                content: Text('Are you sure you want to delete?'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('No')),
                  TextButton(
                    onPressed: () {
                      deleteData("$idd");
                      Navigator.pop(context);
                    },
                    child: Text('Yes'),
                  )
                ],
              );
            }):null;

      },
      child: Row(
        children: [
          map['sendby'] == widget.targetUser.uid  ?Row(

            mainAxisAlignment: map['sendby'] == widget.targetUser.uid?MainAxisAlignment.spaceAround:MainAxisAlignment.spaceAround ,
            children: [
              Container(
                child: Text(
                  t!=null?  DateFormat("h:mma").format(t.toDate()):'',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ):Container(),
          Expanded(
            child: Row(
              mainAxisAlignment:map['sendby'] == widget.targetUser.uid?MainAxisAlignment.end:MainAxisAlignment.start ,
              children: [
                Container(
                    constraints:  BoxConstraints(
                      maxWidth: size.width*0.65,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors:  (map['sendby'] == widget.targetUser.uid) ? [Colors.grey ,Colors.grey]: [Color.fromRGBO(64, 123, 185, 1),Color.fromRGBO(36, 171, 151, 1)]
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: map['sendby'] == widget.targetUser.uid?Radius.circular(20.0):Radius.circular(20.0),
                        topLeft:map['sendby'] == widget.targetUser.uid? Radius.circular(0.0):Radius.circular(20.0),
                        topRight:  Radius.circular(20.0),
                        bottomRight: map['sendby'] == widget.targetUser.uid?Radius.circular(20.0):Radius.circular(0.0),
                      ),
                      color: Colors.white,
                    ),
                    child:  map['reply']==null ?
                    Column(
                      children: [
                       InkWell(
                        onTap: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ShowImage(
                                  imageUrl: map['message'],
                                ),
                              )
                          );
                        },
                         child: Container(
                            height: 300,
                            width:MediaQuery.of(context).size.width*0.65,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.blue.shade400

                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: map['message'] != ""
                                  ? Image.network(
                                map['message'],
                               fit: BoxFit.cover,
                              ):CircularProgressIndicator(),
                            ),
                          ),
                       )
                      ],
                    ):
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [


                        Container(


                          margin: EdgeInsets.only(bottom: 8),

                          child: ReplyMessageWidget(message: map['reply'], onCancelReply: () {
                            onCancelReply();
                          }

                          ),
                        ),
                        SizedBox(
                          height: size.height / 200,
                        ),


                        Text(
                          map['message'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                ),
              ],
            ),
          ),

        ],
      ),
    )


        :(map['type'] == "video")?
    GestureDetector(
      onLongPress: (){
        map['sendby'] == widget.targetUser.uid?    showDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                content: Text('Are you sure you want to delete?'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('No')),
                  TextButton(
                    onPressed: () {
                      deleteData("$idd");


                      Navigator.pop(context);
                    },
                    child: Text('Yes'),
                  )
                ],
              );
            }):null;

      },
      child: Container(
        width: size.width,
        margin: EdgeInsets.all(6.0),
        alignment: map['sendby'] == widget.targetUser.uid
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child:
        InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ChewieDemo(url: '${map['message']}',

              ),
            ),
          ),
          child: Container(
            height: 200,
            width:MediaQuery.of(context).size.width*0.65,

            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blue.shade400

            ),
            alignment: map['message'] != "" ? null : Alignment.center,
            child: map['message'] != ""
                ? Stack(
                  children: [
                    Container(
                      height: 200,
                      width:MediaQuery.of(context).size.width*0.65,
                      child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child:Center(child: Text('${map['namevideo']}'),)

            ),
                    ),
                  ],
                )
                : CircularProgressIndicator(),
          ),
        ),
      ),
    ):(map['type'] == "files")?
    GestureDetector(
      onLongPress: (){
        map['sendby'] == widget.targetUser.uid?    showDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                content: Text('Are you sure you want to delete?'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('No')),
                  TextButton(
                    onPressed: () {
                      deleteData("$idd");


                      Navigator.pop(context);
                    },
                    child: Text('Yes'),
                  )
                ],
              );
            }):null;

      },
      child: Container(
        width: size.width,
        margin: EdgeInsets.all(6.0),
        alignment: map['sendby'] == widget.targetUser.uid
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child:
        Container(
          height: 100,
          width:MediaQuery.of(context).size.width*0.65,

          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.blue.shade400

          ),
          alignment: map['message'] != "" ? null : Alignment.center,
          child: map['message'] != ""
              ? ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: InkWell(
                onTap: () {

                  print("hvhhyg${ map['message']}");
                  ApiServiceProvider.loadpdf(map['message']).then((value) {
                    setState(() {
                      localPath = value;
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => PDFViewerPage(localpath: '$localPath',)),
                      );
                    });
                  });


                },
                child: Center(child: Text( map['namepdf'],))),
          )
              : CircularProgressIndicator(),
        ),
      ),
    ):

    GestureDetector(
      onLongPress: (){
        map['sendby'] == widget.targetUser.uid?    showDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                content: Text('Are you sure you want to delete?'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('No')),
                  TextButton(
                    onPressed: () {
                      deleteData("$idd");


                      Navigator.pop(context);
                    },
                    child: Text('Yes'),
                  )
                ],
              );
            }):null;

      },
      child: Padding(
        padding: EdgeInsets.only(
          top: 8,
          left: ((map['sendby'] == widget.targetUser.uid) ? 64 : 10),
          right: ((map['sendby'] == widget.targetUser.uid ? 10 : 64)),
        ),
        child:

        WaveBubble(

          playerController: playerController,
          isPlaying: playerController.playerState ==isPlayingMsg,


          onTap: ()async{
            playerController.playerState == isPlayingMsg
                ? await playerController.pausePlayer()
                : _loadFile(map['type']);

          },
          isSender: false,
        ),


        // Container(
        //   width: MediaQuery.of(context).size.width * 0.5,
        //   padding: EdgeInsets.all(8),
        //   decoration: BoxDecoration(
        //     color: (map['sendby'] == widget.targetUser.uid)
        //         ? Colors.greenAccent
        //         : Colors.orangeAccent,
        //     borderRadius: BorderRadius.circular(10),
        //   ),
        //   child: GestureDetector(
        //       onTap: () {
        //         _loadFile(map['type']);
        //       },
        //       onSecondaryTap: () {
        //         stopRecord();
        //       },
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         crossAxisAlignment: CrossAxisAlignment.end,
        //         children: [
        //           Row(
        //             children: [
        //               Icon(isPlayingMsg ? Icons.pause : Icons.play_arrow),
        //
        //             ],
        //           ),
        //
        //         ],
        //       )),
        // ),
      ),
    );
  }

  void _playOrPlausePlayer(PlayerController controller) async {
    controller.playerState == isPlayingMsg
        ? await controller.pausePlayer()
        : await controller.startPlayer(finishMode: FinishMode.loop);
  }
  Widget buildReply(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.08),
          child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width*0.4
            ),

            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.all(Radius.circular(6))
            ),
            child: ReplyMessageWidget(message: replymessage!, onCancelReply: () {
              onCancelReply();
            }

            ),
          ),
        ),
      ],
    );
  }


  String localPath="";
}
class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}