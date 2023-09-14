import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

// sign in Email
  Future<void> signInEmail(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

// sign in Google
  Future<void> signInGoogle() async {
    await _googleSignIn.signIn();
  }

// check sign in
  Future<bool> checkUserLoggedIn(User? user) async {
    bool isUserLoggedIn = false;
    // firebase sign in check
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        isUserLoggedIn = true;
      }
    });
    // google sign in
    final user = _googleSignIn.currentUser;
    if (user != null) {
      isUserLoggedIn = true;
    }
    return isUserLoggedIn;
  }

// sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

// create firebase user
///////////////////////
  Future<User?> createUser(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

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
