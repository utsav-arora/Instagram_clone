import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/scrreens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';

import '../widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData={};
  int postLen=0;
  int followers=0;
  int following=0;
  bool isLoading=false;
  bool isFollowing=false;

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }


  getData()async{
    setState(() {isLoading=true;});
    try{
     var userSnap =await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();

     var postSnap= await FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
     postLen= postSnap.docs.length;
     if(userSnap.data()!['followers'] == null){
       followers=0;
     }
     followers= userSnap.data()!['followers'].length;
     if(userSnap.data()!['following'] == null){
       following=0;
     }
     following= userSnap.data()!['following'].length;
     userData= userSnap.data()!;
     isFollowing=userSnap.data()!['following'].contains(FirebaseAuth.instance.currentUser!.uid);
     setState(() { });
    }
        catch(e){
      showSnackBar(e.toString(), context);
        }
        setState(() {isLoading=false;});
  }
  @override
  Widget build(BuildContext context) {
    return isLoading? const Center(child: CircularProgressIndicator(),) :
    Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(userData['username']),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                         userData['photoUrl'] ),
                      radius: 40.0,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStatCol(postLen, 'posts'),
                              buildStatCol(followers, 'Followers'),
                              buildStatCol(following, 'Following'),
                            ],
                          ),
                          Row(
                            children: [ FirebaseAuth.instance.currentUser!.uid == widget.uid
                              ?  FollowButton(
                                text: 'Sign Out',
                                buttonColor: mobileBackgroundColor,
                                borderColor: Colors.grey,
                                textColor: primaryColor,
                                function: () async{
                                  await AuthMethods().signOut();
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const LoginScreen(),
                                  ),
                                  );
                                },
                              ):
                                isFollowing ?
                                FollowButton(
                                  text: 'Unfollow',
                                  buttonColor: Colors.white,
                                  borderColor: Colors.grey,
                                  textColor: Colors.black,
                                  function: () async{
                                    await FirestoreMethods().followUser(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        userData['uid'],
                                    );
                                    setState(() {
                                      isFollowing=false;
                                      followers--;
                                    });
                                  },
                                ) :
                                FollowButton(
                                  text: 'Follow',
                                  buttonColor: Colors.blue,
                                  borderColor: Colors.blue,
                                  textColor: Colors.white,
                                  function: () async{
                                    await FirestoreMethods().followUser(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      userData['uid'],
                                    );
                                    setState(() {
                                      isFollowing=true;
                                      followers++;
                                    });
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:const EdgeInsets.only(top: 4.0),
                  alignment: Alignment.centerLeft,
                  child: Text(userData['username'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                  ),
                ),
                Container(
                  padding:const EdgeInsets.only(top: 4.0),
                  alignment: Alignment.centerLeft,
                  child: Text(userData['bio']),
                ),
              ],
            ),
          ),
          const Divider(),
          FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: widget.uid).get(),
              builder: (context , snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator(),);
                }
                return GridView.builder(
                  shrinkWrap: true,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 1.5 , childAspectRatio: 1),
                    itemBuilder: (context , index){
                    DocumentSnapshot snap= (snapshot.data! as dynamic).docs[index];
                    return Container(
                      child: Image(
                        image: NetworkImage(
                          snap['postUrl']
                        ),
                        fit: BoxFit.cover,
                      ),
                    );
                    },
                );
              }
          ),
        ],
      ),
    );
  }

  Column buildStatCol(int num, String label) {
    return Column(
      children: [
        Text(
          num.toString(),
          style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4.0),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        )
      ],
    );
  }
}
