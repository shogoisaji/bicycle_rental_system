import 'package:bicycle_rental_system/application/config/config.dart';
import 'package:bicycle_rental_system/application/controllers/state_controller.dart';
import 'package:bicycle_rental_system/domain/bicycle_model.dart';
import 'package:bicycle_rental_system/infrastructure/firebase/firebase_service.dart';
import 'package:bicycle_rental_system/presentation/pages/list_page.dart';
import 'package:bicycle_rental_system/presentation/theme/color_theme.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width;
    StateController stateController = Get.find();
    FirebaseService firebase = FirebaseService();
    TextEditingController _nameController = TextEditingController();
    TextEditingController _descriptionController = TextEditingController();
    TextEditingController _priceController = TextEditingController();
    Uint8List? memory;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            stateController.memoryRefresh();
            Navigator.of(context).pop();
          },
        ),
        title: Padding(
            padding: mWidth < BREAKPOINT1
                ? const EdgeInsets.all(0)
                : const EdgeInsets.only(left: 60),
            child: boldText(
                'REGISTRATION', Colors.white, mWidth < BREAKPOINT1 ? 28 : 32)),
        backgroundColor: MyTheme.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 400),
            child: Column(
              children: [
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: MyTheme.lightBlue,
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        style: TextStyle(fontSize: 22),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          labelText: 'Bicycle Name',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _descriptionController,
                        style: TextStyle(fontSize: 22),
                        maxLines: 5,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          labelText: 'description',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _priceController,
                        style: TextStyle(fontSize: 22),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          labelText: 'price per hour',
                          hintText: 'numbers only',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Obx(() => Container(
                                width: 200,
                                height: 200,
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.black87),
                                  color: Colors.white,
                                ),
                                child: stateController.isImageSelected.value
                                    ? Image.memory(stateController.memory.value)
                                    : Center(
                                        child: mediumText(
                                            'No Image', Colors.black54, 24)),
                              )),
                          ElevatedButton(
                              style: ButtonStyle(
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 4)),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          MyTheme.purple),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  )),
                              onPressed: () async {
                                memory = await firebase.pickImage();
                                if (memory == null) return;
                                stateController.memory.value = memory!;
                                stateController.isImageSelected.value = true;
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                child: boldText('IMAGE', Colors.white, 24),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 20, vertical: 4)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(MyTheme.purple),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        )),
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
                      String productId = await firebase.incrementBicycleId();
                      Bicycle bicycle = Bicycle(
                          productId: productId,
                          productName: _nameController.text,
                          description: _descriptionController.text,
                          imageUrls: [''],
                          pricePerHour: int.parse(_priceController.text));
                      bool success = await firebase.registrationData(bicycle);
                      if (success) {
                        stateController.memoryRefresh();
                        Get.snackbar(
                          "Success",
                          "Successfully uploaded data",
                          backgroundColor: Colors.blue,
                          snackPosition: SnackPosition.BOTTOM,
                          maxWidth: 500,
                        );
                        Get.to(() => ListPage());
                      } else {
                        print('error');
                        Get.snackbar(
                          "Error",
                          "Failed to upload data",
                          backgroundColor: Colors.red,
                          snackPosition: SnackPosition.BOTTOM,
                          maxWidth: 500,
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: boldText('SAVE', Colors.white, 24),
                    )),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
