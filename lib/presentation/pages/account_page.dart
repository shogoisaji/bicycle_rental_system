import 'package:bicycle_rental_system/application/config/config.dart';
import 'package:bicycle_rental_system/application/controllers/auth_controller.dart';
import 'package:bicycle_rental_system/presentation/theme/color_theme.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supercharged/supercharged.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find();
    double mWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Padding(
              padding: mWidth < BREAKPOINT1
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.only(left: 60),
              child: boldText(
                  'ACCOUNT', Colors.white, mWidth < BREAKPOINT1 ? 28 : 32)),
          backgroundColor: MyTheme.blue,
          elevation: 0,
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // history list
              boldText('Account Data', Colors.black, 24),
              Container(
                constraints: BoxConstraints(maxWidth: 600),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: MyTheme.lightBlue,
                ),
                margin: EdgeInsets.only(bottom: 16),
                height: 500,
              ),
              boldText('History', Colors.black, 24),
              Container(
                constraints: BoxConstraints(maxWidth: 600),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: MyTheme.lightBlue,
                ),
                margin: EdgeInsets.only(bottom: 16),
                height: 500,
              ),
              ElevatedButton(
                  onPressed: () {
                    authController.logout();
                  },
                  child: boldText('Log out', Colors.white, 24))
            ],
          ),
        )));
  }
}
