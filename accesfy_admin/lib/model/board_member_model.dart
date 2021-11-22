import 'package:cloud_firestore/cloud_firestore.dart';

class BoardMemberModel{
  String id,firstName,lastName,phone,email,neighbourId,neighbourhoodName,status,position,comment,neighbourLogo;

  BoardMemberModel(
      this.id, this.firstName, this.lastName, this.phone, this.email,this.neighbourId,this.neighbourhoodName,
      this.status,this.position,this.comment,this.neighbourLogo);

  BoardMemberModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        firstName = map['firstName'],
        lastName = map['lastName'],
        phone = map['phone'],
        email = map['email'],
        status = map['status'],
        position = map['position'],
        comment = map['comment'],
        neighbourLogo = map['neighbourLogo'],
        neighbourId = map['neighbourId'],
        neighbourhoodName = map['neighbourhoodName'];



  BoardMemberModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}