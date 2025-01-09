import 'package:flutter/material.dart';

class Discount extends StatefulWidget {
  const Discount({super.key});

  @override
  State<Discount> createState() => _DiscountState();
}

class _DiscountState extends State<Discount> {
  TextEditingController discountcontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Text(
            'Enter the Discount in %',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 60,
            margin: EdgeInsets.only(right: 10, left: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF475269),
                    blurRadius: 5,
                    spreadRadius: 1,
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextField(
                controller: discountcontroller,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter the Discount in %',
                    hintStyle: TextStyle(fontSize: 20),
                    labelText: 'Discount %',
                    labelStyle: TextStyle(fontSize: 20)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 55,
              width: 85,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromARGB(255, 196, 91, 83)),
              child: Center(
                  child: Text(
                'Done',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              )),
            ),
          )
        ],
      )),
    );
  }
}
