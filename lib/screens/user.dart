import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:librarian/constants.dart';
import 'package:librarian/components/reusableButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:librarian/screens/browseBooks.dart';
import 'package:librarian/screens/buy_book.dart';
import 'package:librarian/screens/contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final userRegisterId = "/userRegister";
final userLoginId = "/userLogin";

class User extends StatefulWidget {
  final bool newUser;
  User({required this.newUser});
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  final _auth = FirebaseAuth.instance;
  var loggedInUser;
  var books;

  // final _firestore = FirebaseFirestore.instance;
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
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final thisUser = _auth.currentUser;
      if (thisUser != null) {
        loggedInUser = thisUser;
        String userEmail = thisUser.email.toString();

        if (widget.newUser == true) {
          await addUser(userEmail);
        }

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
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(416, 896));
    return Scaffold(
      backgroundColor: cream,
      body: FutureBuilder<Map<String, dynamic>>(
        future: getCurrentUser(),
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
                      "Welcome",
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
    List<String> ownedBooksTitles = [];

    // Check if books is not null and contains titles
    if (books != null && books.isNotEmpty) {
    ownedBooksTitles = books.keys.toList();
    }

    currentlyBorrowing(context,
    ownedBooksTitles.isNotEmpty ? ownedBooksTitles.join(", ") : "No books");
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
                                     image: AssetImage('assets/books/buy_books.jpg'),
                                     fit: BoxFit.cover,
                                   ),
                                   borderRadius: BorderRadius.circular(10.sp),
                                 ),
                                 height: 250.h,
                                 width:   double.infinity,
                                 child: Container(
                                   decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(10.sp),
                                     color: Colors.black.withOpacity(0.3), // Adjust the opacity level as needed
                                   ),
                                   child: Padding(
                                     padding: EdgeInsets.all(10.sp),
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Align(
                                           alignment: Alignment.topLeft,
                                           child: Text(
                                             'My Books',
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
                                             'Here you see your books which you buy from library',
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
                                     List<String> ownedBooksTitles = [];

                                     // Check if books is not null and contains titles
                                     if (books != null && books.isNotEmpty) {
                                       ownedBooksTitles = books.keys.toList();
                                     }

                                     currentlyBorrowing(
                                         context,
                                         ownedBooksTitles.isNotEmpty
                                             ? ownedBooksTitles.join(", ")
                                             : "No books");
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
                          Navigator.pushNamed(context, browseId);
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
                                        image: AssetImage('assets/books/search_books.jpg'),
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
                                                'Search books',
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
                                                'Explore the library"s vast collection with ease, finding your desired books quickly',
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
                                        Navigator.pushNamed(context, browseId);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                                        color: Colors.white,
                                        child: Text(
                                          'Explore Books',
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
                          Navigator.pushNamed(context, BuyBookId);
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
                                        image: AssetImage('assets/books/buy_new_books.jpg'),
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
                                                'Buy New Books',
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
                                                'Discover and purchase new books to add to your collection, expanding your reading horizons effortlessly.',
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
                                        Navigator.pushNamed(context, BuyBookId);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                                        color: Colors.white,
                                        child: Text(
                                          'Buy Books',
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
                          Navigator.pushNamed(context, contactId);
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
                                        image: AssetImage('assets/books/contact_us.jpg'),
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
                                                'Contact us',
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
                                                'Have questions or feedback? Contact us anytime – we are here to assist you promptly and courteously',
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
                                        Navigator.pushNamed(context, contactId);
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
              ],
            );
          }
        },
      ),
    );
  }
}
