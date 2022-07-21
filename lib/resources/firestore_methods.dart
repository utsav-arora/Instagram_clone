
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  Future<String> uploadPost({
      required String username,
      required String uid,
      required String description,
      required Uint8List file,
      required String profImage}
      )async{
    String res='some error has occurred';

    try{
         String postUrl= await StorageMethods().uploadImageToStorage('posts',
             file,
             true
         );
          String postId= const Uuid().v1();
         Post post=Post(username: username,
             description: description,
             postId:postId ,
             uid: uid,
             postUrl: postUrl,
             profImage: profImage,
             datePublished: DateTime.now(),
             likes: []
         );

         await _firestore.collection('posts').doc(postId).set(post.toJson());
         res='success';
    }

    catch(err){
      res=err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId , String uid , List likes)async{
    try{
      if(likes.contains(uid)){
        await _firestore.collection('posts').doc(postId).update({
          'likes':FieldValue.arrayRemove([uid]),
        });
      }
      else{
        await _firestore.collection('posts').doc(postId).update({
          'likes':FieldValue.arrayUnion([uid]),
        });
      }
    }
        catch(e){
      print(e.toString());
        }
  }

  Future<void> postComment(String postId,
      String uid,
      String name,
      String text,
      String profImage
      )async{
    try{
      if(text.isNotEmpty){
        String commentId=const Uuid().v1();
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'name':name,
          'profImage':profImage,
          'text':text,
          'uid':uid,
          'commentId':commentId,
          'datePublished':DateTime.now() ,
        });
      }
    }
        catch(e){
      print(e.toString());
        }
  }

  Future<void> deletePost(String postId)async{
    try{
      await _firestore.collection('posts').doc(postId).delete();
    }
        catch(e){
      print(e.toString());
        }
  }
  
  Future<void> followUser( String uid , String followId)async{
    try{
      DocumentSnapshot snap=await _firestore.collection('users').doc(uid).get();
      List following=(snap.data()! as dynamic)['following'];

      if(following.contains(followId)){
        await _firestore.collection('users').doc(uid).update({
          'following' : FieldValue.arrayRemove([followId])
        });

        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
      }

      else{
        await _firestore.collection('users').doc(uid).update({
          'following' : FieldValue.arrayUnion([followId])
        });

        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
      }
    }
        catch(e){
      print(e.toString());
        }
  }
}