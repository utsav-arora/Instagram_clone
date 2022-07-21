import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/scrreens/profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController=TextEditingController();
  bool isShowUser=false;
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
          title: TextFormField(
            controller: searchController,
            decoration:const InputDecoration(
              labelText: 'Search for  a user'
            ),
            onFieldSubmitted: (String s){
              setState(() { isShowUser=true;});
            },
          ),
      ),
      body: isShowUser
        ?FutureBuilder(
        future: FirebaseFirestore.instance.collection('users')
            .where('username', isGreaterThanOrEqualTo: searchController.text)
            .get(), 
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if(!snapshot.hasData){
            return const Center(
              child:  CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context , index){
                return InkWell(
                  onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ProfileScreen(uid: snapshot.data!.docs[index]['uid']),
                  ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data!.docs[index]['photoUrl']),
                    ),
                    title: Text(snapshot.data!.docs[index]['username']),
                  ),
                );
              });
        },
      )
      : FutureBuilder(
          future: FirebaseFirestore.instance.collection('posts').get(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
            if(!snapshot.hasData){
              return const Center(child:  CircularProgressIndicator(),);
            }
            // return StaggeredGridView.countBuilder(
            //   crossAxisCount: 2,
            //   crossAxisSpacing: 10,
            //   mainAxisSpacing: 12,
            //   // itemCount: imageList.length,
            //   itemBuilder: (context, index) {
            //   },
            // );
            return Center(child: Text('Posts'),);
          }
      ),
    );
  }
}
