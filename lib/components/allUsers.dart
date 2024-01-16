/*
import 'package:flutter/material.dart';
import 'package:librarian/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final String allUsersId = "/allUsers";

class AllUsers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      backgroundColor: cream,
      body: Container(
        padding: EdgeInsets.all(20),
        child: StreamBuilder<QuerySnapshot>(
          stream: users.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                // List<String> borrowedBooks = [];

                // for (var i in document.data()['books']) {
                //   borrowedBooks.add(i["title"]);
                // }
                return ListTile(
                  title: Text("${document.data()['email']},"),
                  subtitle: (document.data()['books']['title'] != "" &&
                          document.data()['books']['title'] != null)
                      ? Text(
                          "currently borrowing : ${document.data()['books']['title']}")
                      : Text("Not borrowing a book"),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:librarian/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final String allUsersId = "/allUsers";

class AllUsers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      appBar: AppBar(
        title: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,
          color: Colors.black,
          ),

        ),
        backgroundColor: cream,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      backgroundColor: cream,
      body: Container(
        padding: EdgeInsets.all(20),
        child: StreamBuilder<QuerySnapshot>(
          stream: users.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                // List<String> borrowedBooks = [];

                // for (var i in document.data()['books']) {
                //   borrowedBooks.add(i["title"]);
                // }

                String email = (document.data() as Map<String, dynamic>?)?['email'] ?? '';
                Map<String, dynamic>? booksData = (document.data() as Map<String, dynamic>?)?['books'] as Map<String, dynamic>?;

                return ListTile(
                  title: Text("$email,"),
                  subtitle: (booksData != null &&
                      booksData['title'] != null &&
                      booksData['title'] != "")
                      ? Text("currently borrowing : ${booksData['title']}")
                      : Text("Not borrowing a book"),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
