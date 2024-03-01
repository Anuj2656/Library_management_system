import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:librarian/screens/login.dart';
import 'package:librarian/screens/user.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

import '../components/reusableButton.dart';
import '../constants.dart';
import '../utils/animations.dart';
import '../utils/text_utils.dart';
import '../data/bg_data.dart';

final String registerId = "/register";

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late String password;
  late String email;
  int selectedIndex = 0;
  bool showOption = false;
  bool spin = false;

  void setSpin() {
    setState(() {
      spin = !spin;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      floatingActionButton: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        height: 49.h,
        width: 1.sw,
        child: Row(
          children: [
            Expanded(
              child: showOption ? ShowUpAnimation(
                delay: 100,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: bgList2.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: CircleAvatar(
                        radius: 30.w,
                        backgroundColor: selectedIndex == index ? Colors.white : Colors.transparent,
                        child: Padding(
                          padding: EdgeInsets.all(1.w),
                          child: CircleAvatar(
                            radius: 30.w,
                            backgroundImage: AssetImage(bgList2[index]),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ) : SizedBox(),
            ),
            SizedBox(width: 20.w),
            showOption
                ? GestureDetector(
              onTap: () {
                setState(() {
                  showOption = false;
                });
              },
              child: Icon(Icons.close, color: Colors.white, size: 30.w),
            )
                : GestureDetector(
              onTap: () {
                setState(() {
                  showOption = true;
                });
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(1.w),
                  child: CircleAvatar(
                    radius: 30.w,
                    backgroundImage: AssetImage(bgList2[selectedIndex]),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
        Container(
          height: 1.sh,
          width: 1.sw,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(bgList2[selectedIndex]),
              fit: BoxFit.fill,
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
                    padding: EdgeInsets.all(25.w),
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
                            text: "Register",
                            weight: true,
                            size: 30.sp,
                          ),
                        ),
                        Spacer(),
                        TextUtil(text: "Email"),
                        Container(
                          height: 35.h,
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.white)),
                          ),
                          child: TextField(
                            controller: emailController,
                            cursorColor: Color(0xFF800020),
                            style: TextStyle(color: Colors.white),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              email = value;
                            },
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.mail, color: Colors.white,),
                              fillColor: Colors.white,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Spacer(),
                        TextUtil(text: "Password"),
                        Container(
                          height: 35.h,
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.white)),
                          ),
                          child: TextField(
                            obscureText: true,
                            cursorColor: Color(0xFF800020),
                            controller: passwordController,
                            style: TextStyle(color: Colors.white),
                            onChanged: (value) {
                              password = value;
                            },
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.lock, color: Colors.white,),
                              fillColor: Colors.white,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Spacer(),
                        ReusableButton(
                          text: "Register",
                          onPressed: () async {
                            setSpin();
                            try {
                              final newUser = await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);
                              if (newUser != null) {
                                Navigator.pushNamed((context), userRegisterId);
                              }
                            emailController.clear();
                              passwordController.clear();
                              setSpin();
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                print('The password provided is too weak.');
                                StylishDialog dialog = StylishDialog(
                                  context: context,
                                  confirmButton: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          emailController.clear();
                                          passwordController.clear();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFF800020),
                                        ),
                                        child: Text('Okay'),
                                      ),
                                    ],
                                  ),
                                  alertType: StylishDialogType.WARNING,
                                  style: DefaultStyle(),
                                  title: Text('Wait'),
                                  content: Text(
                                    'The password provided is too weak.',
                                    style: TextStyle(fontSize: 18.sp),
                                  ),
                                );
                                dialog.show();
                              } else if (e.code == 'email-already-in-use') {
                                print('The account already exists for that email.');
                                 StylishDialog dialog2 = StylishDialog(
                                  context: context,
                                  confirmButton: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          emailController.clear();
                                          passwordController.clear();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFF800020),
                                        ),
                                        child: Text('Okay'),
                                      ),
                                    ],
                                  ),
                                  alertType: StylishDialogType.ERROR,
                                  style: DefaultStyle(),
                                  title: Text('Error'),
                                  content: Text(
                                    'The account already exists for that email.',
                                    style: TextStyle(fontSize: 18.sp),
                                  ),
                                );
                                dialog2.show();
                              }
                              setSpin();
                            } catch (e) {
                              print(e);
                              StylishDialog dialog5 = StylishDialog(
                                context: context,
                                confirmButton: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        emailController.clear();
                                        passwordController.clear();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF800020),
                                      ),
                                      child: Text('Okay'),
                                    ),
                                  ],
                                ),
                                alertType: StylishDialogType.WARNING,
                                style: DefaultStyle(),
                                title: Text('Wait'),
                                content: Text(
                                  e.toString(),
                                  style: TextStyle(fontSize: 18.sp),
                                ),
                              );
                              dialog5.show();
                              setSpin();
                            }
                          },
                        ),
                        Spacer(),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(fontSize: 15.sp, color: Colors.white),
                              children: <TextSpan>[
                                TextSpan(
                                  text: "LOGIN",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Navigate to the signup screen
                                     Navigator.pushNamed(context, loginId);
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
          ),
           ),
          if (spin)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Image.asset(
                  'assets/images/loading.gif',
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
