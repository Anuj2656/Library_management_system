import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:librarian/constants.dart';
import 'package:librarian/components/getContact.dart';

final String contactId = "/contact";

class Contact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(416, 896));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: brown,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back_ios),
            ),
          ],
        ),
      ),
      backgroundColor: cream,
      body: Column(
        children: [
          SizedBox(
            height: 300.h, // Set height using screenutil
            child: Center(
              child: Container(
                width: double.infinity,
                color: brown,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.email,
                      size: 100.w, // Set size using screenutil
                      color: cream,
                    ),
                    Text(
                      "Contact Us",
                      style: kAppText.copyWith(
                        color: cream,
                        fontSize: 24.sp, // Set font size using screenutil
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.w), // Set padding using screenutil
            child: Container(
              child: GetContact(),
            ),
          ),
        ],
      ),
    );
  }
}
