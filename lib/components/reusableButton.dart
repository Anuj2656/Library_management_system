import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:librarian/constants.dart';

class ReusableButton extends StatelessWidget {
  ReusableButton({required this.text, required this.onPressed});

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Material(
        elevation: 5.0,
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.w),
        child: MaterialButton(
          onPressed:() => onPressed(),
          minWidth: 450.w,
          height: 50.h,
          child: Text(
            text,
            style: buttonText,
          ),
        ),
      ),
    );
  }
}

class ReusableButton2 extends StatelessWidget {
  ReusableButton2({required this.text, required this.onPressed});

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Material(
        elevation: 5.0,
        color: Color(0xFF800020),
        borderRadius: BorderRadius.circular(20.w),
        child: MaterialButton(
          onPressed:() => onPressed(),
          minWidth: 450.w,
          height: 50.h,
          child: Text(
            text,
            style: TextStyle(
              color: cream,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
