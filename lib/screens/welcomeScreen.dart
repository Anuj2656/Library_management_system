import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:librarian/constants.dart';
import 'package:librarian/components/reusableButton.dart';
import 'package:librarian/screens/login.dart';
import 'package:librarian/screens/register.dart';

import 'adminLogin.dart';

final String welcomeId = "/welcome";

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(414, 896));
    return Scaffold(
      backgroundColor: cream,
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width, // Full width of the screen
          height: MediaQuery.of(context).size.height, // Full height of the screen
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  "assets/images/img.png",
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal:50.sp, // Use ScreenUtil for padding
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: ScreenUtil().setHeight(100), // Use ScreenUtil for height
                  ),
                  Icon(
                    Icons.book,
                    size: ScreenUtil().setSp(100), // Use ScreenUtil for icon size
                    color: Color(0xFF6E260E),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(40), // Use ScreenUtil for spacing
                  ),
                  Text(
                    "Librarian",
                    style: TextStyle(
                      fontSize: 35.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6E260E),
                    ),
                  ), // Use ScreenUtil for font size
                  SizedBox(
                    height: ScreenUtil().setHeight(50),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white60,
                      borderRadius: BorderRadius.circular(20.sp),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal:10.sp, // Use ScreenUtil for padding
                      ),
                      child: Column(
                        children: [
                          ReusableButton2(
                            text: "Log In as a User",
                            onPressed: () {
                              Navigator.pushNamed(context, loginId);
                            },
                          ),
                          SizedBox(height: 10.h),
                          ReusableButton2(
                            text: "Log In as an Admin",
                            onPressed: () {
                              Navigator.pushNamed(context, adminLogin);
                            },
                          ),
                          SizedBox(height: 10.h),
                          ReusableButton2(
                            text: "Register",
                            onPressed: () {
                              Navigator.pushNamed(context, registerId);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
