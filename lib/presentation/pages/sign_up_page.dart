import 'package:bicycle_rental_system/application/config/config.dart';
import 'package:bicycle_rental_system/application/controllers/auth_controller.dart';
import 'package:bicycle_rental_system/presentation/theme/color_theme.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    AuthController authController = Get.find();
    double mWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
            title: Padding(
                padding: mWidth < BREAKPOINT1
                    ? const EdgeInsets.all(0)
                    : const EdgeInsets.only(left: 60),
                child: boldText('BICYCLE RENTAL', Colors.white, 32)),
            backgroundColor: MyTheme.blue,
            elevation: 0),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 30),
              boldText('Sign Up', Colors.grey, 32),
              SizedBox(height: 20),
              Container(
                width: 300,
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 300,
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () {
                    authController.register(
                        _emailController.text, _passwordController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyTheme.blue,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: boldText('Continue', Colors.white, 24)),
            ],
          ),
        ));
  }
}
