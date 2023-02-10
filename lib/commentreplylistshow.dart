import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
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
import 'package:socialapp/hometabscreen.dart';
import 'package:socialapp/model/commentlistshowmodel.dart';
import 'package:socialapp/model/repliedcommentlistmodel.dart';

import 'package:velocity_x/velocity_x.dart';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import 'audioManager.dart';
import 'chat_bubble.dart';
import 'likeindex_apicall/comment_reply_list.dart';

class ViewReplyCommentScreen extends StatefulWidget {
  String commentid;
  ViewReplyCommentScreen({Key? key,required  this.commentid}) : super(key: key);

  @override
  State<ViewReplyCommentScreen> createState() => _ViewReplyCommentScreenState();
}

class _ViewReplyCommentScreenState extends State<ViewReplyCommentScreen> {
  late final PageManager _pageManager;

  String postidtoken = "";
  String idtoken = "";
  SimpleS3 _simpleS3 = SimpleS3();
  Future getcommenttoken() async {
    final SharedPreferences tokensharedpreferences =     await SharedPreferences.getInstance();
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

  File? selectedFile;
  String? audiosendurl;
  bool isLoading = false;
  bool uploaded = false;
  bool isfirst = false;
  Future<String?> _uploadAudioMouthVoice() async {
    String? result;

    if (result == null) {
      try {
        setState(() {
          isLoading = true;
        });
        result = await _simpleS3.uploadFile(
          selectedFile!,
          "helpampm",
          "us-east-1:b2c92ccf-bb77-456a-93df-f63c093935c3",
          AWSRegions.usEast1,
          debugLog: true,
          s3FolderPath: "test",
          accessControl: S3AccessControl.publicRead,
        );

        print("https://helpampm.s3.amazonaws.com/" +
            "test/${selectedFile!.path.split("/").last}");
        audiosendurl = ("https://helpampm.s3.amazonaws.com/" +
            "test/${selectedFile!.path.split("/").last}");

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

  void _startOrStopRecording() async {
    if (isRecording) {
      recorderController.reset();
      final path = await recorderController.stop(false);
      if (path != null) {
        await playerController5.preparePlayer(path: path);
        setState(() {
          // isRecording = !isRecording;
          selectedFile = File(path);
        });
        if (selectedFile != null) {
          setState(() {
            isRecording = !isRecording;
            // Fluttertoast.showToast(
            //     msg: "Your Voice Upload Successfully",
            //     toastLength: Toast.LENGTH_SHORT,
            //     gravity: ToastGravity.BOTTOM,
            //     backgroundColor: Colors.red,
            //     textColor: Colors.white,
            //     fontSize: 16.0);
            isfirst = false;
          });
          _uploadAudioMouthVoice();
          path == null;
        }
      }
    } else {
      await recorderController.record(path: path);
    }
    setState(() {
      isRecording = !isRecording;
    });
  }

  @override
  void initState() {
    getcommenttoken();
    super.initState();
    getidtoken().whenComplete(() async{
      await  postcommentlist();
    });
    _initialiseControllers();


    _pageManager = PageManager(
        audioUrl:
            "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3");
  }



    //  print(_homeData);



  void _disposeControllers() {
    recorderController.dispose();

    playerController5.dispose();
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
            repliedCommentListShowModel==null?Center(
              heightFactor: 14,
              child: CircularProgressIndicator(

              ),):   Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: repliedCommentListShowModel != null
                      ? repliedCommentListShowModel?.replyList.length
                      : 0,
                  itemBuilder: (BuildContext context, int i) =>
                              Padding(
                          padding: const EdgeInsets.only(
                              top: 5, left: 14.87, right: 14.87),
                          child: Container(
                            height: 150,
                            width: size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xff171723)),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 7, left: 10),
                                  child: Row(
                                    children: [
                                      repliedCommentListShowModel!.replyList[i].profilePic==""?SizedBox.shrink():  ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          "${repliedCommentListShowModel!.replyList[i].profilePic}",
                                          height: 30,
                                          width: 30,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12
                                      ),
                                      Text(
                                        "${repliedCommentListShowModel!.replyList[i].name}"??"",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        width: size.width / 5,
                                      ),
                                      Text(
                                       " ${repliedCommentListShowModel!
                                            .replyList[i].replyTime}"??"",
                                        style:
                                            TextStyle(color: Color(0xffA4A4A4)),
                                      )
                                    ],
                                  ),
                                ),
                                PagemanagerCommentReply(
                                  url: "${repliedCommentListShowModel!
                                      .replyList[i].reply}"??"",
                                )

                              ],
                            ),
                          ),
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _playOrPlausePlayer(PlayerController controller) async {
    controller.playerState == PlayerState.playing
        ? await controller.pausePlayer()
        : await controller.startPlayer(finishMode: FinishMode.loop);
  }

  late final RecorderController recorderController;

  late final PlayerController playerController5;
  void _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    // _preparePlayers();
    path = "${appDirectory.path}/music.aac";
  }

  String? path;
  String? musicFile;
  bool isRecording = false;
  late Directory appDirectory;
  void _initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;

    playerController5 = PlayerController()
      ..addListener(() {
        if (mounted) setState(() {});
      });
  }


   
  //   }
  RepliedCommentListShowModel? repliedCommentListShowModel;
  Future<RepliedCommentListShowModel?> postcommentlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("USER_ID").toString();
    print(userId);
    final SharedPreferences tokensharedpreferences =
        await SharedPreferences.getInstance();
    var extratokuuu = tokensharedpreferences.getString('post_id');

    try {
      print("trying to get POSTS");

      print("=================");
      var body = {
        "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
        "COMMENT_ID": widget.commentid
      };
      print(body);

      final response = await http.post(
          Uri.parse("http://3.227.35.5:3001/api/user/comment-reply-list"),
          body: body);
      log(response.body);

      if (response.statusCode == 200) {
        print("---------- Success -----------");
        setState(() {
          print(response.body);
          print("the comment id is ${widget.commentid}");

          repliedCommentListShowModel=repliedCommentListShowModelFromJson(response.body);
          print("A");

          print("B");
        });



        return repliedCommentListShowModel;
      }
    } catch (e) {

    }
  }
}
