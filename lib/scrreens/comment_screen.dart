import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({Key? key,required this.snap}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController commentController = TextEditingController();

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    UserModel user=Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Comments'),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding:const EdgeInsets.only(left:16.0,right: 8.0 ),
          margin:const EdgeInsets.only(bottom: 8),
          height: kToolbarHeight,
          child: Row(
            children: [
              CircleAvatar(
                radius: 16.0,
                backgroundImage: NetworkImage(user.photoUrl),
              ),
              Expanded(child: Padding(
                padding:const EdgeInsets.only(left: 12.0 ,right: 6),
                child: TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: 'Comment as ${user.username}',
                    border: InputBorder.none
                  ),
                ),
              ),
              ),
              InkWell(
                onTap: ()async{
                  await FirestoreMethods().postComment(widget.snap['postId'],
                      user.uid, user.username, commentController.text, user.photoUrl);
                  setState(() {
                    commentController.text='' ;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text('Post',
                  style: TextStyle(
                    color: Colors.blue
                  ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
     body: StreamBuilder(
       stream: FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').orderBy('datePublished', descending: true).snapshots(),
       builder: (context , AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>snapshot){
         if(snapshot.connectionState == ConnectionState.waiting){
           return const Center(child: CircularProgressIndicator(),);
         }
         return ListView.builder(
             itemCount: snapshot.data!.docs.length,
             itemBuilder: (context, index){
              return CommentCard(snap: snapshot.data!.docs[index].data(),);
         });
       },
     ),
    );
  }
}
