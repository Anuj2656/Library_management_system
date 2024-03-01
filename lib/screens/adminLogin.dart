import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:librarian/components/reusableButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:stylish_dialog/stylish_dialog.dart';
import '../data/bg_data.dart';
import '../utils/animations.dart';
import '../utils/text_utils.dart';
import 'admin.dart';

final String adminLogin = "/AdminLogin";

class AdminLogin extends StatefulWidget {
  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late String password;
  bool spin = false;
  int selectedIndex = 0;
  bool showOption = false;


  void setSpin() {
    setState(() {
      spin = !spin;
    });
  }

  late String email;

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
              child: showOption
                  ? ShowUpAnimation(
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
                          backgroundColor: selectedIndex == index
                              ? Colors.white
                              : Colors.transparent,
                          child: Padding(
                            padding: EdgeInsets.all(1.w),
                            child: CircleAvatar(
                              radius: 30.w,
                              backgroundImage: AssetImage(
                                bgList3[index],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              )
                  : SizedBox(),
            ),
            SizedBox(width: 20.w),
            showOption
                ? GestureDetector(
              onTap: () {
                setState(() {
                  showOption = false;
                });
              },
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 30.sp,
              ),
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
                    backgroundImage: AssetImage(
                      bgList3[selectedIndex],
                    ),
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
              image: AssetImage(bgList3[selectedIndex]),
              fit: BoxFit.fill,
            ),
          ),
          alignment: Alignment.center,
         ),
           Center(
             child: Container(
              height: 400.h,
              width: 1.sw,
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
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),
                        Center(
                          child: TextUtil(
                            text: "Admin Login",
                            weight: true,
                            size: 30.sp,
                          ),
                        ),
                        Spacer(),
                        TextUtil(
                          text: "Email",
                        ),
                        Container(
                          height: 35.h,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.white),
                            ),
                          ),
                          child: TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: Color(0xFF800020),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            onChanged: (value) {
                              email = value;
                            },
                            decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.mail,
                                color: Colors.white,
                              ),
                              fillColor: Colors.white,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Spacer(),
                        TextUtil(
                          text: "Password",
                        ),
                        Container(
                          height: 35.h,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.white),
                            ),
                          ),
                          child: TextField(
                            controller: passwordController,
                            obscureText: true,
                            cursorColor: Color(0xFF800020),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            onChanged: (value) {
                              password = value;
                            },
                            decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.lock,
                                color: Colors.white,
                              ),
                              fillColor: Colors.white,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Spacer(),
                        ReusableButton(
                          text: "Log in",
                          onPressed: () async {
                            setSpin();
                            try {
                              UserCredential userCredential =
                              await _auth.signInWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
                              if (userCredential != null) {
                                if (email == "admin@admin.com" &&
                                    password == "123456") {
                                  Navigator.pushNamed(context, adminId);
                                  emailController.clear();
                                  passwordController.clear();
                                } else {
                                  StylishDialog dialog4 = StylishDialog(
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
                                    context: context,
                                    alertType: StylishDialogType.ERROR,
                                    style: DefaultStyle(),
                                    title: Text('Error'),
                                    content: Text(
                                      'you have not permission for Admin Portal',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                  );
                                  dialog4.show();
                                }
                              }
                              setSpin();
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                print('No user found for that email.');
                                StylishDialog dialog = StylishDialog(
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
                                  context: context,
                                  alertType: StylishDialogType.ERROR,
                                  style: DefaultStyle(),
                                  title: Text('Error'),
                                  content: Text(
                                    'No user found for that email.',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                );
                                dialog.show();
                              } else if (e.code == 'wrong-password') {
                                print('Wrong password provided for that user.');
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
                                    'Wrong password provided for that user.',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                );
                                dialog2.show();
                              } else {
                                print('An unexpected error occurred: $e');
                                StylishDialog dialog3 = StylishDialog(
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
                                    'An unexpected error occurred. Maybe user does not exist or wrong password.',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                );
                                dialog3.show();
                              }
                              setSpin();
                            } catch (e) {
                              print("message is : $e");
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
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                  ),
                                ),
                              );
                              dialog5.show();
                              setSpin();
                            }
                          },
                        ),
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
