import 'dart:io';

import 'package:flutter/material.dart';


class ReplyMessageWidget extends StatelessWidget {
   String message;
  final VoidCallback onCancelReply;

   ReplyMessageWidget({
    required this.message,
    required this.onCancelReply,

    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    alignment: Alignment.centerLeft,
    duration: Duration(milliseconds:600),
    child: Row(
       mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        message.contains("https")?Flexible(child: Container(
          child: Image.network("$message",height: 100,
            width:MediaQuery.of(context).size.width*0.65,),
        )):

        Expanded(
          child: Text(
            '${message}',
            style: TextStyle(fontWeight: FontWeight.bold,),
          ),
        )


        // Expanded(child: buildReplyMessage()),
      ],
    ),
  );

  // Widget buildReplyMessage() => Column(
  //   crossAxisAlignment: CrossAxisAlignment.start,
  //   children: [
  //     Row(
  //       children: [
  //         Expanded(
  //           child: Text(
  //             '${message}',
  //             style: TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //         ),
  //         // if (onCancelReply != null)
  //         //   GestureDetector(
  //         //     child: Icon(Icons.close, size: 16),
  //         //     onTap: onCancelReply,
  //         //   )
  //       ],
  //     ),
  //
  //   ],
  // );
}