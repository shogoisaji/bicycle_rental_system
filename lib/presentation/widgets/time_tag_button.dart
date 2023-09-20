import 'package:bicycle_rental_system/application/controllers/state_controller.dart';
import 'package:bicycle_rental_system/domain/time_unit.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget timeTagButton(
  TimeUnit timeTagIndex,
) {
  var currentTag = Get.find<StateController>().timeUnitState.value;
  return Container(
      child: Column(
    children: [
      timeTagIndex == currentTag
          ? boldText(timeTagIndex.name, Colors.black, 16)
          : mediumText(timeTagIndex.name, Colors.black, 16),
      Center(
        child: Container(
          height: 2,
          width: 20,
          decoration: BoxDecoration(
            color:
                timeTagIndex == currentTag ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ),
    ],
  ));
}
