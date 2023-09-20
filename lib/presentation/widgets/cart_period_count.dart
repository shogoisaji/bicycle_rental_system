import 'package:bicycle_rental_system/application/controllers/state_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget cartPeriodCount() {
  StateController stateController = Get.find();

  return Container(
    width: 120,
    height: 30,
    child: Stack(
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  stateController.removeRentPeriod();
                },
                child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 3),
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.red[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.remove,
                      color: Colors.white,
                    )),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  stateController.addRentPeriod();
                },
                child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 3),
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.blue[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: 20)),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 60,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  spreadRadius: 0.5,
                  blurRadius: 3,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Center(
                child: Obx(() => Padding(
                      padding: const EdgeInsets.only(bottom: 1.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(stateController.rentPeriod.toString(),
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500)),
                          Text(stateController.unit,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ))),
          ),
        )
      ],
    ),
  );
}
