import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:socialapp/model/bookmark_model.dart';
class Bookmarklogic extends StatefulWidget {
   Bookmarklogic({Key? key,required this.id,required this.postid,required this.isbookmark}) : super(key: key);
String id,postid;
String isbookmark;
  @override
  State<Bookmarklogic> createState() => _BookmarklogicState();
}

class _BookmarklogicState extends State<Bookmarklogic> {
  BookmarkModel? bookmarkModel;
  bool colored=false;
  String bookmarkmessage="";
  bool define=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.isbookmark);
  }
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () async {
        await  postbookmark(id: widget.id,postid:widget.postid);

          setState(() {
           if(widget.isbookmark=="true"){
           widget.isbookmark="false";
           }else if(widget.isbookmark=="false"){
             widget.isbookmark="true";
           }
          });


      },
      child: SvgPicture.asset(
        "asset/images/bookmark.svg",
        height: 24,
        width: 24,

        color:widget.isbookmark=="true"?Colors.red:(widget.isbookmark=="false")?Colors.white:Colors.white,

      )
    );
  }
  Future postbookmark({required String id,required String postid})async{
    try{
      var body={
        "APP_KEY": "SpTka6TdghfvhdwrTsXl28P1",
        "ID": "$id",
        "POST_ID": "$postid"
      };
      var response= await http.post(Uri.parse("http://3.227.35.5:3001/api/user/bookmark"),body: body,

      );
      if(response.statusCode==200) {
        print(response.body);
        bookmarkModel = bookmarkModelFromJson(response.body);
        setState(() {
           bookmarkmessage = bookmarkModel!.message.toString();
          if(bookmarkmessage.contains("Marked successfully!")){
            bookmarkmessage=="Marked successfully!";
            print("theeee $bookmarkmessage");
            colored=true;
          }
          else{
            colored=false;
          }
        });
      }
    }catch(e){
      print(e.toString());
    }

  }
}
