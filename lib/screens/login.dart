import 'package:flutter/material.dart';
import 'package:librarian/components/reusableButton.dart';
import 'package:librarian/constants.dart';
import 'package:librarian/screens/admin.dart';
import 'package:librarian/screens/user.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';

final String loginId = "/login";

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  late String password;
  bool spin = false;
  void setSpin() {
    setState(() {
      spin = !spin;
    });
  }

  late String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: ModalProgressHUD(
        inAsyncCall: spin,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 60, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                children: [
                  IconButton(onPressed: (){
                    Navigator.pop(context);

                  }, icon: Icon(Icons.arrow_back_ios)),
                  Expanded(child: Container()),
                  Container(
                    child: Text(
                      "Welcome Back!",
                      style: kLargeText,
                    ),
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
               ],
              ),
                SizedBox(
                  height: 50,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email'),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password'),
                ),
                SizedBox(
                  height: 50,
                ),
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
                        } else {
                          Navigator.pushNamed(context, userLoginId);
                        }
                      }
                      setSpin();
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                        showMyDialog(context, 'No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                        showMyDialog(
                            context, 'Wrong password provided for that user.');
                      }else {
                        print('An unexpected error occurred: $e');
                        showMyDialog(
                          context,
                          'An unexpected error occurred.maybe user does not exist or wrong password.',
                        );
                      }
                      setSpin();
                    } catch (e) {
                      print("message is : $e");
                      showMyDialog(context, e.toString());
                      setSpin();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


final String loginId2 = "/login2";

class Login2 extends StatefulWidget {
  @override
  _Login2State createState() => _Login2State();
}

class _Login2State extends State<Login2> {
  final _auth = FirebaseAuth.instance;
  late String password;
  bool spin = false;
  void setSpin() {
    setState(() {
      spin = !spin;
    });
  }

  late String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: ModalProgressHUD(
        inAsyncCall: spin,
        child: SingleChildScrollView(
          child: Container(
           padding: EdgeInsets.symmetric(vertical: 60, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(onPressed: (){
Navigator.pop(context);
                    }, icon: Icon(Icons.arrow_back_ios)),
               //     Expanded(child: Container()),

                    Container(
                      child: Text(
                        "Welcome Back!",
                        style: kLargeText,
                      ),
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email'),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password'),
                ),
                SizedBox(
                  height: 50,
                ),
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
                        } else {
                          showMyDialog(context, 'you have not permission for Admin Portal');
                        }
                      }
                      setSpin();
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                        showMyDialog(context, 'No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                        showMyDialog(
                            context, 'Wrong password provided for that user.');
                      }else {
                        print('An unexpected error occurred: $e');
                        showMyDialog(
                          context,
                          'An unexpected error occurred.maybe user does not exist or wrong password.',
                        );
                      }
                      setSpin();
                    } catch (e) {
                      print("message is : $e");
                      showMyDialog(context, e.toString());
                      setSpin();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}