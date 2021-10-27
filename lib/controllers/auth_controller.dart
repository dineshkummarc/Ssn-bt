import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ssnbt/main.dart';

class AuthController extends GetxController {
  final FirebaseAuth _authInstance = FirebaseAuth.instance;
  final _firebaseUser = Rxn<User>();
  User? get user => _firebaseUser.value;

  @override
  void onInit() {
    _firebaseUser.bindStream(_authInstance.authStateChanges());
    super.onInit();
  }

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    //handle code for non ssn emails
    if (googleUser!.email.endsWith('ssn.edu.in') == false) {
      await GoogleSignIn().signOut();
      Get.dialog(
        AlertDialog(
          title: const Text("Invalid Login"),
          content: const Text("Please Log in with ssn mail id"),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Get.back();
                signInWithGoogle();
              },
            ),
          ],
        ),
        barrierDismissible: false,
      );
      return;
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Once signed in,go to the auth wrapper
    await FirebaseAuth.instance.signInWithCredential(credential);
    Get.offAll(() => AuthWrapper());
  }

  Future signOut() async {
    await GoogleSignIn().signOut();
    return await _authInstance.signOut();
  }

  String? getUserName() {
    String name = _authInstance.currentUser!.displayName![0].toUpperCase();
    name += _authInstance.currentUser!.displayName!.substring(1).toLowerCase();
    return name;
  }
}
