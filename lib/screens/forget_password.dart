import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../components/reusableButton.dart';
import '../utils/text_utils.dart';
import 'login.dart';

final String forgetScreen = "/forgetScreen";

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool sendingEmail = false; // Added a state variable to track email sending
  final FirebaseAuth _auth = FirebaseAuth.instance;

  resetPassword() async {
    setState(() {
      sendingEmail = true; // Set sendingEmail to true when sending email
    });
    try {
      await _auth.sendPasswordResetEmail(email: emailController.text.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.blueAccent,
          content: Text(
            'Password Reset Email has been sent !',
            style: TextStyle(fontSize: 15.0.sp, color: Colors.white),
          ),
        ),
      );
      Navigator.pushNamed(context, loginId);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.deepPurpleAccent,
            content: Text(
              'No User Found .',
              style: TextStyle(fontSize: 15.0.sp, color: Colors.white),
            ),
          ),
        );
      }
    } finally {
      setState(() {
        sendingEmail = false; // Reset sendingEmail to false when finished sending email
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 1.sh,
            width: 1.sw,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/forget.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.center,
          ),
          Center(
            child: Container(
              height: 400.h,
              width: 1.sw - 60.w,
              margin: EdgeInsets.symmetric(horizontal: 30.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(15.w),
                color: Colors.black.withOpacity(0.1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.w),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaY: 5.h, sigmaX: 5.w),
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                        ),
                        Spacer(),
                        Center(
                          child: TextUtil(
                            text: "Forget Password", weight: true, size: 30.sp,
                          ),
                        ),
                        Spacer(),
                        TextUtil(text: "Email",),
                        Container(
                          height: 35.h,
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.white)),
                          ),
                          child: TextField(
                            cursorColor: Color(0xFF800020),
                            style: TextStyle(color: Colors.white),
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.mail, color: Colors.white,),
                              fillColor: Colors.white,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Spacer(),
                        ReusableButton(
                          text: "Submit",
                          onPressed: () {
                            resetPassword();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (sendingEmail)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Image.asset(
                  'assets/images/loading.gif', // Replace with your GIF asset path
                  width: 90.w,
                  height: 90.h,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
