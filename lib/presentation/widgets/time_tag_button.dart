import 'package:bicycle_rental_system/domain/time_tag.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:flutter/material.dart';

Widget timeTagButton(TimeTag timeTagIndex, bool isChecked) {
  return Container(
      child: Column(
    children: [
      isChecked
          ? boldText(timeTagIndex.name, Colors.black, 16)
          : mediumText(timeTagIndex.name, Colors.black, 16),
      Center(
        child: Container(
          height: 2,
          width: 20,
          decoration: BoxDecoration(
            color: isChecked ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ),
    ],
  ));
}
