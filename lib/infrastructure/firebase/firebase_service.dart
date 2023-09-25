import 'dart:convert';

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
      List<dynamic> imageList = jsonDecode(value.data()!['images']);
      if (value.exists) {
        return Bicycle(
          productId: productId,
          productName: value.data()!['productName'],
          description: value.data()!['description'],
          images: imageList,
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
    var result = await db.collection('userData').doc(uid).update({
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
    DocumentSnapshot counterSnapshot = await counterRef.get();
    if (!counterSnapshot.exists) {
      await counterRef.set({'currentBicycleID': '000001'});
      return '000001';
    } else {
      Map<String, dynamic>? data =
          counterSnapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        int updatedProductCounter = int.parse(data['currentBicycleID']) + 1;
        String updatedProductString =
            updatedProductCounter.toString().padLeft(6, "0");
        await counterRef.update({'currentBicycleID': updatedProductString});
        return updatedProductString;
      } else {
        throw Exception("Invalid data");
      }
    }
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
  Future<bool> registrationData(
      Bicycle bicycle, Map<String, dynamic> imageMap) async {
    Map<String, String> imageSavedData = await uploadImage(
      bicycle.productId,
      imageMap,
    );
    List<dynamic> images = [imageSavedData];

    String jsonImages = jsonEncode(images);

    var result = await db.collection('items').doc(bicycle.productId).set({
      'productName': bicycle.productName,
      'description': bicycle.description,
      'images': jsonImages,
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
  Future<Map<String, String>> uploadImage(
      String productId, Map<String, dynamic> imageMap) async {
    String contentType = '';
    Uint8List imageMemory = imageMap['image'];
    String imageFormat = imageMap['format'];
    String fileName = '${productId}_${DateTime.now().toString()}';
    String fileExtension = '';
    if (imageFormat == 'jpeg' || imageFormat == 'jpg') {
      contentType = 'image/jpeg';
      fileExtension = '.jpeg';
    } else if (imageFormat == 'png') {
      contentType = 'image/png';
      fileExtension = '.png';
    }
    String filePath = 'images/$productId/$fileName$fileExtension';

    SettableMetadata metadata = SettableMetadata(contentType: contentType);

    Reference reference = FirebaseStorage.instance.ref(filePath);
    UploadTask uploadTask = reference.putData(imageMemory, metadata);

    TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return {'filePath': filePath, 'url': downloadUrl};
  }

// add image to firestore & firestrage
  Future<bool> addImage(String productId, Map<String, dynamic> imageMap) async {
    Map<String, String> imageSavedData = await uploadImage(
      productId,
      imageMap,
    );

    Map<String, dynamic>? bicycleData = await fetchDocumentData(productId);
    if (bicycleData == null) return false;

    List<dynamic> currentJson = jsonDecode(bicycleData['images']);
    currentJson.add(imageSavedData);

    String jsonImages = jsonEncode(currentJson);

    var result = await db.collection('items').doc(productId).update({
      'images': jsonImages,
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

// delete firestore data
  Future<bool> deleteData(String doc) async {
    try {
      await db.collection('items').doc(doc).delete();
      try {
        bool imageDeleteResult = await deleteFireStrageFolder(doc);
        if (!imageDeleteResult) {
          Get.snackbar(
            'error',
            'Failed to delete image',
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.BOTTOM,
          );
          return false;
        }
      } catch (error) {
        Get.snackbar(
          'error',
          'Failed to delete image',
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
      return true;
    } catch (error) {
      Get.snackbar(
        "Error",
        "Failed to delete data",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

// delete firestrage folder
  Future<bool> deleteFireStrageFolder(String productId) async {
    try {
      ListResult result =
          await FirebaseStorage.instance.ref('images/$productId').listAll();

      for (Reference ref in result.items) {
        await ref.delete();
      }
      return true;
    } catch (error) {
      return false;
    }
  }

// delete 1 product all Image
  Future<bool> deleteProductImage(String productId) async {
    try {
      ListResult result =
          await FirebaseStorage.instance.ref('images/$productId').listAll();

      for (Reference ref in result.items) {
        await ref.delete();
      }
      return true;
    } catch (error) {
      return false;
    }
  }

// delete 1 Image
  Future<bool> deleteOneImage(String productId, int index) async {
    try {
      Bicycle? bicycleData = await fetchBicycleData(productId);
      if (bicycleData == null) return false;

      Map<String, dynamic> imagesData = (bicycleData.images)[index];
      String? deleteFilePath = imagesData['filePath'];

      await FirebaseStorage.instance.ref(deleteFilePath).delete();

      List<dynamic> imagesList = bicycleData.images;
      imagesList.removeAt(index);

      String jsonImages = jsonEncode(imagesList);

      await db.collection('items').doc(productId).update({
        'images': jsonImages,
      });

      return true;
    } catch (error) {
      return false;
    }
  }

// image pick
  Future<Map<String, dynamic>?> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final memory = await pickedFile.readAsBytes();
      final imageFormat = pickedFile.path.split('.').last;

      return {'image': memory, 'format': imageFormat};
    } else {
      print('No image selected.');
      return null;
    }
  }

// Upload Rent Data
  Future<bool> uploadRentalData(RentalData rentalData) async {
    var result =
        await db.collection('rentalData').doc(rentalData.rentalID).set({
      'bicycleID': rentalData.bicycleID,
      'rentalStartDate': rentalData.rentalStartDate,
      'rentalEndDate': rentalData.rentalEndDate,
      'rentalUserID': rentalData.rentalUserID,
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
