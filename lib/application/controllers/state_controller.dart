import 'package:bicycle_rental_system/domain/bicycle_model.dart';
import 'package:bicycle_rental_system/domain/cart_item.dart';
import 'package:bicycle_rental_system/domain/time_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class StateController extends GetxController {
  static StateController instance = Get.find();

// Time Tag State
  TimeTag _timeTagState = TimeTag.hour;

  void changeTimeTagState(TimeTag timeTag) {
    _timeTagState = timeTag;
    update();
  }

  TimeTag get timeTagState {
    return _timeTagState;
  }

  String get unit {
    switch (_timeTagState) {
      case TimeTag.month:
        return 'M';
      case TimeTag.day:
        return 'D';
      case TimeTag.hour:
        return 'H';
    }
  }

  int get priceRate {
    switch (_timeTagState) {
      case TimeTag.month:
        return 10 * 13;
      case TimeTag.day:
        return 10;
      case TimeTag.hour:
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

  void addCart(Bicycle bicycle) {
    for (CartItem c in cart) {
      if (c.bicycle.productId == bicycle.productId) {
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
    CartItem cartItem = CartItem(bicycle: bicycle, rentPeriod: 1);
    cart.add(cartItem);
    calculateTotalPrice();
    update();
    print(cartItem.bicycle.productName);
  }

  void removeCart(CartItem cartItem) {
    cart.remove(cartItem);
    calculateTotalPrice();
    update();
  }

  void clearCart() {
    cart.clear();
    calculateTotalPrice();
    update();
  }

  void calculateTotalPrice() {
    int total = 0;
    for (CartItem c in cart) {
      total += c.bicycle.pricePerHour * c.rentPeriod * priceRate;
    }
    totalPrice.value = total;
    print(totalPrice.value);
    update();
  }

  void addRentPeriod(CartItem cartItem) async {
    cartItem.rentPeriod++;
    calculateTotalPrice();
    update();
    print(cartItem.rentPeriod);
  }

  void removeRentPeriod(CartItem cartItem) {
    if (cartItem.rentPeriod == 1) {
      removeCart(cartItem);
    }
    cartItem.rentPeriod--;
    calculateTotalPrice();
    update();
    print(cartItem.rentPeriod);
  }
}
