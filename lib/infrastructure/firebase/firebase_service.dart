import 'package:bicycle_rental_system/application/config/date_format.dart';
import 'package:bicycle_rental_system/application/controllers/state_controller.dart';
import 'package:bicycle_rental_system/domain/bicycle_model.dart';
import 'package:bicycle_rental_system/domain/rent_data.dart';
import 'package:bicycle_rental_system/domain/time_unit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseService {
  final db = FirebaseFirestore.instance;
  final String currentDate = MyDateFormat().getCurrentDate();
  StateController stateController = Get.find();

// firestore fetch all data
  Future<List<DocumentSnapshot>?> fetchAllData() async {
    QuerySnapshot querySnapshot = await db.collection('items').get();
    if (querySnapshot.docs.isEmpty) {
      return null;
    }
    return querySnapshot.docs;
  }

// firestore fetch select document data
  Future<Map<String, dynamic>?> fetchDocumentData(
    String docName,
  ) async {
    final docSnapshot = await db.collection('items').doc(docName).get();
    if (docSnapshot.exists) {
      return docSnapshot.data();
    } else {
      return null;
    }
  }

// fetch bicycle data
  Future<Bicycle?> fetchBicycleData(int productId) {
    return db.collection('items').doc('product$productId').get().then((value) {
      if (value.exists) {
        return Bicycle(
          productId: value.data()!['productId'],
          productName: value.data()!['productName'],
          description: value.data()!['description'],
          imageUrl: value.data()!['imageUrl'],
          pricePerHour: value.data()!['pricePerHour'],
        );
      } else {
        return null;
      }
    });
  }

// BicycleSerialId+1
  Future<int> incrementBicycleId() async {
    DocumentReference counterRef =
        db.collection('settings').doc('BicycleSerialID');
    return db.runTransaction((transaction) async {
      DocumentSnapshot counterSnapshot = await transaction.get(counterRef);
      if (!counterSnapshot.exists) {
        transaction.set(counterRef, {'currentBicycleID': 1});
        return 1;
      } else {
        Map<String, dynamic>? data =
            counterSnapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          int updatedCounter = data['currentBicycleID'] + 1;
          transaction.update(counterRef, {'currentBicycleID': updatedCounter});
          return updatedCounter;
        } else {
          throw Exception("Invalid data");
        }
      }
    });
  }

// RentSerialId+1
  Future<int> incrementRentId() async {
    DocumentReference counterRef =
        db.collection('settings').doc('RentalSerialID');
    return db.runTransaction((transaction) async {
      DocumentSnapshot counterSnapshot = await transaction.get(counterRef);
      if (!counterSnapshot.exists) {
        transaction.set(counterRef, {'currentRentalID': 1});
        return 1;
      } else {
        Map<String, dynamic>? data =
            counterSnapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          int updatedCounter = data['currentRentalID'] + 1;
          transaction.update(counterRef, {'currentRentalID': updatedCounter});
          return updatedCounter;
        } else {
          throw Exception("Invalid data");
        }
      }
    });
  }

// Registration Bicycle Data
  Future<bool> registrationData(Bicycle bicycle) async {
    String imageUrl = await uploadImage(
        bicycle.productId,
        stateController.memory!,
        bicycle.productId.toString() + bicycle.productName);
    bicycle.imageUrl = imageUrl;

    var result = await FirebaseFirestore.instance
        .collection('items')
        .doc('product${bicycle.productId}')
        .set({
      'productId': bicycle.productId,
      'productName': bicycle.productName,
      'description': bicycle.description,
      'imageUrl': imageUrl,
      'pricePerHour': bicycle.pricePerHour,
    }).then((void value) {
      return true;
    }).catchError((error) {
      Get.snackbar(
        "Error",
        "Failed to upload data",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    });
    return result;
  }

// upload image to firebase storage
  Future<String> uploadImage(
      int productId, Uint8List imageMemory, String fileName) async {
    var metadata = SettableMetadata(
      contentType: "image/jpeg",
    );
    Reference reference =
        FirebaseStorage.instance.ref('images/product$productId/$fileName');
    UploadTask uploadTask = reference.putData(imageMemory, metadata);

    TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

// Delete FireStore Data
  Future<String> deleteData(String doc) async {
    try {
      await FirebaseFirestore.instance.collection('items').doc(doc).delete();
      return "'$doc'を削除しました";
    } catch (error) {
      return "Error";
    }
  }

// image pick
  Future<Uint8List?> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final memory = await pickedFile.readAsBytes();
      return memory;
    } else {
      print('No image selected.');
      return null;
    }
  }

// Upload Rent Data
  Future<bool> uploadRentalData(RentalData rentalData) async {
    String timeUnitString = rentalData.timeUnit.timeUnitGetString;
    var result = await FirebaseFirestore.instance
        .collection('rentalData')
        .doc('rent${rentalData.rentID}')
        .set({
      'rentalID': rentalData.rentID,
      'bicycleID': rentalData.bicycle.productId,
      'rentalStartDate': rentalData.rentStartDate,
      'rentalPeriod': rentalData.rentPeriod,
      'timeTag': timeUnitString,
      'rentalUser': rentalData.rentUser,
    }).then((void value) {
      return true;
    }).catchError((error) {
      Get.snackbar(
        "Error",
        "Failed to upload rent data",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    });
    return result;
  }

// fetch rental data list
  Future<List<DocumentSnapshot>?> fetchAllRentData() async {
    QuerySnapshot querySnapshot = await db.collection('rentalData').get();
    if (querySnapshot.docs.isEmpty) {
      return null;
    }
    return querySnapshot.docs;
  }
}
