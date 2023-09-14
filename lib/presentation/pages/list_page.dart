import 'package:bicycle_rental_system/infrastructure/firebase/auth_service.dart';
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<ListPage> {
  AuthService authService = AuthService();

  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Text('Hello, World!'),
        Text('ListPage'),
        ElevatedButton(
            onPressed: () {
              //list pageに遷移
              Navigator.pushNamed(context, '/sign_in');
            },
            child: Text('sign in page'))
      ],
    ));
  }
}
