
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String username;
  final String description;
  final String uid;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profImage;
  final List likes;

  const Post({required this.username,
    required this.description,
    required this.postId,
    required this.uid,
    required this.postUrl,
    required this.profImage,
    required this.datePublished,
    required this.likes
  });

  Map<String, dynamic> toJson() =>
      {
        'username': username,
        'description': description,
        'postId': postId,
        'uid': uid,
        'postUrl': postUrl,
        'profImage': profImage,
        'datePublished': datePublished,
        'likes': likes
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data() as Map<String, dynamic>);
    return Post(username: snapshot['username'],
        description: snapshot['description'],
        postId: snapshot['postId'],
        uid: snapshot['uid'],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage'],
        datePublished: snapshot['datePublished'],
        likes: snapshot['likes']);
  }
}
