import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:librarian/components/reusableButton.dart';
import 'package:librarian/constants.dart';
import 'package:librarian/screens/admin.dart';
import 'package:librarian/screens/user.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

import '../utils/text_utils.dart';

final String AddBooksId = "/AddBooksId";

class AddBook extends StatefulWidget {
  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final _firestore = FirebaseFirestore.instance;
  bool spin = false;
  TextEditingController authorController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController transactionController = TextEditingController();

  final authorValidator = TextEditingController();
  final categoryValidator = TextEditingController();
  final descriptionValidator = TextEditingController();
  final titleValidator = TextEditingController();
  final transactionValidator = TextEditingController();

  void setSpin() {
    setState(() {
      spin = !spin;
    });
  }

  void showErrorMessage(String message) {
    // Implement your error message display logic here,
    // for example, showing a snackbar or dialog.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void showSuccessDialog(BuildContext context) {
    /*
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Book added successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Close the AddBook screen
              },
              child: Text('Okay'),
            ),
          ],
        );
      },
    );
    */
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
        'Book successfully Added !!!',
        style: TextStyle(fontSize: 18.sp),
      ),
    );
    dialog.show();
  }

  void showErrorDialog(BuildContext context) {
    StylishDialog dialog = StylishDialog(
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
        'Book not  Added !!!',
        style: TextStyle(fontSize: 18.sp),
      ),
    );
    dialog.show();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:  Stack(
        children: [
         Container(
        height: 1.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFAE42), // Dark purple color
              Color(0xFFFFA500), // White color
            ],
          ),
        ),
        alignment: Alignment.center,
      ),
           Center(
             child: Container(
               height: 600.h,
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
                             text: "Add New Books", weight: true, size: 30.sp,
                           ),
                         ),
                         Spacer(),
                         TextUtil(text: "Email Author Name",),
                         Container(
                           height: 35.h,
                           decoration: BoxDecoration(
                             border: Border(bottom: BorderSide(color: Colors.white)),
                           ),
                           child: TextField(
                             cursorColor: Color(0xFF800020),
                             style: TextStyle(color: Colors.white),
                             keyboardType: TextInputType.text,
                             controller: authorController,
                             decoration: InputDecoration(
                               suffixIcon: Icon(Icons.person, color: Colors.white,),
                               fillColor: Colors.white,
                               border: InputBorder.none,
                                ),
                           ),
                         ),
                         Spacer(),
                         TextUtil(
                           text: "Enter your Category",
                         ),
                         Container(
                           height: 35.h,
                           decoration: BoxDecoration(
                             border: Border(
                               bottom: BorderSide(color: Colors.white),
                             ),
                           ),
                           child: TextField(
                             keyboardType: TextInputType.text,
                             cursorColor: Color(0xFF800020),
                             style: TextStyle(color: Colors.white),
                             controller: categoryController,
                             decoration: InputDecoration(
                               suffixIcon: Icon(
                                 Icons.category,
                                 color: Colors.white,
                               ),
                               fillColor: Colors.white,
                               border: InputBorder.none,
                               ),
                           ),
                         ),
                         Spacer(),
                         TextUtil(
                           text: "Enter description",
                         ),
                         Container(
                           height: 35.h,
                           decoration: BoxDecoration(
                             border: Border(
                               bottom: BorderSide(color: Colors.white),
                             ),
                           ),
                           child: TextField(
                             keyboardType: TextInputType.text,
                             cursorColor: Color(0xFF800020),
                             style: TextStyle(color: Colors.white),
                             controller: descriptionController,
                             decoration: InputDecoration(
                               suffixIcon: Icon(
                                 Icons.description,
                                 color: Colors.white,
                               ),
                               fillColor: Colors.white,
                               border:InputBorder.none,
                                ),
                             ),
                           ),
                         Spacer(),
                         TextUtil(
                           text: "Enter your title",
                         ),
                         Container(
                           height: 35.h,
                           decoration: BoxDecoration(
                             border: Border(
                               bottom: BorderSide(color: Colors.white),
                             ),
                           ),
                           child: TextField(
                             keyboardType: TextInputType.text,
                             cursorColor: Color(0xFF800020),
                             style: TextStyle(color: Colors.white),
                             controller: titleController,
                             decoration: InputDecoration(
                               suffixIcon: Icon(
                                 Icons.title,
                                 color: Colors.white,
                               ),
                               fillColor: Colors.white,
                               border: InputBorder.none,
                                ),
                           ),
                         ),
                         Spacer(),
                         TextUtil(
                           text: "Enter your Price",
                         ),
                         Container(
                           height: 35.h,
                           decoration: BoxDecoration(
                             border: Border(
                               bottom: BorderSide(color: Colors.white),
                             ),
                           ),
                           child: TextField(
                             keyboardType: TextInputType.number,
                             cursorColor: Color(0xFF800020),
                             style: TextStyle(color: Colors.white),
                             controller: transactionController,
                             decoration: InputDecoration(
                               suffixIcon: Icon(
                                 Icons.price_change,
                                 color: Colors.white,
                               ),
                               fillColor: Colors.white,
                               border: InputBorder.none,
                                ),
                           ),
                         ),
                         ReusableButton(
                           text: "Add Books",
                           onPressed: () async {
                             if (authorController.text.isEmpty ||
                                 categoryController.text.isEmpty ||
                                 descriptionController.text.isEmpty ||
                                 titleController.text.isEmpty ||
                                 transactionController.text.isEmpty) {
                               // Show error message if any field is empty
                              /*
                               setState(() {
                                 authorController.text.isEmpty
                                     ? 'Please enter author name'
                                     : '';
                                 categoryValidator.text =
                                 categoryController.text.isEmpty
                                     ? 'Please enter category'
                                     : '';
                                 descriptionValidator.text =
                                 descriptionController.text.isEmpty
                                     ? 'Please enter description'
                                     : '';
                                 titleValidator.text =
                                 titleController.text.isEmpty
                                     ? 'Please enter title'
                                     : '';
                                 transactionValidator.text =
                                 transactionController.text.isEmpty
                                     ? 'Please enter price'
                                     : '';
                                 // Add similar validation for other text fields
                               });
                              */
                               showErrorMessage('Please fill in all fields');
                             } else {
                               setSpin();
                               try {
                                 // Add the book details to Firestore
                                 await _firestore.collection('books').add({
                                   'author': authorController.text,
                                   'category': categoryController.text,
                                   'description': descriptionController.text,
                                   'title': titleController.text,
                                   'price': transactionController.text,
                                 });

                                 // Optionally, you can add a success message or navigate to another screen
                                 // after successfully adding the book.
                                 print('Book added successfully!');
                                 showSuccessDialog(context);
                               } catch (e) {
                                 print('An error occurred: $e');
                                 showErrorDialog( context);
                               } finally {
                                 setSpin();
                               }
                             }
                           },
                      //     child: Text("Add Books"),
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