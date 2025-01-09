import 'package:e_commerce_grocery_application/global_variable.dart';
import 'package:flutter/material.dart';

buildBottomWithTitleIconWidget(
    {required BuildContext context,
    required String Imageicon,
    required String title,
    required Function onTap}) {
  return InkWell(
    onTap: () {
      onTap();
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        height: 50,
        width: displayWidth(context),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0.5,
              blurRadius: 1,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    Imageicon,
                    height: 20,
                    width: 20,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
              Icon(
                Icons.navigate_next_rounded,
                size: 25,
                color: Colors.black,
              )
            ],
          ),
        ),
      ),
    ),
  );
}
