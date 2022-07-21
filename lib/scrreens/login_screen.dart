import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout.dart';
import 'package:instagram_clone/scrreens/signup_screen.dart';
// import 'package:instagram_clone/scrreens/home_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_input_field.dart';

import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController =  TextEditingController();
  bool isLoading=false;


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  void loginUser()async{
    setState(() {
      isLoading=true;
    });
    String res= await AuthMethods().logInUser(email: _emailController.text, password: _passwordController.text);
     if(res =='Success'){
       Navigator.of(context).pushReplacement(
         MaterialPageRoute(builder: (context)=>ResponsiveLayout(mobileScreenLayout: MobileScreenLayout(),
             webScreenLayout: WebScreenLayout())),
       );
     }
     else{
       showSnackBar(res, context);
     }

    setState(() {
      isLoading=false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(flex: 2,child: Container(),),
                SvgPicture.asset('assets/logo.svg',color: primaryColor,height: 64.0,),
                const SizedBox(height: 64.0,),
                TextInputField(textInputType: TextInputType.emailAddress,
                    textEditingController: _emailController,
                    hintText: 'Enter your email'
                ),
                const SizedBox(height: 24.0,),
                TextInputField(textInputType: TextInputType.visiblePassword,
                    textEditingController: _passwordController,
                    hintText: 'Enter your password',
                  isPass: true,
                ),
                const SizedBox(height: 30.0,),
                InkWell(
                  onTap: (){
                    loginUser();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        ),
                      color: blueColor,
                    ),
                    child: isLoading? const CircularProgressIndicator(
                      color: primaryColor,
                    ) : const Text('Log In'),
                  ),
                ),
                const SizedBox(height: 24.0,),
                Flexible(flex: 2,child: Container(),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: const Text('Don\'t have an account? '),
                    ),
                    GestureDetector(
                      onTap: (){
                         Navigator.of(context).
                        pushReplacement(MaterialPageRoute(builder: (context)=> SignupScreen()));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: const Text('Sign Up',
                        style:  TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
    );
  }
}
