import 'dart:typed_data';

import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../responsives/mobile_screen_layout.dart';
import '../responsives/web_screen_layout.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;

  bool _isLoading=false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async{
    setState(() {
      _isLoading=true;
    });
    String result = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );
    setState(() {
      _isLoading=false;
    });
    if(result!='success'){
      showSnackBar(result, context);
    }else{
      Navigator.pushNamed(context, 'responsive screen');
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: Container(), flex: 2),
                SvgPicture.asset(
                  'assets/ic_instagram.svg',
                  // ignore: deprecated_member_use
                  color: primaryColor,
                  height: 64,
                ),
                const SizedBox(height: 64),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(_image!),
                    )
                        : const CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage(
                          "https://static.vecteezy.com/system/resources/thumbnails/009/734/564/small/default-avatar-profile-icon-of-social-media-user-vector.jpg"),
                    ),
                    Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo),
                        ))
                  ],
                ),
                const SizedBox(height: 24),
                TextFieldInput(
                  hintText: 'Enter Your username',
                  textInputType: TextInputType.text,
                  textEditingController: _usernameController,
                ),
                const SizedBox(height: 24),
                TextFieldInput(
                  hintText: 'Enter Your Email',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                ),
                const SizedBox(height: 24),
                TextFieldInput(
                  hintText: 'Enter Your Password',
                  textInputType: TextInputType.text,
                  textEditingController: _passwordController,
                  isPass: true,
                ),
                const SizedBox(height: 24),
                TextFieldInput(
                  hintText: 'Enter Your bio',
                  textInputType: TextInputType.text,
                  textEditingController: _bioController,
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    child: _isLoading
                        ? const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                        :const Text('Signup'),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            )),
                        color: blueColor),
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(child: Container(), flex: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text("Have an account?"),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'login');
                      },
                      child: Container(
                        child: Text("Login.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}