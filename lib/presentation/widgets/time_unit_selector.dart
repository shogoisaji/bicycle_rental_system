import 'package:bicycle_rental_system/application/controllers/state_controller.dart';
import 'package:bicycle_rental_system/domain/time_unit.dart';
import 'package:bicycle_rental_system/presentation/theme/color_theme.dart';
import 'package:bicycle_rental_system/presentation/widgets/time_tag_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget timeUintSelector() {
  StateController stateController = Get.find<StateController>();
  return Obx(
    () => Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: 150,
      decoration: BoxDecoration(
        color: MyTheme.celeste,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.6),
            spreadRadius: 1.5,
            blurRadius: 4,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          children: [
            InkWell(
                onTap: () {
                  stateController.changeTimeTagState(TimeUnit.month);
                },
                child: timeTagButton(TimeUnit.month)),
          ],
        ),
        InkWell(
            onTap: () {
              stateController.changeTimeTagState(TimeUnit.day);
            },
            child: timeTagButton(TimeUnit.day)),
        InkWell(
            onTap: () {
              stateController.changeTimeTagState(TimeUnit.hour);
            },
            child: timeTagButton(TimeUnit.hour)),
      ]),
    ),
  );
}
