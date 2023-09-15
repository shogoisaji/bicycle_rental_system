import 'package:bicycle_rental_system/firebase_options.dart';
import 'package:bicycle_rental_system/presentation/pages/account_page.dart';
import 'package:bicycle_rental_system/presentation/pages/config_page.dart';
import 'package:bicycle_rental_system/presentation/pages/detail_page.dart';
import 'package:bicycle_rental_system/presentation/pages/list_page.dart';
import 'package:bicycle_rental_system/presentation/pages/sign_in_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BICYCLE RENTAL',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SignInPage(),
      routes: {
        '/list': (context) => ListPage(),
        // '/detail': (context) => DetailPage(),
        '/account': (context) => AccountPage(),
        '/config': (context) => ConfigPage(),
        '/sign_in': (context) => SignInPage(),
      },
    );
  }
}
