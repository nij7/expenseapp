import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
 FirebaseAuth _auth = FirebaseAuth.instance;
Future<String> signupuser({
  required String email,
  required String password,
  required String username,
  required String bio,
  
}) async {
  String res = "Some error occured";
  try {
    if (email.isNotEmpty ||
        password.isNotEmpty ||
        username.isNotEmpty ||
        bio.isNotEmpty 
        ) {
     
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      UserCredential crud = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      

Map<String, dynamic> data = {
"username": username,
"email": email,
"data": bio,

};
      _firestore.collection("User").doc(crud.user!.uid).set(data);

      res = "success";
    }
  } on FirebaseException catch (err) {
    if (err.code == 'weak-password') {
      res = 'weak-password';
    } else if (err.code == 'invalid-email') {
      print('The email address is invalid.');
      res = 'The email address is invalid.';
    }
  } catch (e) {
    res = e.toString();
  }
  return res;
}

Future<String> loginUser({
  required String email,
  required String password,
}) async {
  String res = "Some error occurred";

  try {
    if (email.isNotEmpty && password.isNotEmpty) {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      res = "success";
    } else {
      res = "Please enter all the fields";
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print("user not found");
    }
  } catch (err) {
    res = err.toString();
  }

  return res;
}
