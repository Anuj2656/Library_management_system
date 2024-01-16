import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:librarian/components/reusableButton.dart';
import 'package:librarian/constants.dart';
import 'package:librarian/screens/admin.dart';
import 'package:librarian/screens/user.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  void setSpin() {
    setState(() {
      spin = !spin;
    });
  }

  void showSuccessDialog(BuildContext context) {
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
  }

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
                        "Add New Books",
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
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  controller: authorController,
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter author'),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  controller: categoryController,
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter category'),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  maxLength: 50,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  controller: descriptionController,
                  decoration: kTextFieldDecoration2.copyWith(
                      hintText: 'Enter description'),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  controller: titleController,
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter title'),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  controller: transactionController,
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter Price'),
                ),
                ReusableButton(
                  text: "Add Books",
                  onPressed: () async {
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
                    } finally {
                      setSpin();
                    }
                  },
             //     child: Text("Add Books"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}