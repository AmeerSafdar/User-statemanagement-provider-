import 'package:cloud_firestore/cloud_firestore.dart';

class User {
    String firstName ;
    String uid;
    String lastName;
    String email;
User({
required this.uid,
required this.email,
required this.firstName,
required this.lastName,

});

  late User user;
  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "uid": uid,
        "email": email,
        "lastName":lastName
      };


  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
        firstName: snapshot['firstName'] ?? '',
        uid: snapshot['uid']?? '',
        lastName: snapshot['lastName']?? '',
        email: snapshot['email']?? '',);
  }
}