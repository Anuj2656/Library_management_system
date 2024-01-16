import 'package:flutter/material.dart';
import 'package:librarian/components/allUsers.dart';
import 'package:librarian/components/reusableButton.dart';
import 'package:librarian/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:librarian/screens/add_books.dart';
import 'package:librarian/screens/changeContact.dart';
import 'package:librarian/screens/validateRequests.dart';
import 'package:librarian/screens/validateReturns.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

final String adminId = "/admin";

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final _auth = FirebaseAuth.instance;

  var loggedInUser;

  void getCurrentUser() {
    try {
      final thisUser = _auth.currentUser;
      if (thisUser != null) {
        loggedInUser = thisUser;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 50,
        ),
        child: ListView(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    _auth.signOut();
                    print("Logging out");
                    Navigator.pop(context);
                    // print("Testing");
                  },
                ),
                Expanded(child: Container()),
                Text(
                  "Admin",
                  style: kAppText2,
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            ReusableButton(
              text: "Validate requests",
              onPressed: () {
                Navigator.pushNamed(context, requestsId);
              },
            ),
            ReusableButton(
              text: "Validate returns",
              onPressed: () {
                Navigator.pushNamed(context, returnId);
              },
            ),
            ReusableButton(
              text: "Manage contact",
              onPressed: () {
                Navigator.pushNamed(context, changeContactId);
              },
            ),
            ReusableButton(
              text: "Add a book",
              onPressed: () {
                Navigator.pushNamed(context, AddBooksId);
              },
            ),
    ReusableButton(
    text: "List of users",
    onPressed: () {
    Navigator.pushNamed(context, allUsersId);
    },
    ),
          ],
        ),
      ),
    );
  }
}
