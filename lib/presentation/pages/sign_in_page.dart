import 'package:bicycle_rental_system/presentation/theme/color_theme.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Padding(
                padding: const EdgeInsets.only(left: 100),
                child: boldText('BICYCLE RENTAL', Colors.white, 32)),
            backgroundColor: MyTheme.blue,
            elevation: 0),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              boldText('Welcome back', Colors.black, 32),
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
              ElevatedButton(
                  onPressed: () {
                    //list pageに遷移
                    Navigator.pushNamed(context, '/list');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyTheme.blue,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: boldText('Continue', Colors.white, 24)),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account?'),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sign_in');
                      },
                      child: regularText('Sign up', Colors.blue, 16)),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 135,
                    height: 1,
                    color: Colors.black54,
                    margin: EdgeInsets.only(
                      right: 10,
                    ),
                  ),
                  Text('OR'),
                  Container(
                      width: 135,
                      height: 1,
                      color: Colors.black54,
                      margin: EdgeInsets.only(left: 10)),
                ],
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  //google sign in
                },
                child: Container(
                    width: 300,
                    child: Image.asset('assets/images/google_signin.png',
                        fit: BoxFit.cover)),
              ),
            ],
          ),
        ));
  }
}
