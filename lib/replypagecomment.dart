import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_s3/simple_s3.dart';
import 'package:socialapp/audioManager.dart';
import 'package:socialapp/audioManager.dart';
import 'package:socialapp/audioplayingadaptercomment.dart';
import 'package:socialapp/comment_reply.dart';
import 'package:socialapp/commentscreen.dart';
import 'package:socialapp/hometabscreen.dart';
import 'package:socialapp/model/commentlistshowmodel.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import 'audioManager.dart';
import 'chat_bubble.dart';
import 'chatfirebase/models/UserModel.dart';

class ReplyCommentScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  ReplyCommentScreen({required this.commentid, Key? key,required this.userModel, required this.firebaseUser}) : super(key: key);

  final String commentid;

  @override
  State<ReplyCommentScreen> createState() => _ReplyCommentScreenState();
}

class _ReplyCommentScreenState extends State<ReplyCommentScreen> {
  late final PageManager _pageManager;
  ComentListShowModel? _commentData;
  String postidtoken = "";
  String idtoken = "";
  SimpleS3 comments3 = SimpleS3();
  Future getcommenttoken() async {
    final SharedPreferences tokensharedpreferences =
        await SharedPreferences.getInstance();
    var extratokuuu = tokensharedpreferences.getString('post_id');
    setState(() {
      postidtoken = extratokuuu!;
    });
    print("token get is ${postidtoken}");
  }

  Future getidtoken() async {
    final prefs = await SharedPreferences.getInstance();
    final showhome = prefs.getString("USER_ID") ?? '';
    setState(() {
      idtoken = showhome;
    });
    print("the id for comment is $idtoken");
  }

  File? commentselectedfile;
  String? commentaudiosendurl;
  bool isLoading = false;
  bool commentuploaded = false;
  bool commentisfirst = false;
  Future<String?> commentuploadauthvoiceandmouth() async {
    String? result;

    if (result == null) {
      try {
        setState(() {
          isLoading = true;
        });
        result = await comments3.uploadFile(
          commentselectedfile!,
          "helpampm",
          "us-east-1:b2c92ccf-bb77-456a-93df-f63c093935c3",
          AWSRegions.usEast1,
          debugLog: true,
          s3FolderPath: "test",
          accessControl: S3AccessControl.publicRead,
        );

        print("https://helpampm.s3.amazonaws.com/" +
            "test/${commentselectedfile!.path.split("/").last}");
        commentaudiosendurl = ("https://helpampm.s3.amazonaws.com/" +
            "test/${commentselectedfile!.path.split("/").last}");

        setState(() {
          commentuploaded = true;
          commentpagegetcomment(postId: postidtoken, id: idtoken, url: commentaudiosendurl!);
          isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    }
    return result;
  }

  void _commentstartorstoprecording() async {
    if (commentisrecording) {
      commentrecordcontroller.reset();
      final path = await commentrecordcontroller.stop(false);
      if (path != null) {
        await commentplayercontrol5.preparePlayer(path: path);
        setState(() {
          // commentisrecording = !commentisrecording;
          commentselectedfile = File(path);
        });
        if (commentselectedfile != null) {
          setState(() {
            commentisrecording = !commentisrecording;
            // Fluttertoast.showToast(
            //     msg: "Your Voice Upload Successfully",
            //     toastLength: Toast.LENGTH_SHORT,
            //     gravity: ToastGravity.BOTTOM,
            //     backgroundColor: Colors.red,
            //     textColor: Colors.white,
            //     fontSize: 16.0);
            commentisfirst = false;
          });
          commentuploadauthvoiceandmouth();
          path == null;
        }
      }
    } else {
      await commentrecordcontroller.record(path: path);
    }
    setState(() {
      commentisrecording = !commentisrecording;
    });
  }

  @override
  void initState() {
    getcommenttoken();
    super.initState();

    getidtoken();

    commentinitializecontrollers();
    getData();

    _pageManager = PageManager(
        audioUrl:
            "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3");
  }

  void getData() async {}
  void _disposeControllers() {
    commentrecordcontroller.dispose();

    commentplayercontrol5.dispose();
  }

  @override
  void dispose() {
    _pageManager.dispose();
    super.dispose();
    _disposeControllers();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff161730),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xff161730),
          title: Text(
            'Comments',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  !commentisfirst
                      ? Container()
                      : AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: commentisrecording
                              ? AudioWaveforms(
                                  enableGesture: true,
                                  size: Size(
                                      MediaQuery.of(context).size.width / 2,
                                      50),
                                  recorderController: commentrecordcontroller,
                                  waveStyle: const WaveStyle(
                                    waveColor: Colors.white,
                                    extendWaveform: true,
                                    showMiddleLine: false,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: const Color(0xFF1E1B26),
                                  ),
                                  padding: const EdgeInsets.only(left: 18),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                )
                              : Container(),
                        ),
                  IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        if (commentplayercontrol5.playerState !=
                            PlayerState.stopped) ...[
                          WaveBubble(
                            playerController: commentplayercontrol5,
                            isPlaying: commentplayercontrol5.playerState ==
                                PlayerState.playing,
                            onTap: () => commentplayorpausecontroller(commentplayercontrol5),
                            isSender: false,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Divider(
                    thickness: 1,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 4, left: 12, right: 5, bottom: 10),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'asset/images/reply.png',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.83,
                          height: 40,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 150,
                                height: 18,
                                padding: EdgeInsets.only(left: 3),
                                child: Text(
                                  'record your comment...',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.1)),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 20.0),
                                      child: InkWell(
                                          // onTap: (() async {
                                          //   await  getHomeTabService().postComment(
                                          //       postId:_homeData!.postList[i].id);
                                          //       toComment.clear();
                                          //
                                          //
                                          // }),
                                          onTap: () {
                                            if (commentaudiosendurl == null) {
                                              commentisfirst = true;
                                              _commentstartorstoprecording();
                                            } else {
                                              commentisfirst = false;
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Your Voice Is Already Uploaded",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            }
                                          },
                                          child: Image.asset(
                                              'asset/images/mic.png')),
                                    ),
                                    // OutlinedButton(
                                    //   child: Text('POST'),
                                    //
                                    //   style: OutlinedButton.styleFrom(
                                    //
                                    //     primary: Colors.white,
                                    //   ),
                                    //   onPressed: () {
                                    //
                                    //
                                    //   },
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void commentplayorpausecontroller(PlayerController controller) async {
    controller.playerState == PlayerState.playing
        ? await controller.pausePlayer()
        : await controller.startPlayer(finishMode: FinishMode.loop);
  }

  late final RecorderController commentrecordcontroller;

  late final PlayerController commentplayercontrol5;
  void _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    // _preparePlayers();
    path = "${appDirectory.path}/music.aac";
  }

  String? path;
  String? musicFile;
  bool commentisrecording = false;
  late Directory appDirectory;
  void commentinitializecontrollers() {
    commentrecordcontroller = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;

    commentplayercontrol5 = PlayerController()
      ..addListener(() {
        if (mounted) setState(() {});
      });
  }

  Future commentpagegetcomment(
      {required String postId, required String id, required String url}) async {
    try {
      print("trying to Comment");

      var body = {
        "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
        "ID": "$id",
        "COMMENT_ID": widget.commentid,
        "REPLY": "$url",
      };
      final response = await http.post(
          Uri.parse("http://3.227.35.5:3001/api/user/commentreply"),
          body: body);
      print(body);
      if (response.statusCode == 200) {
        print(response.body);
        Fluttertoast.showToast(
            msg: "Comment Replied Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CommentScreen(userModel: widget.userModel, firebaseUser: widget.firebaseUser,)));
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      log(e.toString());
    }
  }
  // Future postcommentlist({required String posss})async{
  //   try {
  //     print("=================");
  //     var body=
  //       {
  //         "APP_KEY":"SpTka6TdghfvhdwrTsXl28P1",
  //         "POST_ID":"$posss"

  //     };
  //     print(body);

  //     final response = await http.post(
  //         Uri.parse("http://3.227.35.5:3001/api/user/comment-list"),
  //         body:body);
  //     if (response.statusCode == 200) {

  //       log(response.body);
  //       print(response.body);
  //     }
  //     else {
  //       print(response.statusCode);
  //       print(response.body);

  //     }
  //   }catch(e) {
  //     print(e.toString());
  //   }
  //   }

}
