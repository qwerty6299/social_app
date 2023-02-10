import 'package:flutter/material.dart';
import 'package:socialapp/model/message_model.dart';
import 'package:socialapp/model/user_model.dart';

class MessageChat extends StatefulWidget {
  MessageChat({Key? key}) : super(key: key);

  @override
  State<MessageChat> createState() => _MessageChatState();
}

class _MessageChatState extends State<MessageChat> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xff070A0D),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xff070A0D),
        title: Row(
          children: [
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: Image.asset(
                    'asset/images/profile.png',
                    height: 50,
                    width: 50,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: size.width / 22,
            ),
            Column(
              children: [
                Text(
                  'Adler finley',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                Text(
                  'Active',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
                )
              ],
            ),
            SizedBox(
              width: size.width / 3.5,
            ),
            Icon(
              Icons.more_vert_outlined,
              color: Colors.white,
              size: 30,
            ),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            ListView(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width - 55,
                      child: Card(
                          margin:
                              EdgeInsets.only(left: 10, right: 10, bottom: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            minLines: 1,
                            decoration: InputDecoration(
                                fillColor: Colors.grey,
                                hintText: "Type a message..",
                                prefixIcon: IconButton(
                                  icon: Icon(Icons.emoji_emotions),
                                  onPressed: () {},
                                ),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.camera_alt),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.add_circle_outline_outlined,
                                      ),
                                      onPressed: () {},
                                    )
                                  ],
                                ),
                                contentPadding: EdgeInsets.all(5)),
                          ))),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 25,
                      child: IconButton(
                        icon: Icon(Icons.mic),
                        color: Colors.white,
                        onPressed: () {},
                      ),
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
}
