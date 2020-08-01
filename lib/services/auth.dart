import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  User(
      {@required this.uid,
      @required this.displayName,
      @required this.photoUrl});
  final String uid;
  final String photoUrl;
  final String displayName;
}

abstract class AuthBase {
  AuthBase(BuildContext context);

  Stream<User> get onAuthStatechanged;
  Future<User> currentUser();
  Future<User> signInByGoogle();
  Future<void> signOut();
  Future<User> signInWithEmail(String email, String password);
  Future<User> signUpWithEmail(String email, String password);
}

class Auth implements AuthBase { 
  final _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) return null;
    return User(
      uid: user.uid,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
    );
  }

  @override
  Stream<User> get onAuthStatechanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  @override
  Future<User> currentUser() async {
    final user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  @override
  Future<User> signInByGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authResult = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.getCredential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken));

        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
            code: 'error missing google auth token',
            message: 'missing google auth token');
      }
    } else {
      throw PlatformException(
          code: 'error aborted by user', message: 'sign in aborted by user');
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    return _userFromFirebase(null);
  }

  @override
  Future<User> signInWithEmail(String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> signUpWithEmail(String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }
}
