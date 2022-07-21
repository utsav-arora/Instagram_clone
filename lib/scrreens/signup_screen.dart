import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/scrreens/login_screen.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_input_field.dart';

import '../utils/colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController =  TextEditingController();
  final TextEditingController _bioController =  TextEditingController();
  final TextEditingController _usernameController =  TextEditingController();
  Uint8List? _image;
  bool isLoading =false;



  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage()async{
    Uint8List im =await pickImage(ImageSource.gallery);
     setState(() {
       _image=im;

     });

  }


  void signupUser()async{
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        bio: _bioController.text,
        file: _image!
    );
    print(res);
    if(res!='Success'){
      showSnackBar(res, context);
    }
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Flexible(flex: 2,child: Container(),),
                SvgPicture.asset('assets/logo.svg',color: primaryColor,height: 64.0,),
                const SizedBox(height: 32.0,),
                Stack(
                  children: [
                    (_image!=null)?
                     CircleAvatar(
                      radius: 64.0,
                      backgroundImage:MemoryImage(_image!),
                    )
                    :const CircleAvatar(
                      radius: 64.0,
                      backgroundImage: NetworkImage('https://unsplash.com/photos/Z4rqvRpRj38'),
                    ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(onPressed: ()=> selectImage(),
                          icon: const Icon(Icons.add_a_photo)),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0,),
                TextInputField(textInputType: TextInputType.text,
                    textEditingController: _usernameController,
                    hintText: 'Enter your username'
                ),
                const SizedBox(height: 24.0,),
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
                const SizedBox(height: 24.0,),
                TextInputField(textInputType: TextInputType.text,
                    textEditingController: _bioController,
                    hintText: 'Enter your bio'
                ),
                const SizedBox(height: 30.0,),
                InkWell(
                  onTap: (){
                    signupUser();
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
                    child: isLoading ? const Center(child: CircularProgressIndicator(
                      color: primaryColor,
                    ),):const Text('Sign Up'),
                  ),
                ),
                const SizedBox(height: 24.0,),
                // Flexible(flex: 2,child: Container(),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: const Text('Already have an account? '),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).
                        pushReplacement(MaterialPageRoute(builder: (context)=> LoginScreen()));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: const Text('Log In ',
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
      ),
    );
  }
}
