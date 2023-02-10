import 'dart:convert';
import 'dart:math';
import 'dart:developer';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_s3/simple_s3.dart';
import 'package:social_media_recorder/audio_encoder_type.dart';
import 'package:social_media_recorder/screen/social_media_recorder.dart';
import 'package:socialapp/audioManager.dart';
import 'package:socialapp/audioManager.dart';
import 'package:socialapp/audioplayingadaptercomment.dart';
import 'package:socialapp/chatfirebase/models/UserModel.dart';
import 'package:socialapp/comment_reply.dart';
import 'package:socialapp/commentreplylistshow.dart';
import 'package:socialapp/hometabscreen.dart';
import 'package:socialapp/model/commentlistshowmodel.dart';
import 'package:socialapp/post_fetch_profile/fetch_profile.dart';
import 'package:socialapp/replypagecomment.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import 'audioManager.dart';
import 'bucketmodel/Bucketmodel.dart';
import 'chat_bubble.dart';
import 'likeindex_apicall/commentlike.dart';
import 'likeindex_apicall/commentscreen2index.dart';

class CommentScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  CommentScreen({Key? key,required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen>  with SingleTickerProviderStateMixin {
  late  PageManager _pageManager;
  ComentListShowModel? _commentData;
  String postidtoken = "";
  String idtoken = "";
  SimpleS3 _simpleS3 = SimpleS3();
  Future getcommenttoken() async {
    final SharedPreferences tokensharedpreferences =
        await SharedPreferences.getInstance();
    var extratokuuu = tokensharedpreferences.getString('post_id');
    setState(() {
      postidtoken = extratokuuu!;
    });
    print("token get is ${postidtoken}");
  }
  SimpleS3 comments3 = SimpleS3();
  File? commentselectedfile;
  String? commentaudiosendurl;
  bool commentisrecording = false;
  bool commentuploaded = false;
  bool commentisfirst = false;
  bool opencommentreply=false;
 late AnimationController _animationController;
  //Mic
  late  Animation<double> _micTranslateTop;
  late  Animation<double> _micRotationFirst;
  late  Animation<double> _micTranslateRight;
  late  Animation<double> _micTranslateLeft;
  late  Animation<double> _micRotationSecond;
  late  Animation<double> _micTranslateDown;
  late  Animation<double> _micInsideTrashTranslateDown;
  //Trash Can
  late  Animation<double> _trashWithCoverTranslateTop;
  late  Animation<double> _trashCoverRotationFirst;
  late  Animation<double> _trashCoverTranslateLeft;
  late  Animation<double> _trashCoverRotationSecond;
  late Animation<double> _trashCoverTranslateRight;
  late  Animation<double> _trashWithCoverTranslateDown;
  @override
  void initState() {
    getcommenttoken();
    super.initState();
    getbucketapi();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2500),
    );

    //Mic

    _micTranslateTop = Tween(begin: 0.0, end: -150.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    _micRotationFirst = Tween(begin: 0.0, end: pi).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.2),
      ),
    );

    _micTranslateRight = Tween(begin: 0.0, end: 13.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.1),
      ),
    );

    _micTranslateLeft = Tween(begin: 0.0, end: -13.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.1, 0.2),
      ),
    );

    _micRotationSecond = Tween(begin: 0.0, end: pi).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 0.45),
      ),
    );

    _micTranslateDown = Tween(begin: 0.0, end: 150.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.45, 0.79, curve: Curves.easeInOut),
      ),
    );

    _micInsideTrashTranslateDown = Tween(begin: 0.0, end: 55.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.95, 1.0, curve: Curves.easeInOut),
      ),
    );

    //Trash Can

    _trashWithCoverTranslateTop = Tween(begin: 30.0, end: -25.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.45, 0.6),
      ),
    );

    _trashCoverRotationFirst = Tween(begin: 0.0, end: -pi / 3).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.6, 0.7),
      ),
    );

    _trashCoverTranslateLeft = Tween(begin: 0.0, end: -18.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.6, 0.7),
      ),
    );

    _trashCoverRotationSecond = Tween(begin: 0.0, end: pi / 3).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.8, 0.9),
      ),
    );

    _trashCoverTranslateRight = Tween(begin: 0.0, end: 18.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.8, 0.9),
      ),
    );

    _trashWithCoverTranslateDown = Tween(begin: 0.0, end: 55.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.95, 1.0, curve: Curves.easeInOut),
      ),
    );

    getidtoken();

    _initialiseControllers();
    commentinitializecontrollers();
    getData();


  }
  late final PlayerController commentplayercontrol5;
  late final RecorderController commentrecordcontroller;
  Future<String?> commentuploadauthvoiceandmouth({required String commentid}) async {
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
          commentpagegetcomment(postId: postidtoken, id: idtoken, url: commentaudiosendurl!, commentid: '$commentid');
          isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    }
    return result;
  }
  void commentplayorpausecontroller(PlayerController controller) async {
    controller.playerState == PlayerState.playing
        ? await controller.pausePlayer()
        : await controller.startPlayer(finishMode: FinishMode.loop);
  }
  Future commentpagegetcomment(
      {required String postId, required String id, required String url,required String commentid}) async {
    try {
      print("trying to Comment");

      var body = {
        "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
        "ID": "$id",
        "COMMENT_ID": '$commentid',
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
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => HomeTabScreen()));
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }
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
  void _commentstartorstoprecording({required String okcommentid}) async {
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
          commentuploadauthvoiceandmouth(commentid: '$okcommentid');
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


  Future getidtoken() async {
    final prefs = await SharedPreferences.getInstance();
    final showhome = prefs.getString("USER_ID") ?? '';
    setState(() {
      idtoken = showhome;
    });
    print("the id for comment is $idtoken");
  }





  File selectedFile = File("");
  String? audiosendurl;
  bool isLoading = false;
  bool uploaded = false;
  bool isfirst = false;
  List<CommentList> commentList=[];
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
  Future<String?> _uploadAudioMouthVoice() async {
    String? result;

    if (result == null) {
      try {
        setState(() {
          isLoading = true;
        });
        result = await _simpleS3.uploadFile(
          selectedFile,
          "${bucketmodel!.data.bucket.toString()}",
          "${bucketmodel!.data.poolId.toString()}",
          AWSRegions.apSouth1,
          debugLog: true,
          s3FolderPath: "comment",
          accessControl: S3AccessControl.publicRead,
        );

        print("https://winklixsocial.s3.ap-south-1.amazonaws.com/" +
            "comment/"+"${selectedFile.path.split("/").last}");
        audiosendurl = ("https://winklixsocial.s3.ap-south-1.amazonaws.com/" +
            "comment/"+"${selectedFile.path.split("/").last}");

        setState(() {
          uploaded = true;
          onvoicetap=false;
          getComment(postId: postidtoken, id: idtoken, url: audiosendurl!);
          isLoading = false;
          Fluttertoast.showToast(
              msg:
              "Your Voice Is Uploaded",
              toastLength:
              Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          audiosendurl=null;
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


  Future<void> newpostlikeuserid(uid)async {
    final SharedPreferences tokensharedpreferences=await SharedPreferences.getInstance();
    tokensharedpreferences.setString('postuserid', uid);
  }
  void getData() async {
    _commentData = (await postcommentlist());
    //  print(_homeData);
    Future.delayed(const Duration(seconds: 0)).then((value) => setState(() {}));
  }

  void _disposeControllers() {
    recorderController.dispose();

    playerController5.dispose();
    commentrecordcontroller.dispose();

    commentplayercontrol5.dispose();
  }


  @override
  void dispose() {
    _pageManager.dispose();
    super.dispose();
    _disposeControllers();
    _animationController.dispose();
  }
  bool pressed=false;
  Widget _buildMicAnimation() {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child:Column(

        children: [
         AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.identity()
                  ..translate(0.0, 10)
                  ..translate(_micTranslateRight.value)
                  ..translate(_micTranslateLeft.value)
                  ..translate(0.0, _micTranslateTop.value)
                  ..translate(0.0, _micTranslateDown.value)
                  ..translate(0.0, _micInsideTrashTranslateDown.value),
                child: Transform.rotate(
                  angle: _micRotationFirst.value,
                  child: Transform.rotate(
                    angle: _micRotationSecond.value,
                    child: child,
                  ),
                ),
              );
            },
            child: Icon(
              Icons.mic,
              color: Color(0xFFef5552),
              size: 30,
            ),
          ),
          AnimatedBuilder(
              animation: _trashWithCoverTranslateTop,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.identity()
                    ..translate(0.0, _trashWithCoverTranslateTop.value)
                    ..translate(0.0, _trashWithCoverTranslateDown.value),
                  child: child,
                );
              },
              child:Column(
                children: [
                  AnimatedBuilder(
                    animation: _trashCoverRotationFirst,
                    builder: (context, child) {
                      return Transform(
                        transform: Matrix4.identity()
                          ..translate(_trashCoverTranslateLeft.value)
                          ..translate(_trashCoverTranslateRight.value),
                        child: Transform.rotate(
                          angle: _trashCoverRotationSecond.value,
                          child: Transform.rotate(
                            angle: _trashCoverRotationFirst.value,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: Image(
                      image: AssetImage('asset/images/trash_coverr.png'),
                      width: 30,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 1.5),
                    child: Image(
                      image: AssetImage('asset/images/trash_containerr.png'),
                      width: 30,
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: TextField(
          decoration: InputDecoration(
            enabled: false,
            filled: true,
            fillColor: Color(0xFFfdfffd),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0.2),
              borderRadius: BorderRadius.circular(32),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.yellow, width: 0.0),
              borderRadius: BorderRadius.circular(32),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildButtons() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
       IconButton(icon:Icon(Icons.mic), onPressed: () {
            setState(() {

            });
            _animationController.forward();

          },),     IconButton(icon:Icon(Icons.mic), onPressed: () {
            setState(() {

            });
    _animationController.reset();

    },),
          // IconButton(icon:Icon(Icons.m), onPressed: () {
          //   _animationController.forward();
          // },)


          // ElevatedButton(
          //   child: Text('Reset'),
          //   onPressed: () {
          //
          //   },
          // ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading:  ExpandTapWidget(
              tapPadding: EdgeInsets.all(10.0),
              onTap: (){
                Navigator.of(context).pop();

              },
              child: SvgPicture.asset('asset/images/back_arow.svg',width: 10,height: 15,fit: BoxFit.scaleDown,)),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Comments',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
     
        body: Column(
          children: [



              Expanded(

                child:  _commentData==null?Center(

                  child: CircularProgressIndicator(

                  ),): ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,

                  itemCount: _commentData!=null? _commentData!.commentList.length:0,
                  itemBuilder: (BuildContext context, int i) {
                    _pageManager = PageManager(audioUrl:_commentData!.commentList[i].comment);
                    return
                     Padding(
                        padding: const EdgeInsets.only(
                            top: 5, left: 14.87, right: 14.87),
                        child: Container(
                          height: 190,
                          width: size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xff171723)),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.only(top: 7, left: 10,right: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap:(){
                                        print(_commentData!.commentList[i].uId);
                                        newpostlikeuserid(_commentData!.commentList[i].uId);
                                       Get.to(fetchprofile(userModel: widget.userModel, firebaseUser: widget.firebaseUser,));
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl: "${_commentData!.commentList[i].profilePic}",
                                        fit: BoxFit.fill,
                                        width: 30,
                                        height: 30,
                                        placeholder: (context, url) => Padding(
                                          padding: EdgeInsets.all(18.0),
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.person),
                                      ),
                                    ),

                                    Text(
                                      _commentData!.commentList[i].name.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),

                                    Text(
                                      _commentData!
                                          .commentList[i].commentTime.toString(),
                                      style:
                                      TextStyle(color: Color(0xffA4A4A4)),
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  AudioPlayingAdapter(
                                      url: _commentData!
                                          .commentList[i].comment,
                                  ),
                                  CommentLikefolder(id: idtoken,commentid: _commentData!.commentList[i].commentId,
                                    islikes:_commentData!.commentList[i].isliked,
                                    likes:_commentData!.commentList[i].commentLikes ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Commentscreenindex2(seccomentid:_commentData!.commentList[i].commentId.toString() ,
                         seccomentreplies:_commentData!.commentList[i].commentReplies.toString(),
                                secondreplycommentid: '${_commentData!.commentList[i].commentId.toString()}',),



                              // Padding(
                              //   padding:
                              //   const EdgeInsets.only(top: 10, left: 45),
                              //   child: Row(
                              //     children: [
                              //       Text(
                              //         "View " +
                              //             _commentData!
                              //                 .commentList[i].commentReplies
                              //                 .toString() +
                              //             " Replies",
                              //         style: TextStyle(
                              //             fontSize: 13,
                              //             fontWeight: FontWeight.w400,
                              //             color: Colors.grey),
                              //       ).onTap(() {
                              //         Navigator.push(
                              //             context,
                              //             MaterialPageRoute(
                              //                 builder: (context) =>
                              //                     ViewReplyCommentScreen(
                              //                         commentid: _commentData!
                              //                             .commentList[i]
                              //                             .commentId.toString())));
                              //       }),
                              //       SizedBox(
                              //         width: size.width / 10,
                              //       ),
                              //       Text(
                              //         'Reply',
                              //         style: TextStyle(
                              //             fontSize: 13,
                              //             fontWeight: FontWeight.w400,
                              //             color: Colors.grey),
                              //       ).onTap(() {
                              //         setState(() {
                              //           opencommentreply=!opencommentreply;
                              //         });
                              //
                              //
                              //       }),
                              //       SizedBox(
                              //         width: size.width / 10,
                              //       ),
                              //       Text(
                              //         'Share',
                              //         style: TextStyle(
                              //             fontSize: 13,
                              //             fontWeight: FontWeight.w400,
                              //             color: Colors.grey),
                              //       )
                              //     ],
                              //   ),
                              // ),

                          // opencommentreply==true?   Container(
                          //       width: MediaQuery.of(context).size.width * 0.83,
                          //       height: 40,
                          //       decoration: BoxDecoration(
                          //           border: Border.all(
                          //             color: Theme.of(context).hoverColor,
                          //           ),
                          //           borderRadius:
                          //           BorderRadius.all(Radius.circular(2))),
                          //       child: Row(
                          //         children: [
                          //           SizedBox(
                          //             width: 10,
                          //           ),
                          //           // isRecording
                          //           //     ?
                          //           // AudioWaveforms(
                          //           //   enableGesture: true,
                          //           //   size: Size(
                          //           //       MediaQuery.of(context).size.width / 2,
                          //           //       50),
                          //           //   recorderController: recorderController,
                          //           //   waveStyle: const WaveStyle(
                          //           //     waveColor: Colors.white,
                          //           //     extendWaveform: true,
                          //           //     showMiddleLine: false,
                          //           //   ),
                          //           //   decoration: BoxDecoration(
                          //           //     borderRadius: BorderRadius.circular(12.0),
                          //           //     color: const Color(0xFF1E1B26),
                          //           //   ),
                          //           //   padding: const EdgeInsets.only(left: 18),
                          //           //   margin: const EdgeInsets.symmetric(
                          //           //       horizontal: 15),
                          //           // ):  Container(
                          //           //   width: 150,
                          //           //   height: 18,
                          //           //   padding: EdgeInsets.only(left: 3),
                          //           //   child: Text(
                          //           //     'record your comment...',
                          //           //     style: TextStyle(
                          //           //         color:Theme.of(context).hoverColor),
                          //           //   ),
                          //           // ),
                          //           commentisrecording == true
                          //               ? AudioWaveforms(
                          //             enableGesture: true,
                          //             size: Size(
                          //                 MediaQuery.of(context).size.width / 2,
                          //                 50),
                          //             recorderController: commentrecordcontroller,
                          //             waveStyle: const WaveStyle(
                          //               waveColor: Colors.white,
                          //               extendWaveform: true,
                          //               showMiddleLine: false,
                          //             ),
                          //             decoration: BoxDecoration(
                          //               borderRadius: BorderRadius.circular(12.0),
                          //               color: const Color(0xFF1E1B26),
                          //             ),
                          //             padding: const EdgeInsets.only(left: 18),
                          //             margin: const EdgeInsets.symmetric(
                          //                 horizontal: 15),
                          //           )
                          //               : Container(),
                          //           // Padding(
                          //           //   padding: const EdgeInsets.only(top: 10, left: 45),
                          //           //   child: Row(
                          //           //     children: [
                          //           //       Image.asset('asset/images/redrecorder.png'),
                          //           //       SizedBox(
                          //           //         width: size.width / 25,
                          //           //       ),
                          //           //       Text(
                          //           //         '0.01',
                          //           //         style: TextStyle(
                          //           //             fontSize: 13,
                          //           //             fontWeight: FontWeight.w600,
                          //           //             color: Colors.white),
                          //           //       ),
                          //           //       SizedBox(
                          //           //         width: size.width / 20,
                          //           //       ),
                          //           //       Text(
                          //           //         'Cancel',
                          //           //         style: TextStyle(
                          //           //             fontSize: 13,
                          //           //             fontWeight: FontWeight.w400,
                          //           //             color: Colors.grey),
                          //           //       ),
                          //           //       SizedBox(
                          //           //         width: size.width / 20,
                          //           //       ),
                          //           //       Text(
                          //           //         'Post',
                          //           //         style: TextStyle(
                          //           //             fontSize: 13,
                          //           //             fontWeight: FontWeight.w400,
                          //           //             color: Colors.grey),
                          //           //       ),
                          //           //       SizedBox(
                          //           //         width: size.width / 20,
                          //           //       ),
                          //           //       Text(
                          //           //         'Anonymous Post',
                          //           //         style: TextStyle(
                          //           //             fontSize: 13,
                          //           //             fontWeight: FontWeight.w400,
                          //           //             color: Colors.grey),
                          //           //       )
                          //           //     ],
                          //           //   ),
                          //           // ),
                          //           Expanded(
                          //             child: Row(
                          //               mainAxisAlignment: MainAxisAlignment.end,
                          //               children: [
                          //                 InkWell(
                          //                   onTap:(){
                          //                     if (commentaudiosendurl == null) {
                          //                       setState((){
                          //
                          //                         commentisfirst = true;
                          //                         _commentstartorstoprecording(okcommentid: '${_commentData!.commentList[i].commentId.toString()}');
                          //                       });
                          //
                          //                     } else {
                          //                       setState((){
                          //
                          //                       });
                          //
                          //                       // Fluttertoast.showToast(
                          //                       //     msg:
                          //                       //     "Your Voice Is Already Uploaded",
                          //                       //     toastLength:
                          //                       //     Toast.LENGTH_SHORT,
                          //                       //     gravity: ToastGravity.BOTTOM,
                          //                       //     backgroundColor: Colors.red,
                          //                       //     textColor: Colors.white,
                          //                       //     fontSize: 16.0);
                          //                     }
                          //                   },
                          //
                          //                   child: Padding(
                          //                     padding:
                          //                     const EdgeInsets.only(right: 20.0),
                          //                     child: Image.asset(
                          //                       'asset/images/mic.png', color: Theme.of(context).hoverColor,),
                          //                   ),
                          //                 ),
                          //                 // OutlinedButton(
                          //                 //   child: Text('POST'),
                          //                 //
                          //                 //   style: OutlinedButton.styleFrom(
                          //                 //
                          //                 //     primary: Colors.white,
                          //                 //   ),
                          //                 //   onPressed: () {
                          //                 //
                          //                 //
                          //                 //   },
                          //                 // ),
                          //               ],
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ):Container(),
                            ],
                          ),
                        ),
                      );
                  },
                        ),
              ),
            _commentData==null? Spacer():Visibility(
              visible: false,
                child: SizedBox()),



            // Container(
            //   child: Stack(
            //     children: [
            //       _buildTextField(),
            //       _buildMicAnimation(),
            //       _buildButtons(),
            //     ],
            //   ),
            // )



            // Expanded(
            //   flex: 1,
            //   child: Align(
            //     alignment: Alignment.bottomCenter,
            //     child: Column(
            //       children: [
            //         Divider(
            //           thickness: 1,
            //           color: Colors.white.withOpacity(0.3),
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.only(
            //               top: 4, left: 12, right: 5, bottom: 10),
            //           child: Row(
            //             children: [
            //               Padding(
            //                 padding: const EdgeInsets.only(left: 5.0),
            //                 child: ClipRRect(
            //                   borderRadius: BorderRadius.circular(10),
            //                   child: Image.asset(
            //                     'asset/images/reply.png',
            //                   ),
            //                 ),
            //               ),
            //               SizedBox(
            //                 width: 8,
            //               ),
            //               InkWell(
            //                 // onTap: () {
            //                   if (audiosendurl == null) {
            //                     isfirst = true;
            //                     _startOrStopRecording();
            //                   } else {
            //                     isfirst = false;
            //                     Fluttertoast.showToast(
            //                         msg:
            //                         "Your Voice Is Already Uploaded",
            //                         toastLength:
            //                         Toast.LENGTH_SHORT,
            //                         gravity: ToastGravity.BOTTOM,
            //                         backgroundColor: Colors.red,
            //                         textColor: Colors.white,
            //                         fontSize: 16.0);
            //                   }
            //                 // },
            //                 child: Container(
            //                   width: MediaQuery.of(context).size.width * 0.83,
            //                   height: 40,
            //                   decoration: BoxDecoration(
            //                       border: Border.all(
            //                         color: Theme.of(context).hoverColor,
            //                       ),
            //                       borderRadius:
            //                           BorderRadius.all(Radius.circular(50))),
            //                   child: Row(
            //                     children: [
            //                       SizedBox(
            //                         width: 10,
            //                       ),
            //                       isRecording
            //                           ?
            //                       AudioWaveforms(
            //                         enableGesture: true,
            //                         size: Size(
            //                             MediaQuery.of(context).size.width / 2,
            //                             50),
            //                         recorderController: recorderController,
            //                         waveStyle: const WaveStyle(
            //                           waveColor: Colors.white,
            //                           extendWaveform: true,
            //                           showMiddleLine: false,
            //                         ),
            //                         decoration: BoxDecoration(
            //                           borderRadius: BorderRadius.circular(12.0),
            //                           color: const Color(0xFF1E1B26),
            //                         ),
            //                         padding: const EdgeInsets.only(left: 18),
            //                         margin: const EdgeInsets.symmetric(
            //                             horizontal: 15),
            //                       ):  Container(
            //                         width: 150,
            //                         height: 18,
            //                         padding: EdgeInsets.only(left: 3),
            //                         child: Text(
            //                           'record your comment...',
            //                           style: TextStyle(
            //                               color:Theme.of(context).hoverColor),
            //                         ),
            //                       ),
            //                       Expanded(
            //                         child: Row(
            //                           mainAxisAlignment: MainAxisAlignment.end,
            //                           children: [
            //                             InkWell(
            //                                onTap: () {
            //                                                           if (audiosendurl == null) {
            //                                                             isfirst = true;
            //                                                             _startOrStopRecording();
            //                                                           } else {
            //                                                             isfirst = false;
            //                                                             Fluttertoast.showToast(
            //                                                                 msg:
            //                                                                 "Your Voice Is Already Uploaded",
            //                                                                 toastLength:
            //                                                                 Toast.LENGTH_SHORT,
            //                                                                 gravity: ToastGravity.BOTTOM,
            //                                                                 backgroundColor: Colors.red,
            //                                                                 textColor: Colors.white,
            //                                                                 fontSize: 16.0);
            //                                                           }
            //                                                         },
            //                               child: Padding(
            //                                 padding:
            //                                     const EdgeInsets.only(right: 20.0),
            //                                 child: Image.asset(
            //                                     'asset/images/mic.png', color: Theme.of(context).hoverColor,),
            //                               ),
            //                             ),
            //                             // OutlinedButton(
            //                             //   child: Text('POST'),
            //                             //
            //                             //   style: OutlinedButton.styleFrom(
            //                             //
            //                             //     primary: Colors.white,
            //                             //   ),
            //                             //   onPressed: () {
            //                             //
            //                             //
            //                             //   },
            //                             // ),
            //                           ],
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // )
            // onvoicetap==false?   Align(
            //   alignment: Alignment.bottomRight,
            //   child: Column(
            //     children: [
            //       Divider(
            //         thickness: 1,
            //         color: Colors.white.withOpacity(0.3),
            //       ),
            //       Row(
            //         children: [
            //           Expanded(
            //             child: Container(
            //               width: 130,
            //               height: 25,
            //               padding: EdgeInsets.only(left: 3),
            //               child: TextField(
            //
            //                 maxLines: 5,
            //                 style: TextStyle(
            //                     overflow: TextOverflow.ellipsis,
            //
            //                     color: Theme.of(context).hoverColor,
            //                     fontSize: 14),
            //                 cursorColor: Theme.of(context).hoverColor,
            //                 controller: toComment,
            //
            //                 // onSubmitted: (String str) {
            //                 //   getHomeTabService().postComment(cmt: str);
            //                 //   toComment.clear();
            //                 //   setState(() {
            //                 //     toComment;
            //                 //   });
            //                 // },
            //                 // textInputAction: TextInputAction.go,
            //
            //                 decoration: InputDecoration(
            //                     contentPadding: EdgeInsets.zero,
            //                     isDense: true,
            //                     enabledBorder: InputBorder.none,
            //                     focusedBorder: InputBorder.none,
            //                     disabledBorder: InputBorder.none,
            //                     border: InputBorder.none,
            //                     hintText: "Reply (Comment)",
            //                     hintStyle: TextStyle(
            //                         color: Theme.of(context).hoverColor
            //                             .withOpacity(0.5),
            //                         fontSize: 12)),
            //               ),
            //             ),
            //           ),
            //           Expanded(child: Row(
            //             mainAxisAlignment: MainAxisAlignment.end,
            //             children: [
            //               GestureDetector(
            //                 onTap:(){
            //                   setState(() {
            //                     onvoicetap=!onvoicetap;
            //                   });
            //                 },
            //                 child:
            //               CircleAvatar(
            //                 backgroundColor: Colors.red,
            //                 radius: 20,
            //                 child: Icon(Icons.mic,color: Colors.black,),
            //               )
            //               ),
            //             ],
            //           ))
            //         ],
            //       )
            //
            //
            //     ],
            //   ),
            // ):
            Align(
              alignment:  _commentData==null?Alignment.bottomRight:Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: SocialMediaRecorder(



                  //    recordIcon: _buildMicAnimation(),
                  recordIconWhenLockBackGroundColor: Colors.red,
                  radius: BorderRadius.circular(10.0),
                  backGroundColor: Colors.red,

                  sendRequestFunction: (File soundFile) {


                    setState(() {
                      selectedFile = soundFile;
                    });
                      if (audiosendurl == null) {

                        print("thte ${selectedFile }");
                        // isfirst = true;
                        _uploadAudioMouthVoice();
                        print("sdfdsgsdg");
                      } else {

                        print("svfsd$audiosendurl");
                        isfirst = false;
                        Fluttertoast.showToast(
                            msg:
                            "Your Voice Is Uploaded",
                            toastLength:
                            Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }




                  },
                  encode: AudioEncoderType.AAC,



                ),
              ),
            ),
          ],
        ),
      ),
      );

  }
  bool onvoicetap=false;

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

  Future getComment(
      {required String postId, required String id, required String url}) async {
    try {
      print("trying to Comment");

      var body = {
        "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
        "ID": "$id",
        "POST_ID": "$postId",
        "COMMENT": "$url",
        "TYPE": "Url"
      };
      final response = await http.post(
          Uri.parse("http://3.227.35.5:3001/api/user/comment"),
          body: body);
      print(body);
      if (response.statusCode == 200) {
        setState(() {
          getData();
        });
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => HomeTabScreen()));
        print(response.body);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }


  Future<ComentListShowModel?> postcommentlist() async {
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
        "POST_ID": extratokuuu
      };
      print(body);

      final response = await http.post(
          Uri.parse("http://3.227.35.5:3001/api/user/comment-list"),
          body: body);
      print(response.body);

      if (response.statusCode == 200) {
        print("---------- Success -----------");

        print(response.body);

        ComentListShowModel _model = comentListShowModelFromJson(response.body);
        print("A");
        print(_model);
        print("B");

        return _model;
      }
    } catch (e) {
      print(e.toString() + "bhvyj,");
      print(e.toString() + "bhvyj,");
    }
  }
}
