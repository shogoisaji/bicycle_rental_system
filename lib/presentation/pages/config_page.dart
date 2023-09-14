import 'package:flutter/material.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Hello, World!'),
        Text('ConfigPage'),
      ],
    );
  }
}
