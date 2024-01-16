import 'package:flutter/material.dart';
import 'package:librarian/constants.dart';

final String browseId = "/browseBooks";

class BrowseBooks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      body: browseBooks(context),
    );
  }
}
