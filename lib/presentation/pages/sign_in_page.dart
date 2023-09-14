import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../infrastructure/firebase/auth_service.dart';

class SignInPage extends StatelessWidget {
  String? mailAddress;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 300,
        width: double.infinity,
      ),
    );
  }
}
