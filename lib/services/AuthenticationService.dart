import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User?> get onAuthStateChanged => _auth.userChanges();
  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    //handle code for non ssn emails
    if (googleUser!.email.endsWith('ssn.edu.in') == false) {
      await GoogleSignIn().signOut();
      return null;
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future signOut() async {
    await GoogleSignIn().signOut();
    return await _auth.signOut();
  }

  String? getUserName() {
    String name = _auth.currentUser!.displayName![0].toUpperCase();
    name += _auth.currentUser!.displayName!.substring(1).toLowerCase();
    return name;
  }
}
