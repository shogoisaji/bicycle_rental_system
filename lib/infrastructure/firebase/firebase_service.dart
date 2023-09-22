import 'package:bicycle_rental_system/application/config/date_format.dart';
import 'package:bicycle_rental_system/application/controllers/auth_controller.dart';
import 'package:bicycle_rental_system/application/controllers/state_controller.dart';
import 'package:bicycle_rental_system/domain/bicycle_model.dart';
import 'package:bicycle_rental_system/domain/rent_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseService {
  final db = FirebaseFirestore.instance;
  final String currentDate = MyDateFormat().getCurrentDateIso();
  StateController stateController = Get.find();
  AuthController authController = Get.find();

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
  Future<Bicycle?> fetchBicycleData(String productId) {
    return db.collection('items').doc(productId).get().then((value) {
      if (value.exists) {
        return Bicycle(
          productId: productId,
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

// firestore fetch user data
  Future<Map<String, dynamic>?> fetchUserData(
    String uid,
  ) async {
    final docSnapshot = await db.collection('userData').doc(uid).get();
    if (docSnapshot.exists) {
      return docSnapshot.data();
    } else {
      return null;
    }
  }

// firestore admin check
  Future<bool> getIsAdmin(String uid) async {
    DocumentSnapshot doc = await db.collection('userData').doc(uid).get();

    if (doc.exists) {
      return (doc.data() as Map<String, dynamic>)['isAdmin'] ?? false;
    }
    return false;
  }

// update user data
  Future<bool> updateUserData(
      String uid, String name, String address, String postalCode) async {
    var result =
        await FirebaseFirestore.instance.collection('userData').doc(uid).set({
      'userName': name,
      'userAddress': address,
      'postalCode': postalCode,
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

// BicycleSerialId+1
  Future<String> incrementBicycleId() async {
    DocumentReference counterRef =
        db.collection('settings').doc('BicycleSerialID');
    return db.runTransaction((transaction) async {
      DocumentSnapshot counterSnapshot = await transaction.get(counterRef);
      if (!counterSnapshot.exists) {
        transaction.set(counterRef, {'currentBicycleID': '000001'});
        return '000001';
      } else {
        Map<String, dynamic>? data =
            counterSnapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          int updatedProductCounter = int.parse(data['currentBicycleID']) + 1;
          String updatedProductString =
              updatedProductCounter.toString().padLeft(6, "0");
          transaction
              .update(counterRef, {'currentBicycleID': updatedProductString});
          return updatedProductString;
        } else {
          throw Exception("Invalid data");
        }
      }
    });
  }

// RentSerialId+1
  Future<String> incrementRentalID() async {
    DocumentReference counterRef =
        db.collection('settings').doc('RentalSerialID');
    return db.runTransaction((transaction) async {
      DocumentSnapshot counterSnapshot = await transaction.get(counterRef);
      if (!counterSnapshot.exists) {
        transaction.set(counterRef, {'currentRentalID': '000001'});
        return '000001';
      } else {
        Map<String, dynamic>? data =
            counterSnapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          int updatedRentalCounter = int.parse(data['currentRentalID']) + 1;
          String updatedRentalString =
              updatedRentalCounter.toString().padLeft(6, "0");
          transaction
              .update(counterRef, {'currentRentalID': updatedRentalString});
          return updatedRentalString;
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
        stateController.memory.value,
        bicycle.productId.toString() + bicycle.productName);
    bicycle.imageUrl = imageUrl;

    var result = await FirebaseFirestore.instance
        .collection('items')
        .doc(bicycle.productId)
        .set({
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
      String productId, Uint8List imageMemory, String fileName) async {
    var metadata = SettableMetadata(
      contentType: "image/jpeg",
    );
    Reference reference =
        FirebaseStorage.instance.ref('images/$productId/$fileName');
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
    var result = await FirebaseFirestore.instance
        .collection('rentalData')
        .doc(rentalData.rentalID)
        .set({
      'bicycleID': rentalData.bicycleID,
      'rentalStartDate': rentalData.rentalStartDate,
      'rentalEndDate': rentalData.rentalEndDate,
      'rentalUser': rentalData.rentalUserID,
      'rentalPrice': rentalData.rentalPrice,
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
