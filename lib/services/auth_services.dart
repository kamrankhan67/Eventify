import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String pass,
    bool isChecked
  ) async {
    try {
      
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserCredential> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
    bool isChecked,
    bool isVerified,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if(!isChecked){
        await _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'name': name,
        
      });
      }else{
        await _firestore.collection("Admin").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'name': name,
        'isChecked':isChecked,
        'isVerified':isVerified
      });
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String> getCurrentUserUid() async {
    return _auth.currentUser!.uid;
  }

  Future<User> getCurrentUser() async {
    return _auth.currentUser!;
  }

  Future<String?> getCurrentUserName() async {
    return _auth.currentUser!.displayName;
  }

  Future<void> deleteAccount() async {
    return await _auth.currentUser!.delete();
  }
}
