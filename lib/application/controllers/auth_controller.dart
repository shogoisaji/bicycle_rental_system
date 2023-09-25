import 'package:bicycle_rental_system/application/controllers/state_controller.dart';
import 'package:bicycle_rental_system/infrastructure/firebase/firebase_service.dart';
import 'package:bicycle_rental_system/presentation/pages/list_page.dart';
import 'package:bicycle_rental_system/presentation/pages/sign_in_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  //put is main()
  static AuthController instance = Get.find();
  static StateController stateController = Get.find();

  late Rx<User?> _user;
  Rx<bool> isAdmin = false.obs;
  Rx<String> loginUserName = 'none'.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  String getUid() {
    return _user.value!.uid;
  }

  String getUserName() {
    return _user.value!.uid;
  }

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    // monitor sign in state
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) async {
    if (user == null) {
      Get.offAll(() => SignInPage());
    } else {
      Get.offAll(() => ListPage());
      await FirebaseService().fetchUserData(user.uid).then((value) {
        if (value != null) {
          loginUserName.value = value['userName'];
        }
      });
    }
  }

  void register(String email, String password) async {
    try {
      UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(user.user!.uid)
          .set({
        'userName': email,
        'userEmail': email,
      });
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(), // errorMessageを表示
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(), // errorMessageを表示
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void logout() async {
    stateController.clearCart();
    await auth.signOut();
  }
}
