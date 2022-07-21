import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/scrreens/login_screen.dart';
import 'package:instagram_clone/scrreens/signup_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> UserProvider(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        // home:const ResponsiveLayout(
        //   mobileScreenLayout: MobileScreenLayout(),
        //   webScreenLayout: WebScreenLayout(),
        // ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context , snapshot){
             if(snapshot.connectionState == ConnectionState.active){
               if(snapshot.hasData){
                 return const ResponsiveLayout(
                   mobileScreenLayout: MobileScreenLayout(),
                   webScreenLayout: WebScreenLayout(),
                 );
               }
               else if(snapshot.hasError){
                 return Center(child: Text('${snapshot.error}'),);
               }
             }
             if(snapshot.connectionState == ConnectionState.waiting){
               return const Center(child: CircularProgressIndicator(color: primaryColor,),);
             }
             return LoginScreen();
          },
        ),
      ),
    );
  }
}
