import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Hello, World!'),
        Text('AccountPage'),
      ],
    );
  }
}
