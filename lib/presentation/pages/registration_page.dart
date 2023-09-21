import 'package:bicycle_rental_system/application/controllers/state_controller.dart';
import 'package:bicycle_rental_system/domain/bicycle_model.dart';
import 'package:bicycle_rental_system/infrastructure/firebase/firebase_service.dart';
import 'package:bicycle_rental_system/presentation/pages/list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    StateController stateController = Get.find();
    FirebaseService firebase = FirebaseService();
    TextEditingController _nameController = TextEditingController();
    TextEditingController _descriptionController = TextEditingController();
    TextEditingController _priceController = TextEditingController();
    Uint8List? memory;
    return Scaffold(
      body: Column(
        children: [
          Text('Registration Page'),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'ProductName',
              hintText: 'Enter Product Name',
            ),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'description',
              hintText: 'Enter Product description',
            ),
          ),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(
              labelText: 'price per hour',
              hintText: 'Enter price per hour',
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                memory = await firebase.pickImage();
                if (memory == null) return;
                stateController.setMemory(memory!);
              },
              child: Text('image')),
          ElevatedButton(
              onPressed: () async {
                if (memory == null ||
                    _nameController.text.isEmpty ||
                    _priceController.text.isEmpty) {
                  Get.snackbar(
                    "Error",
                    "Failed to upload data",
                    backgroundColor: Colors.red,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  return;
                }
                int productId = await firebase.incrementBicycleId();
                Bicycle bicycle = Bicycle(
                    productId: productId,
                    productName: _nameController.text,
                    description: _descriptionController.text,
                    imageUrl: '',
                    pricePerHour: int.parse(_priceController.text));
                bool success = await firebase.registrationData(bicycle);
                if (success) {
                  Get.to(() => ListPage());
                } else {
                  print('errro');
                  Get.snackbar(
                    "Error",
                    "Failed to upload data",
                    backgroundColor: Colors.red,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              child: Text('save'))
        ],
      ),
    );
  }
}
