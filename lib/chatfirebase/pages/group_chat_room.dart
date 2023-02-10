
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart' as foundation;
import '../../chat_bubble.dart';
import 'package:intl/intl.dart';
import '../../model/message_model.dart';
import '../../pdf_viewer/PDFViewerPage.dart';
import '../../pdf_viewer/pdf_api.dart';
import '../models/UserModel.dart';
import 'ReplyMessageWidget.dart';
import 'group_info.dart';

class GroupChatRoom extends StatefulWidget {
  final String groupChatId, groupName;
final   UserModel targetUser;

    GroupChatRoom({required this.groupName, required this.groupChatId,required this.targetUser, Key? key})
      : super(key: key);

  @override
  State<GroupChatRoom> createState() => _GroupChatRoomState();
}

class _GroupChatRoomState extends State<GroupChatRoom> {
  final TextEditingController _message = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  ScrollController scrollController=ScrollController();
  @override
  void initState() {
    super.initState();
    _initialiseController();
    print("displayname is ${widget.targetUser.fullname}");
    print("id is ${widget.groupChatId}");
    print("id is ${widget.groupName}");
    print("id is ${thenaa}");
    setname();
    getname();
    _message.addListener((){
      //here you have the changes of your textfield
      print("value: ${_message.text}");
      if(_message.text.length>0){
        setState(() {
          btnenabled=true;
        });
      }else{
        setState(() {
          btnenabled=false;
        });
      }

    });
  }
  File? imageFile;
  Future getImage() async {
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }
  void setname()async{
    final prefs=await SharedPreferences.getInstance();
    String x=prefs.setString("namee", widget.targetUser.fullname!).toString();

  }
  String thenaa="";
  void getname() async{
    final prefs=await SharedPreferences.getInstance();
    String x=prefs.getString("namee").toString();
    setState(() {
      thenaa=x;
    });
    print("the name is $thenaa");
  }
  Future deleteData(String id) async{
    try {
      await  FirebaseFirestore.instance
          .collection("groups")
          .doc("${widget.groupChatId}")
          .collection("chats")
          .doc(id)
          .delete();
    }catch (e){
      return false;
    }
  }
  Future uploadImage() async {
    String fileName = Uuid().v1();
    int status = 1;

    await _firestore
        .collection('groups')
        .doc("${widget.groupChatId}")
        .collection('chats')
        .doc(fileName)
        .set({
      "sendby": thenaa,
      "message": "",
      "type": "img",
      "reply":replymessage,
      "time": FieldValue.serverTimestamp(),
    });
    onCancelReply();

    var ref =
    FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await _firestore
          .collection('groups')
          .doc("${widget.groupChatId}")
          .collection('chats')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await _firestore
          .collection('groups')
          .doc("${widget.groupChatId}")
          .collection('chats')
          .doc(fileName)
          .update({"message": imageUrl});

      print(imageUrl);
    }
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
  Future uploadfiles() async {
    String fileName = Uuid().v1();
    int status = 1;

    await _firestore
        .collection('groups')
        .doc("${widget.groupChatId}")
        .collection('chats')
        .doc(fileName)
        .set({
      "sendby": thenaa,
      "message": "",
      "type": "files",
      "time": FieldValue.serverTimestamp(),
    });

    var ref =
    FirebaseStorage.instance.ref().child('files').child("$fileName.pdf");

    var uploadTask = await ref.putFile(docfile!).catchError((error) async {
      await _firestore
          .collection('groups')
          .doc("${widget.groupChatId}")
          .collection('chats')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();
      String ffileName = result!.files.first.name;


      await _firestore
          .collection('groups')
          .doc("${widget.groupChatId}")
          .collection('chats')
          .doc(fileName)
          .update({"message": imageUrl,"namepdf":ffileName});
      print("the name is $ffileName");
      print("the document url is $imageUrl");
    }
  }
  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> chatData = {
        "sendby": thenaa,
        "message": _message.text,
        "type": "text",
        "reply": replymessage,
        "time": FieldValue.serverTimestamp(),
      };
      onCancelReply();
      _message.clear();
      print("messAGE is ${widget.targetUser.fullname}");

      await _firestore
          .collection('groups')
          .doc(widget.groupChatId)
          .collection('chats')
          .add(chatData);

    }
  }
  sendAudioMsg(String audioMsg) async {
    String fileName = Uuid().v4();
    if (audioMsg.isNotEmpty) {
      var ref = FirebaseFirestore.instance
          .collection('groups')
          .doc("${widget.groupChatId}")
          .collection("chats")
          .doc(fileName);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(ref, {
          "sendby":thenaa,
          "message": "",
          "type": audioMsg,
          "time": FieldValue.serverTimestamp(),

        });
      }).then((value) {
        setState(() {
          isSending = false;
        });
      });
   //   scrollController.position.maxScrollExtent;

    } else {
      print("Hello");
    }
  }

  bool emojiShowing = false;
  bool btnenabled=false;
  bool attachmentsenabled=false;
  final _focusNode = FocusNode();
   late final ValueChanged<Message> onSwipedMessage;
  String? replymessage;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final isReplying= replymessage!=null;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        // appBar: AppBar(
        //   title: Text(widget.groupName),
        //   actions: [
        //     IconButton(
        //         onPressed: () => Navigator.of(context).push(
        //           MaterialPageRoute(
        //             builder: (_) => GroupInfo(
        //               groupName: widget.groupName,
        //               groupId: widget.groupChatId,
        //             ),
        //           ),
        //         ),
        //         icon: Icon(Icons.more_vert)),
        //   ],
        // ),
        body: Container(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: (){Navigator.of(context).pop();},
                      icon: Icon(Icons.arrow_back_ios,color: Theme.of(context).accentColor,size: 14,)),
                  Text(widget.groupName,style: TextStyle(
                      color: Theme.of(context).accentColor,fontSize: 18
                  ),),
                  IconButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => GroupInfo(
                            groupName: widget.groupName,
                            groupId: widget.groupChatId,
                          ),
                        ),
                      ),
                      icon: Icon(Icons.more_vert,color: Theme.of(context).accentColor,)),
                ],
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('groups')
                      .doc(widget.groupChatId)
                      .collection('chats')
                      .orderBy('time')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        controller: scrollController,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> chatMap =
                          snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;

                          return SwipeTo(
                            onRightSwipe: (){

                                  replyToMessage(chatMap['message']);


                            },
                              child:  chatMap["time"]!=null?messageTile(size, chatMap, idd: '${snapshot.data!.docs[index].id}'):Container());
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child:
                Column(
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
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                  onTap: (){
                                    // selecttfile();
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
                                    // findlocation();
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
                                        controller: _message,
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
              Offstage(
                offstage: !emojiShowing,
                child: SizedBox(
                    height: 250,

                    child: EmojiPicker(
                      textEditingController:_message,
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

              // Container(
              //
              //   height: size.height / 10,
              //   width: size.width,
              //   alignment: Alignment.center,
              //   child: Container(
              //     height: size.height / 12,
              //     width: size.width,
              //     child:
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         // isRecording?AudioWaveforms(
              //         //   enableGesture: true,
              //         //   size: Size(MediaQuery.of(context).size.width / 2, 50),
              //         //   recorderController: recorderController,
              //         //   waveStyle: const WaveStyle(
              //         //     waveColor: Colors.white,
              //         //     extendWaveform: true,
              //         //     showMiddleLine: false,
              //         //   ),
              //         //   decoration: BoxDecoration(
              //         //     borderRadius: BorderRadius.circular(12.0),
              //         //     color: const Color(0xFF1E1B26),
              //         //   ),
              //         //   padding: const EdgeInsets.only(left: 18),
              //         //   margin: const EdgeInsets.symmetric(horizontal: 15),
              //         // ):
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
              //           TextField(
              //             keyboardType: TextInputType.multiline,
              //             maxLines: 5,
              //
              //             cursorColor: Colors.white,
              //             style: TextStyle(
              //
              //                 color: Colors.white
              //             ),
              //             focusNode: _focusNode,
              //             onTap: (){
              //               setState((){
              //                 emojiShowing=false;
              //               });
              //
              //             },
              //             controller: _message,
              //             decoration: InputDecoration(
              //                 focusedBorder: InputBorder.none,
              //                 enabledBorder: InputBorder.none,
              //                 contentPadding: EdgeInsetsDirectional.only(start: 2.0,top: 10.0),
              //                 prefixIcon:  GestureDetector(
              //                   onTap: (){
              //                     setState(() {
              //
              //                       emojiShowing = !emojiShowing;
              //                       if(emojiShowing){
              //                         _focusNode.unfocus();
              //                       }
              //                       else{
              //                         FocusScope.of(context).requestFocus(_focusNode);
              //                       }
              //                     });
              //                   },
              //                   child: SvgPicture.asset(
              //                     "asset/images/emojiicon.svg",
              //                     height: 12,
              //                     width: 12,
              //                     fit: BoxFit.scaleDown,
              //
              //
              //                   ),
              //                 ),
              //
              //                 suffixIcon: Row(
              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
              //                   mainAxisSize: MainAxisSize.min,
              //                   children: [
              //
              //                  btnenabled==true?Container():   GestureDetector(
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
              //                       setState((){
              //                         attachmentsenabled = !attachmentsenabled;
              //                         print("the value of attachment is $attachmentsenabled");
              //                       });
              //
              //                       print("hiee iam clicked");
              //                     },
              //                     ),
              //                   ],
              //                 ),
              //                 hintText: "Type a message...",
              //                 hintStyle: TextStyle(
              //                     color: Colors.white
              //                 )
              //             ),
              //           ),
              //         ),
              //
              //         btnenabled==true?Container(
              //           width: 40,
              //           height: 40,
              //           child: ElevatedButton(
              //               onPressed: (){
              //                 scrollController.animateTo(scrollController.position.maxScrollExtent,
              //                     duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
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
              //           child: GestureDetector(
              //             // onLongPress: (){
              //             //   startRecord();
              //             //
              //             //   setState(() {
              //             //     HapticFeedback.vibrate();
              //             //     isRecording = true;
              //             //   });
              //             //
              //             // },
              //             // onLongPressEnd: (details) {
              //             //   stopRecord();
              //             //   setState(() {
              //             //     isRecording = false;
              //             //   });
              //             // },
              //
              //
              //             child: SvgPicture.asset(
              //               "asset/images/auidochat.svg",
              //               height: 20,
              //               width: 20,
              //               fit: BoxFit.scaleDown,
              //
              //
              //             ),
              //           ),
              //         )
              //
              //       ],
              //     ),
              //   ),
              // ),
              //
            ],
          ),
        ),
      ),
    );
  }

  bool isPlayingMsg = false, isRecording = false, isSending = false;
  int i = 0;
  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }
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
      AudioPlayer  audioPlayer = AudioPlayer();
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
  String localPath="";
  Widget messageTile(Size size, Map<String, dynamic> chatMap,{required String idd}) {

    Timestamp t= chatMap["time"] as Timestamp;
    DateFormat("h:mma").format(t.toDate());


    return
      (chatMap['type'] == "text") ?
         GestureDetector(
           onLongPress: (){
             chatMap['sendby'] == thenaa?    showDialog(
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
             mainAxisAlignment: MainAxisAlignment.spaceAround,

             children: [
            chatMap['sendby'] == thenaa  ?Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child:
              Row(

                   mainAxisAlignment: chatMap['sendby'] == thenaa?MainAxisAlignment.spaceAround:MainAxisAlignment.spaceAround ,
                   children: [
                     Container(
                       child: Text(
                         t!=null?   DateFormat("h:mma").format(t.toDate()):'',
                         style: TextStyle(
                           fontSize: 12,
                           fontWeight: FontWeight.w500,
                           color: Colors.grey,
                         ),
                       ),
                     ),
                   ],
                 ),
            ):Container(),
                  Expanded(
                 child: Row(
                   mainAxisAlignment:chatMap['sendby'] == thenaa?MainAxisAlignment.end:MainAxisAlignment.start ,
                   children: [
                     Container(

                         constraints:  BoxConstraints(
                           maxWidth: size.width*0.65,
                         ),
                         padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                         margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.only(
                             bottomLeft: chatMap['sendby'] == thenaa?Radius.circular(20.0):Radius.circular(20.0),
                             topLeft:chatMap['sendby'] == thenaa? Radius.circular(0.0):Radius.circular(20.0),
                             topRight:  Radius.circular(20.0),
                             bottomRight: chatMap['sendby'] == thenaa?Radius.circular(20.0):Radius.circular(0.0),
                           ),

                           color: chatMap['sendby'] == thenaa?Colors.grey: Colors.blue,
                         ),
                         child: chatMap['reply']==null?
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [

                             Text(
                               chatMap['sendby'],
                               style: TextStyle(
                                 fontSize: 12,
                                 fontWeight: FontWeight.w500,
                                 color: Colors.white,
                               ),
                             ),
                             SizedBox(
                               height: size.height / 200,
                             ),

                          Text(
                               chatMap['message'],
                               style: TextStyle(
                                 fontSize: 16,
                                 fontWeight: FontWeight.w500,
                                 color: Colors.white,
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

                       child: ReplyMessageWidget(message: chatMap['reply'], onCancelReply: () {
                         onCancelReply();
                       }

                       ),

                     ),
                             SizedBox(
                               height: size.height / 200,
                             ),

                             Text(
                               chatMap['sendby'],
                               style: TextStyle(
                                 fontSize: 12,
                                 fontWeight: FontWeight.w500,
                                 color: Colors.white,
                               ),
                             ),

                             Text(
                               chatMap['message'],
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
               chatMap['sendby'] == thenaa ?Container():Padding(
                 padding: const EdgeInsets.only(right: 40.0),
                 child: Row(

                   mainAxisAlignment: chatMap['sendby'] == thenaa?MainAxisAlignment.spaceEvenly:MainAxisAlignment.spaceEvenly ,
                   children: [
                     Container(
                       child: Text(
                         t!=null?   DateFormat("h:mma").format(t.toDate()):'',
                         style: TextStyle(
                           fontSize: 12,
                           fontWeight: FontWeight.w500,
                           color: Colors.grey,
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
             ],
           ),
         ):
   (chatMap['type'] == "img")?
         GestureDetector(
           onLongPress: (){
             chatMap['sendby'] == thenaa?    showDialog(
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
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: [
               chatMap['sendby'] == thenaa  ?Padding(
                 padding: const EdgeInsets.only(left: 40.0),
                 child: Row(

                   mainAxisAlignment: chatMap['sendby'] == thenaa?MainAxisAlignment.spaceAround:MainAxisAlignment.spaceAround ,
                   children: [
                     Container(
                       child: Text(
                         t!=null?   DateFormat("h:mma").format(t.toDate()):'',
                         style: TextStyle(
                           fontSize: 12,
                           fontWeight: FontWeight.w500,
                           color: Colors.grey,
                         ),
                       ),
                     ),
                   ],
                 ),
               ):Container(),
               Expanded(
                 child: Row(
                   mainAxisAlignment:chatMap['sendby'] == thenaa?MainAxisAlignment.end:MainAxisAlignment.start ,
                   children: [
                     Container(
                       constraints:  BoxConstraints(
                         maxWidth: size.width*0.65,
                       ),
                      width: size.width,
                      alignment: chatMap['sendby'] == thenaa
                          ? Alignment.centerRight
                          : Alignment.centerLeft,

                        child:

                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blue.shade400

                        ),
                        child:chatMap['reply']==null?Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chatMap['sendby'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: size.height / 200,
                            ),
                            Container(

                              height: 300,
                              width:MediaQuery.of(context).size.width*0.65,
                              child: chatMap['message']!=""?ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.network(
                                  chatMap['message'],
                                  fit: BoxFit.cover,
                                ),
                              )  : CircularProgressIndicator(),
                            ),
                          ],
                        ):Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [


                            Container(


                              margin: EdgeInsets.only(bottom: 8),

                              child: ReplyMessageWidget(message: chatMap['reply'], onCancelReply: () {
                                onCancelReply();
                              }

                              ),

                            ),
                            SizedBox(
                              height: size.height / 200,
                            ),

                            Text(
                              chatMap['sendby'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),

                            Text(
                              chatMap['message'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
        ),
                   ],
                 ),
               ),
               chatMap['sendby'] == thenaa ?Container():Padding(
                 padding: const EdgeInsets.only(right: 40.0),
                 child: Row(

                   mainAxisAlignment: chatMap['sendby'] == thenaa?MainAxisAlignment.spaceEvenly:MainAxisAlignment.spaceEvenly ,
                   children: [
                     Container(
                       child: Text(
                         t!=null?   DateFormat("h:mma").format(t.toDate()):'',
                         style: TextStyle(
                           fontSize: 12,
                           fontWeight: FontWeight.w500,
                           color: Colors.grey,
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
             ],
           ),
         ):(chatMap['type'] == "files")?
   GestureDetector(
     onLongPress: (){
       chatMap['sendby'] == thenaa?    showDialog(
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
       alignment: chatMap['sendby'] == thenaa
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
         alignment: chatMap['message'] != "" ? null : Alignment.center,
         child: chatMap['message'] != ""
             ? ClipRRect(
           borderRadius: BorderRadius.circular(12.0),
           child: InkWell(
               onTap: () {

                 print("hvhhyg${ chatMap['message']}");
                 ApiServiceProvider.loadpdf(chatMap['message']).then((value) {
                   setState(() {
                     localPath = value;
                     Navigator.of(context).push(
                       MaterialPageRoute(builder: (context) => PDFViewerPage(localpath: '$localPath',)),
                     );
                   });
                 });


               },
               child: Center(child: Text( chatMap['namepdf'],))),
         )
             : CircularProgressIndicator(),
       ),
     ),
   ):  (chatMap['type'] == "notify") ?
   GestureDetector(
     onLongPress: (){
       chatMap['sendby'] == thenaa?    showDialog(
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
       alignment: Alignment.center,
       child: Container(
         padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
         margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(5),
           color: Colors.black38,
         ),
         child: Text(
           chatMap['message'],
           style: TextStyle(
             fontSize: 14,
             fontWeight: FontWeight.bold,
             color: Colors.white,
           ),
         ),
       ),
     ),
   ):
   GestureDetector(
     onLongPress: (){
       chatMap['sendby'] == thenaa?    showDialog(
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

       alignment:chatMap['sendby'] == thenaa?Alignment.centerRight:Alignment.centerLeft ,

       child:
       Container(
         padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

         decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(15),


         ),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(
               chatMap['sendby'],
               style: TextStyle(
                 fontSize: 12,
                 fontWeight: FontWeight.w500,
                 color: Colors.white,
               ),
             ),
             SizedBox(
               height: size.height / 200,
             ),
             Container(
               height: 70,
               width:MediaQuery.of(context).size.width*0.65,
               child: WaveBubble(

                 playerController: playerController,
                 isPlaying: playerController.playerState ==isPlayingMsg,


                 onTap: ()async{
                   playerController.playerState == isPlayingMsg
                       ? await playerController.pausePlayer()
                       : _loadFile(chatMap['type']);;

                 },
                 isSender: false,
               ),
             ),
           ],
         ),
       ),
     ),
   );





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