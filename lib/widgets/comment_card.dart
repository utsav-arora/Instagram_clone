import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    UserModel user=Provider.of<UserProvider>(context).getUser;
    return Container(
      padding:const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 12
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16.0,
            backgroundImage: NetworkImage(widget.snap['profImage']),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 6.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(text: TextSpan(
                    children: [
                      TextSpan(text: widget.snap['name'], style:const TextStyle(fontWeight: FontWeight.bold),),
                      TextSpan(text: ' ${widget.snap['text']}'),
                    ],
                  ),
                  ),
                  Container(
                    padding:const EdgeInsets.only(top: 5.0),
                    child: Text(DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),
                    style:const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0
                    ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding:const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.favorite,color: Colors.red,size: 20.0,),
              onPressed: (){},
            ),
          )
        ],
      ),
    );
  }
}
