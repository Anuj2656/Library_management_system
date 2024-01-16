import 'package:flutter/material.dart';
import 'package:librarian/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:librarian/components/reusableButton.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

final String BuyBookId = "/BuyBookId";

class BuyBook extends StatefulWidget {
  @override
  _BuyBookState createState() => _BuyBookState();
}

class _BuyBookState extends State<BuyBook> {
  late String title, email;
  bool spin = false;
  void setSpin() {
    setState(() {
      spin = !spin;
    });
  }
  final _firestore = FirebaseFirestore.instance;
  Future<void> addBookRequest() async {
    final userDoc = _firestore.collection('users').doc(email);
    final bookQuery = await _firestore.collection('books').where('title', isEqualTo: title).get();

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
            Navigator.pop(context);
            showMyDialog2(context, 'Book added to your collection!');
          } else {
            // Book is already owned by the current user
            showMyDialog(context, 'You already own this book.');
          }
        } else {
          // Book not found
          showMyDialog(context, 'Book not found');
        }
      } else {
        // User not found
        showMyDialog(context, 'User not found');
      }
    } catch (e) {
      print("Error adding book: $e");
      showMyDialog(context, 'An unexpected error occurred. Please try again later.');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: ModalProgressHUD(
        inAsyncCall: spin,
        child: SingleChildScrollView(

          child: Container(
            padding: EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    },
                        icon: Icon(Icons.arrow_back_ios)
                    ),
                    Expanded(child: Container()),
                    Text(
                      "Buy Book",
                      style: kAppText,
                    ),
                  ],
                ),
                SizedBox(
                  height: 100,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    title = value;
                  },
                  decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Enter book title'),
                ),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your email',
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
    );
  }
}
