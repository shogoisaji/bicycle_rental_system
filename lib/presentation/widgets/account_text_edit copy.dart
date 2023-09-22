import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:flutter/material.dart';

Widget accountTextEdit(String item, TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: boldText(item, Colors.grey, 20),
      ),
      Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        // height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            )),
      ),
    ],
  );
}
