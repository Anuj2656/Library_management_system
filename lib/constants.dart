import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const Color cream = Color(0xFFF1E6FF);
const Color orange = Color.fromRGBO(255, 131, 3, 1);
const Color brown = Color(0xFF6F35A5);
const Color black = Color.fromRGBO(27, 26, 23, 1);

const kWelcomeScreen = TextStyle(
  fontSize: 60,
  fontWeight: FontWeight.bold,
  color: brown,
);

const kButtonText = TextStyle(
  color: cream,
  fontSize: 20,
  letterSpacing: 4,
  // fontFamily: "Oswald",
  fontWeight: FontWeight.w700,
);

const kLargeText = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.w800,
  letterSpacing: 4,
  // fontFamily: "Oswald",
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
  letterSpacing: 1,
);
const kAppText2 = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.bold,
  letterSpacing: 1,
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
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('I am currently borrowing: '),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(text),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Ok'),
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
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes the position of the shadow
                  ),
                ],
              ),
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                title: Text('$title by $author'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Category : $category'),
                    Text('Price : $price'),
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
