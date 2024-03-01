import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const Color cream = Color(0xFFF1E6FF);
const Color orange = Color.fromRGBO(255, 131, 3, 1);
const Color brown = Color(0xFF6F35A5);
const Color black = Color.fromRGBO(27, 26, 23, 1);

const kWelcomeScreen = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
  color: brown,
);

TextStyle buttonText =  TextStyle(
  color: Colors.black,
  fontSize: 20.sp,
);

 TextStyle kLargeText = TextStyle(
  fontSize: 30.sp,
  fontWeight: FontWeight.w800,
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(28.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: orange, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(28.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(28.0)),
  ),
);
const kTextFieldDecoration2 = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(28.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: orange, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(28.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(28.0)),
  ),
);


const kAppText = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,

);
const kAppText2 = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.bold,

);

const kContactDetails = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 23,
  color: black,
);

Future<void> showMyDialog(context, text) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(text),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Back'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showMyDialog2(context, text) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Success'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(text),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Back'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

dynamic currentlyBorrowing(context, text) async {
  List<String> items = text.split(','); // Split text by commas

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: Container(
                child: Image.asset(
                  'assets/images/getbook.gif', // Replace 'assets/loading.gif' with your GIF path
                  width: 200.w,
                  height: 200.h,
                ),
              ),
            ),
            Text(
              'You are currently borrowing:',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                items.length,
                    (index) {
                  // Generate a list of Text widgets with numbers
                  return Text(
                    '${index + 1}. ${items[index].trim()}',
                    style: TextStyle(
                      fontSize: 18.sp,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF800020),
            ),
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showBookDescription(context, title, text) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(text),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Back'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
/*
dynamic browseBooks(context) {
  final _firestore = FirebaseFirestore.instance;
  return StreamBuilder<QuerySnapshot>(
    stream: _firestore.collection('books').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        List<Widget> messageWidgets = [];
        for (var i in snapshot.data.docs) {
          final title = i.data()["title"];
          final author = i.data()["author"];
          final description = i.data()["description"];
          final category = i.data()["category"];
          messageWidgets.add(
            ListTile(
              title: Text('$title by $author'),
              subtitle: Text('Category : $category'),
              onTap: () {
                showBookDescription(context, title, description);
              },
            ),
          );
        }
        return ListView(children: messageWidgets);
      } else {
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.lightBlueAccent,
          ),
        );
      }
    },
  );
}
*/
dynamic browseBooks(context) {
  final _firestore = FirebaseFirestore.instance;
  return StreamBuilder<QuerySnapshot>(
    stream: _firestore.collection('books').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        List<Widget> messageWidgets = [];
        for (var document in snapshot.data!.docs) {
          var data = document.data() as Map<String, dynamic>;
          final title = data["title"];
          final author = data["author"];
          final description = data["description"];
          final category = data["category"];
          final price = data["price"];
          messageWidgets.add(
            Container(
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
                    Icons.book,
                    color: Colors.white54,
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Book Name:- $title'),
                    SizedBox(height: 10.h,),
                    Text('Author Name:- $author'),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h,),
                    Text('Category : $category'),
                    SizedBox(height: 10.h,),
                    Text('Price : $price'),
                    SizedBox(height: 10.h,),
                    Text('Description:- $description'),
                  ],
                ),
                onTap: () {
                  showBookDescription(context, title, description);
                },
              ),
            ),
          );
        }
        return ListView(children: messageWidgets);
      } else {
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.lightBlueAccent,
          ),
        );
      }
    },
  );
}

/*
dynamic getAllUsers(context) {
  final _firestore = FirebaseFirestore.instance;
  dynamic collectionStream = _firestore.collection('users').snapshots();
  return ListView(
    children: collectionStream.data.docs.map((DocumentSnapshot document) {
      return ListTile(
                   title: Text(document.data()?['email'] ?? 'No Email'),
      );
    }).toList(),
  );
}
*/
dynamic getAllUsers(context) {
  final _firestore = FirebaseFirestore.instance;
  return StreamBuilder<QuerySnapshot>(
    stream: _firestore.collection('users').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        List<Widget> userWidgets = [];
        for (var document in snapshot.data!.docs) {
          var data = document.data() as Map<String, dynamic>;
          userWidgets.add(
            ListTile(
              title: Text(data['email'] ?? 'No Email'),
            ),
          );
        }
        return ListView(children: userWidgets);
      } else {
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.lightBlueAccent,
          ),
        );
      }
    },
  );
}
