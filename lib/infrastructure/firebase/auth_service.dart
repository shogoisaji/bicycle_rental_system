import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// サインイン
  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  /// サインアウト
  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future createUser(String name, String email, String password) async {
    try {
      // Create a new user with email and password
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Once the user creation process is successful, save additional user info in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'registrationDate': Timestamp.now(),
      });

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Handle errors here
      print(e);
      return null;
    }
  }
}
