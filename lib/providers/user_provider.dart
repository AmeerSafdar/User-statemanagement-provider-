// ignore_for_file: unused_import, library_prefixes, unused_local_variable

import 'package:apploginfirebase/views/home_screen.dart';
import 'package:apploginfirebase/views/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:apploginfirebase/models/user_model.dart' as usersModel;
class UserProvider with ChangeNotifier{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late UserCredential userCred;

  var usrId=FirebaseAuth.instance.currentUser ;

  bool read_only=true;
  bool writable=false;

  bool onLoading =false;

   String? firsName , lastName, email;
   
   
  Future<void> signOut(BuildContext cntxt) async {
    var userID=FirebaseAuth.instance.currentUser!.uid;
    await _auth.signOut().then((value) {
     Navigator.pushReplacement(cntxt, MaterialPageRoute(
        builder: (context) => const LoginScreen()));
    });
    userID='';
    notifyListeners();
  }

  getUserData() async{
        DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

      firsName= (snap.data() as Map<String, dynamic>)['firstName'];
      lastName=  (snap.data() as Map<String, dynamic>)['lastName'];
       email= (snap.data() as Map<String, dynamic>)['email'];
       notifyListeners();
  }

 loginUser(String userEmail, String userPassword,BuildContext context) async{
      String res='';
      try{
        onLoading =true;
        notifyListeners();
      if (userEmail.isNotEmpty || userPassword.isNotEmpty) {
        await _auth
            .signInWithEmailAndPassword(email: userEmail, password: userPassword)
            .then((value) => {
              res= 'successful',
              print(res),
              getUserData(),
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()))
            });
     
      }}
      catch(e){
        print(e);
      }
    onLoading=false;
    notifyListeners();
}

setUserData
  (
    String userFirstName,String userLasttName,String userEmail, String userPassword,BuildContext context) async{
    String res='';
      try {
        onLoading =true;
        notifyListeners();
        userCred =await _auth.createUserWithEmailAndPassword(email: userEmail, password: userPassword);
        usersModel.User user =usersModel.User(
          firstName: userFirstName,
          lastName:userLasttName,
          uid: userCred.user!.uid,
          email: userEmail,
        );
    await _firebaseFirestore.collection('users').doc(userCred.user!.uid).set(
              user.toJson(),
            ).then((value) => {
              res= 'successful',
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen())),
              getUserData()
              

            });
    } catch (e) {
      print(e);
    }
    
    onLoading=false;
    notifyListeners();

  }

    editableTextField() {
      read_only= false;
      writable=true;
       WidgetsBinding.instance.addPostFrameCallback((_) {
     notifyListeners();
          });

    }
    nonEditableTextField(){
      read_only= true;
      writable=false;
      notifyListeners();
    }
    


    updateData(String email, String firstName, String lastName,String uid)async{
      try{  
        await _firebaseFirestore.collection('users').doc(uid).update({
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
      });
      getUserData();
      notifyListeners();
      }
      catch(e){
        print(e);
      }

}

  }
