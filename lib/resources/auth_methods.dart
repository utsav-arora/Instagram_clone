import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/resources/storage_methods.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<UserModel> getUserDetails()async{
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =await _firestore.collection('users').doc(currentUser.uid).get();
    return UserModel.fromSnap(snap);
  }

  Future<String> signUpUser({
  required String username,
    required String email,
    required String password,
    required String bio,
    required Uint8List file
}) async{
    String res='Some error has occurred';
    try{
      if(email.isNotEmpty || username.isNotEmpty || password.isNotEmpty || bio.isNotEmpty){
        UserCredential cred =await _auth.createUserWithEmailAndPassword(email: email, password: password);
        print(cred.user!.uid);
        String photoUrl = await StorageMethods().uploadImageToStorage('Profile pics', file, false);
         
        UserModel user = UserModel(email: email, photoUrl: photoUrl, uid: cred.user!.uid, username: username, bio: bio, followers: [], following: []);

      await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
      res = 'Success';
      }
    }
        catch(err){
      res = err.toString();
        }
        return res;
  }

  Future<String>logInUser({required String email,
  required String password
  })async{
    String res='Some error has occurred';

    try{
      if(email.isNotEmpty || password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res='Success';
      }
      else{
        res='Enter all the fields';
      }
    }
    catch(err){
      res=err.toString();
    }
    return res;
  }

  Future<void> signOut()async{
    await _auth.signOut();
  }
}