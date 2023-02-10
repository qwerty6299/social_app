import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_s3/simple_s3.dart';
import 'package:social_media_recorder/audio_encoder_type.dart';
import 'package:social_media_recorder/screen/social_media_recorder.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../bucketmodel/Bucketmodel.dart';
import '../commentreplylistshow.dart';
import '../model/commentlistshowmodel.dart';

class Commentscreenindex2 extends StatefulWidget {
  String seccomentreplies,seccomentid,secondreplycommentid;

   Commentscreenindex2({Key? key,required this.seccomentreplies,required this.seccomentid,required this.secondreplycommentid}) : super(key: key);

  @override
  State<Commentscreenindex2> createState() => _Commentscreenindex2State();
}

class _Commentscreenindex2State extends State<Commentscreenindex2> {
  String postidtoken = "";
  String idtoken = "";
  ComentListShowModel? _commentData;
  bool opencommentreply=false;
  SimpleS3 _simpleS3 = SimpleS3();
  File? selectedFile;
  bool isLoading = false;
  bool uploaded = false;
  bool isfirst = false;
  String? audiosendurl;
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
          selectedFile!,
          "${bucketmodel!.data.bucket.toString()}",
          "${bucketmodel!.data.poolId.toString()}",
          AWSRegions.apSouth1,
          debugLog: true,
          s3FolderPath: "comment",
          accessControl: S3AccessControl.publicRead,
        );

        print("replyindexhttps://winklixsocial.s3.ap-south-1.amazonaws.com/" +
            "comment/${selectedFile!.path.split("/").last}");
        audiosendurl = ("https://winklixsocial.s3.ap-south-1.amazonaws.com/" +
            "comment/${selectedFile!.path.split("/").last}");

        setState(() {
          uploaded = true;
          commentpagegetcomment(postId: postidtoken, id: idtoken, url: audiosendurl!, commentid: '${widget.secondreplycommentid}');
          // onvoicetap=false;
          // getComment(postId: postidtoken, id: idtoken, url: audiosendurl!);
          isLoading = false;

          audiosendurl=null;
        });
      } catch (e) {
        print(e);
      }
    }
    return result;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getbucketapi();
    getcommenttoken();
    getidtoken();

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0,top: 20.0,left: 50),
          child: Row(
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ViewReplyCommentScreen(
                                  commentid: widget.seccomentid)));
                },
                child:  Text(
    widget.seccomentreplies.toString()!=""?   "View " +
                      widget.seccomentreplies
                          .toString() +
                        " Replies": "View " +
        widget.seccomentreplies,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                ),
              ),

              SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap :(){
                  setState(() {
                    opencommentreply=!opencommentreply;
                  });


                },
                child: Text(
                  'Reply',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                ) ,
              ),

              SizedBox(
                width: 20
              ),
              Text(
                'Share',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey),
              )
            ],
          ),
        ),
        opencommentreply==true?   Container(

          width: MediaQuery.of(context).size.width,
          height: 60,
          decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).hoverColor,
              ),
              borderRadius:
              BorderRadius.all(Radius.circular(2))),
          child:Padding(
            padding: const EdgeInsets.only(top: 8.0,right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: SocialMediaRecorder(
                    recordIconWhenLockBackGroundColor: Colors.red,
                    radius: BorderRadius.circular(10.0),
                    backGroundColor: Colors.red,

                    sendRequestFunction: (File soundFile) {
                      print("bjfdbvd${soundFile.uri}");

                      setState(() {
                        selectedFile = soundFile;
                        if (audiosendurl == null) {

                          print("thte ${selectedFile}");
                          isfirst = true;
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
                      });



                    },
                    encode: AudioEncoderType.AAC,



                  ),
                ),
              ],
            ),
          ),
          // Row(
          //   children: [
          //     SizedBox(
          //       width: 10,
          //     ),
          //     // isRecording
          //     //     ?
          //     // AudioWaveforms(
          //     //   enableGesture: true,
          //     //   size: Size(
          //     //       MediaQuery.of(context).size.width / 2,
          //     //       50),
          //     //   recorderController: recorderController,
          //     //   waveStyle: const WaveStyle(
          //     //     waveColor: Colors.white,
          //     //     extendWaveform: true,
          //     //     showMiddleLine: false,
          //     //   ),
          //     //   decoration: BoxDecoration(
          //     //     borderRadius: BorderRadius.circular(12.0),
          //     //     color: const Color(0xFF1E1B26),
          //     //   ),
          //     //   padding: const EdgeInsets.only(left: 18),
          //     //   margin: const EdgeInsets.symmetric(
          //     //       horizontal: 15),
          //     // ):  Container(
          //     //   width: 150,
          //     //   height: 18,
          //     //   padding: EdgeInsets.only(left: 3),
          //     //   child: Text(
          //     //     'record your comment...',
          //     //     style: TextStyle(
          //     //         color:Theme.of(context).hoverColor),
          //     //   ),
          //     // ),
          //     // commentisrecording == true
          //     //     ? AudioWaveforms(
          //     //   enableGesture: true,
          //     //   size: Size(
          //     //       MediaQuery.of(context).size.width / 2,
          //     //       50),
          //     //   recorderController: commentrecordcontroller,
          //     //   waveStyle: const WaveStyle(
          //     //     waveColor: Colors.white,
          //     //     extendWaveform: true,
          //     //     showMiddleLine: false,
          //     //   ),
          //     //   decoration: BoxDecoration(
          //     //     borderRadius: BorderRadius.circular(12.0),
          //     //     color: const Color(0xFF1E1B26),
          //     //   ),
          //     //   padding: const EdgeInsets.only(left: 18),
          //     //   margin: const EdgeInsets.symmetric(
          //     //       horizontal: 15),
          //     // )
          //     //     : Container(),
          //     // Padding(
          //     //   padding: const EdgeInsets.only(top: 10, left: 45),
          //     //   child: Row(
          //     //     children: [
          //     //       Image.asset('asset/images/redrecorder.png'),
          //     //       SizedBox(
          //     //         width: size.width / 25,
          //     //       ),
          //     //       Text(
          //     //         '0.01',
          //     //         style: TextStyle(
          //     //             fontSize: 13,
          //     //             fontWeight: FontWeight.w600,
          //     //             color: Colors.white),
          //     //       ),
          //     //       SizedBox(
          //     //         width: size.width / 20,
          //     //       ),
          //     //       Text(
          //     //         'Cancel',
          //     //         style: TextStyle(
          //     //             fontSize: 13,
          //     //             fontWeight: FontWeight.w400,
          //     //             color: Colors.grey),
          //     //       ),
          //     //       SizedBox(
          //     //         width: size.width / 20,
          //     //       ),
          //     //       Text(
          //     //         'Post',
          //     //         style: TextStyle(
          //     //             fontSize: 13,
          //     //             fontWeight: FontWeight.w400,
          //     //             color: Colors.grey),
          //     //       ),
          //     //       SizedBox(
          //     //         width: size.width / 20,
          //     //       ),
          //     //       Text(
          //     //         'Anonymous Post',
          //     //         style: TextStyle(
          //     //             fontSize: 13,
          //     //             fontWeight: FontWeight.w400,
          //     //             color: Colors.grey),
          //     //       )
          //     //     ],
          //     //   ),
          //     // ),
          //     Expanded(
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.end,
          //         children: [
          //           InkWell(
          //             // onTap:(){
          //             //   if (commentaudiosendurl == null) {
          //             //     setState((){
          //             //
          //             //       commentisfirst = true;
          //             //       _commentstartorstoprecording(okcommentid: '${_commentData!.commentList[i].commentId.toString()}');
          //             //     });
          //             //
          //             //   } else {
          //             //     setState((){
          //             //
          //             //     });
          //             //
          //             //     // Fluttertoast.showToast(
          //             //     //     msg:
          //             //     //     "Your Voice Is Already Uploaded",
          //             //     //     toastLength:
          //             //     //     Toast.LENGTH_SHORT,
          //             //     //     gravity: ToastGravity.BOTTOM,
          //             //     //     backgroundColor: Colors.red,
          //             //     //     textColor: Colors.white,
          //             //     //     fontSize: 16.0);
          //             //   }
          //             // },
          //
          //             child: Padding(
          //               padding:
          //               const EdgeInsets.only(right: 20.0),
          //               child: Image.asset(
          //                 'asset/images/mic.png', color: Theme.of(context).hoverColor,),
          //             ),
          //           ),
          //           // OutlinedButton(
          //           //   child: Text('POST'),
          //           //
          //           //   style: OutlinedButton.styleFrom(
          //           //
          //           //     primary: Colors.white,
          //           //   ),
          //           //   onPressed: () {
          //           //
          //           //
          //           //   },
          //           // ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
        ):Container(),
      ],
    );
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
}
