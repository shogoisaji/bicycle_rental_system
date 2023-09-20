import 'package:bicycle_rental_system/domain/bicycle_model.dart';
import 'package:bicycle_rental_system/domain/time_unit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class StateController extends GetxController {
  // put() is defined in main()
  static StateController instance = Get.find();

// Time Unit State
  Rx<TimeUnit> timeUnitState = TimeUnit.hour.obs;

  void changeTimeTagState(TimeUnit timeUnit) {
    timeUnitState.value = timeUnit;
    calculateTotalPrice();
    update();
  }

  String get unit {
    switch (timeUnitState.value) {
      case TimeUnit.month:
        return 'M';
      case TimeUnit.day:
        return 'D';
      case TimeUnit.hour:
        return 'H';
    }
  }

  int get priceRate {
    switch (timeUnitState.value) {
      case TimeUnit.month:
        return 10 * 13;
      case TimeUnit.day:
        return 10;
      case TimeUnit.hour:
        return 1;
    }
  }

// image
  Uint8List? _memory;

  void setMemory(Uint8List memory) {
    _memory = memory;
    update();
  }

  Uint8List? get memory {
    return _memory;
  }

// cart
  List<dynamic> cart = [].obs;
  RxInt totalPrice = 0.obs;
  RxInt rentPeriod = 1.obs;

  void addCart(Bicycle bicycle) {
    for (Bicycle b in cart) {
      if (b.productId == bicycle.productId) {
        print('already added');
        Get.snackbar(
          'Already added',
          'You have already added this item to your cart.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[400],
          colorText: Colors.white,
          maxWidth: 500,
        );
        return;
      }
    }
    cart.add(bicycle);
    calculateTotalPrice();
    update();
    print('add cart : ${bicycle.productName}');
  }

  void removeCart(Bicycle bicycle) {
    cart.remove(bicycle);
    if (cart.isEmpty) {
      rentPeriod.value = 0;
      print('cart is empty');
    }
    calculateTotalPrice();
    update();
    print('remove cart : ${bicycle.productName}');
  }

  void clearCart() {
    cart.clear();
    calculateTotalPrice();
    update();
  }

  void calculateTotalPrice() {
    int total = 0;
    for (Bicycle b in cart) {
      total += b.pricePerHour * priceRate * rentPeriod.value;
    }
    totalPrice.value = total;
    print(totalPrice.value);
    update();
  }

  void addRentPeriod() async {
    if (cart.isEmpty) {
      return;
    }
    rentPeriod.value++;
    calculateTotalPrice();
    update();
    print('add rentPeriod : ${rentPeriod.value}');
  }

  void removeRentPeriod() {
    if (rentPeriod.value <= 1) {
      return;
    }
    rentPeriod.value--;
    calculateTotalPrice();
    update();
    print('remove rentPeriod : ${rentPeriod.value}');
  }
}
