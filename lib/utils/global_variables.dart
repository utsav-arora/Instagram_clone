import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/scrreens/add_post_screen.dart';
import 'package:instagram_clone/scrreens/feed_screen.dart';
import 'package:instagram_clone/scrreens/profile_screen.dart';
import 'package:instagram_clone/scrreens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenWidget =[
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),


  const Center(child: Text('notification'),),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];