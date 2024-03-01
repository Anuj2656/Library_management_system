import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:librarian/constants.dart';
import 'package:librarian/components/reusableButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

import '../utils/text_utils.dart';

final String requestsId = "/requests";

class ValidateRequests extends StatefulWidget {
  @override
  _ValidateRequestsState createState() => _ValidateRequestsState();
}

class _ValidateRequestsState extends State<ValidateRequests> {
  late String title, email;
  bool spin = false;

  final _firestore = FirebaseFirestore.instance;
  Future<void> addBookRequest() async {
    final userDoc = _firestore.collection('users').doc(email);
    final bookQuery = await _firestore.collection('books').where('title', isEqualTo: title).get();
    setState(() {
      spin = true;
    });
    try {
      final userSnapshot = await userDoc.get();
      print("User data: ${userSnapshot.data()}");

      if (userSnapshot.exists) {
        // Check if the book is already owned by any user
        if (bookQuery.docs.isNotEmpty) {
          // Get book data
          final bookData = bookQuery.docs.first.data() as Map<String, dynamic>;

          // Fetch existing books
          final existingBooks = userSnapshot.data()?['books'] ?? {};

          // Check if the book is already owned by the current user
          if (existingBooks[title] == null) {
            // Add the new book to existing books
            existingBooks[title] = {
              "author": bookData["author"],
              "description": bookData["description"],
              "category": bookData["category"],
            };

            // Update user's books map
            userDoc.update({
              "books": existingBooks,
            });

            // Show success dialog or perform other actions
            StylishDialog dialog = StylishDialog(
              context: context,
              confirmButton: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF800020),
                    ),
                    child: Text('Okay'),
                  ),
                ],
              ),
              alertType: StylishDialogType.SUCCESS,
              style: DefaultStyle(),
              title: Text('Success'),
              content: Text(
                'Book added to User collection!',
                style: TextStyle(fontSize: 18.sp),
              ),
            );
            dialog.show();
            //   showMyDialog2(context, 'Book added to your collection!');
          } else {
            // Book is already owned by the current user
            //  showMyDialog(context, 'You already own this book.');
            StylishDialog dialog2 = StylishDialog(
              context: context,
              confirmButton: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
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
                'User already own this book.',
                style: TextStyle(fontSize: 18.sp),
              ),
            );
            dialog2.show();
          }
        } else {
          // Book not found
          StylishDialog dialog3 = StylishDialog(
            context: context,
            confirmButton: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
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
              'Book Not Found',
              style: TextStyle(fontSize: 18.sp),
            ),
          );
          dialog3.show();
        }
      } else {
        // User not found
        //showMyDialog(context, 'User not found');
        StylishDialog dialog4 = StylishDialog(
          context: context,
          confirmButton: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
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
            'User Not Found',
            style: TextStyle(fontSize: 18.sp),
          ),
        );
        dialog4.show();
      }
    } catch (e) {
      print("Error adding book: $e");
      StylishDialog dialog5 = StylishDialog(
        context: context,
        confirmButton: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF800020),
              ),
              child: Text('Okay'),
            ),
          ],
        ),
        alertType: StylishDialogType.PROGRESS,
        style: DefaultStyle(),
        title: Text('Error'),
        content: Text(
          'An unexpected error occurred. Please try again later.',
          style: TextStyle(fontSize: 18.sp),
        ),
      );
      dialog5.show();
      //   showMyDialog(context, 'An unexpected error occurred. Please try again later.');
    }finally {
      setState(() {
        spin = false; // Reset sendingEmail to false when finished sending email
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
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF800020), // Dark purple color
                  Color(0xFFFF00FF), // White color
                ],
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
                            text: "Give Book to user", weight: true, size: 30.sp,
                          ),
                        ),
                        Spacer(),
                        TextUtil(text: "Email book title",),
                        Container(
                          height: 35.h,
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.white)),
                          ),
                          child: TextField(
                            cursorColor: Color(0xFF800020),
                            style: TextStyle(color: Colors.white),
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              title = value;
                            },
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.mail, color: Colors.white,),
                              fillColor: Colors.white,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Spacer(),
                        TextUtil(
                          text: "Enter your email",
                        ),
                        Container(
                          height: 35.h,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.white),
                            ),
                          ),
                          child: TextField(
                            cursorColor: Color(0xFF800020),
                            style: TextStyle(color: Colors.white),
                            keyboardType: TextInputType.emailAddress,
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
                        ReusableButton(
                          onPressed: addBookRequest,
                          text: "Buy Book",
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
