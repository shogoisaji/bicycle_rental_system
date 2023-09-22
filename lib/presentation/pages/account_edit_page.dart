import 'package:bicycle_rental_system/application/config/config.dart';
import 'package:bicycle_rental_system/application/controllers/auth_controller.dart';
import 'package:bicycle_rental_system/infrastructure/firebase/firebase_service.dart';
import 'package:bicycle_rental_system/presentation/pages/account_page.dart';
import 'package:bicycle_rental_system/presentation/theme/color_theme.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:bicycle_rental_system/presentation/widgets/account_text_edit%20copy.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountEditPage extends StatefulWidget {
  final String name;
  final String postalCode;
  final String address;

  AccountEditPage(
      {required this.name, required this.postalCode, required this.address});

  @override
  _AccountEditPageState createState() => _AccountEditPageState();
}

class _AccountEditPageState extends State<AccountEditPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _postalCodeController.text = widget.postalCode;
    _addressController.text = widget.address;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _postalCodeController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width;
    AuthController authController = Get.find();
    return Scaffold(
      appBar: AppBar(
          title: Padding(
              padding: mWidth < BREAKPOINT1
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.only(left: 60),
              child: boldText('EDIT ACCOUNT', Colors.white,
                  mWidth < BREAKPOINT1 ? 28 : 32)),
          backgroundColor: MyTheme.blue,
          elevation: 0),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                  constraints: BoxConstraints(maxWidth: 500, minWidth: 300),
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: MyTheme.lightBlue,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      accountTextEdit('Name', _nameController),
                      accountTextEdit('PostalCole', _postalCodeController),
                      accountTextEdit('Address', _addressController),
                    ],
                  )),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 20, vertical: 4)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(MyTheme.purple),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      )),
                  onPressed: () async {
                    //save
                    bool result = await FirebaseService().updateUserData(
                        authController.getUid(),
                        _nameController.text,
                        _postalCodeController.text,
                        _addressController.text);
                    if (result) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AccountPage(),
                        ),
                      );
                    }
                  },
                  child: boldText('SAVE', Colors.white, 24)),
            ],
          ),
        ),
      ),
    );
  }
}
