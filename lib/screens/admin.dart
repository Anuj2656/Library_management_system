import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(String email) {
    return users
        .doc(email)
        .set({
      'email': email,
      'books': {},
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
  Future<Map<String, dynamic>> getCurrentallUser() async {
    try {
      final thisUser = _auth.currentUser;
      if (thisUser != null) {
        loggedInUser = thisUser;
        String userEmail = thisUser.email.toString();
/*
        if (widget.newUser == true) {
          await addUser(userEmail);
        }
*/
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .get();

        if (documentSnapshot.exists) {
          print('Document data: ${documentSnapshot.data()}');
          Map<String, dynamic>? userData =
          documentSnapshot.data() as Map<String, dynamic>?;

          if (userData != null) {
            return userData;
          }
        } else {
          print('Document does not exist on the database');
        }
      }
    } catch (e) {
      print(e);
    }

    return {}; // Return an empty map if there is an error or no data
  }
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(416, 896));
    return Scaffold(
      backgroundColor: cream,
     body: FutureBuilder<Map<String, dynamic>>(
        future: getCurrentallUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Image.asset(
              'assets/images/loading.gif', // Replace 'assets/loading.gif' with your GIF path
              width: 100.w,
              height: 100.h,
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var books = snapshot.data?["books"];
          return ListView(
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
                  SizedBox(
                    width: 100.w,
                  ),
                  Text(
                    "Admin",
                    style: kAppText,
                  ),
                ],
              ),
              SizedBox(
                height: 25.h,
              ),
              Column(
                children: [
                  GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, requestsId);
                              },
                      child:Padding(
                        padding: EdgeInsets.all(10.sp),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/books/val_admin.png'),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10.sp),
                                  ),
                                  height: 250.h,
                                  width:   double.infinity,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.sp),
                                      color: Colors.black.withOpacity(0.4), // Adjust the opacity level as needed
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(10.sp),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Validate requests',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10.h), // Add some space between "My Books" and the new text
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'You can assign books to validate users',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10.sp,
                                  left: 10.sp,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, requestsId);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                                      color: Colors.white,
                                      child: Text(
                                        'Know more',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                  ),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, returnId);
                      },
                      child:Padding(
                        padding: EdgeInsets.all(10.sp),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/books/val_return.png'),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10.sp),
                                  ),
                                  height: 250.h,
                                  width: double.infinity,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.sp),
                                      color: Colors.black.withOpacity(0.5), // Adjust the opacity level as needed
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(10.sp),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Validate returns',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10.h), // Add some space between "My Books" and the new text
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'You can remove books from users accounts.',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10.sp,
                                  left: 10.sp,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, returnId);
                                       },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                                      color: Colors.white,
                                      child: Text(
                                        'Validate return',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                  ),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, changeContactId);
                      },
                      child:Padding(
                        padding: EdgeInsets.all(10.sp),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/books/contact_manage.png'),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10.sp),
                                  ),
                                  height: 250.h,
                                  width: double.infinity,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.sp),
                                      color: Colors.black.withOpacity(0.5), // Adjust the opacity level as needed
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(10.sp),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Manage Contact',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10.h), // Add some space between "My Books" and the new text
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Contact management allows admins to oversee and modify contact information as required.',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10.sp,
                                  left: 10.sp,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, changeContactId);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                                      color: Colors.white,
                                      child: Text(
                                        'Manage your Contact',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                  ),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, AddBooksId);
                      },
                      child:Padding(
                        padding: EdgeInsets.all(10.sp),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/books/add_book.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10.sp),
                                  ),
                                  height: 250.h,
                                  width: double.infinity,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.sp),
                                      color: Colors.black.withOpacity(0.5), // Adjust the opacity level as needed
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(10.sp),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Add a book',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10.h), // Add some space between "My Books" and the new text
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'You can add new books to the collection, providing detailed information and categorization for easy access by users',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10.sp,
                                  left: 10.sp,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, AddBooksId);
                                        },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                                      color: Colors.white,
                                      child: Text(
                                        'Add New Books',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                  ),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, allUsersId);
                      },
                      child:Padding(
                        padding: EdgeInsets.all(10.sp),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/books/list_of_user.png'),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10.sp),
                                  ),
                                  height: 250.h,
                                  width: double.infinity,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.sp),
                                      color: Colors.black.withOpacity(0.5), // Adjust the opacity level as needed
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(10.sp),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'List of Users',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10.h), // Add some space between "My Books" and the new text
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'You can view a list of users, accessing their account and details as needed.',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10.sp,
                                  left: 10.sp,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, allUsersId);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                                      color: Colors.white,
                                      child: Text(
                                        'List Of all Users',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                  ),
                ],
              ),
            ],
          );
        }
      },
    ),
    );
  }
}
