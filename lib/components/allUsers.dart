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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:librarian/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final String allUsersId = "/allUsers";

class AllUsers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
    IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios,
            color: Colors.black,
            ),

          ),
            Text('List of Users',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
              color: Colors.black
            ),
            ),
       ],
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
              return Center(
                child: Image.asset(
                  'assets/images/loading.gif', // Replace 'assets/loading.gif' with your GIF path
                  width: 100.w,
                  height: 100.h,
                ),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                String email = (document.data() as Map<String, dynamic>?)?['email'] ?? '';
                Map<String, dynamic>? booksData = (document.data() as Map<String, dynamic>?)?['books'] as Map<String, dynamic>?;

                List<String> borrowedBooks = [];

                print('books data for particular email: $booksData');

                if (booksData != null) {
                  borrowedBooks = booksData.keys.toList();
                }

                print('borrowed books for $email: $borrowedBooks');

                return Container(
                  height: 200.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0.sp),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes the position of the shadow
                      ),
                    ],
                  ),
                  margin: EdgeInsets.all(10.sp),
                  child: ListTile(
                    leading: Container(
                      height: double.infinity, // Adjust the height of the icon
                      width: 100.w, // Adjust the width of the icon
                      decoration: BoxDecoration(
                        color: Colors.blue, // You can change the color or use an image here
                        borderRadius: BorderRadius.circular(10.0.sp),
                      ),
                      child: Icon(size: 100.h,
                        Icons.person,
                        color: Colors.white54,
                      ),
                    ),
                    title: Text("$email"),
                    subtitle: (borrowedBooks.isNotEmpty)
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        borrowedBooks.length,
                            (index) => Text("${index + 1}. ${borrowedBooks[index]}"),
                      ),
                    )
                         : Text("Not borrowing any book"),
                  ),
                );
              }).toList(),
            );

              },
        ),
      ),
    );
  }
}
