import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String id,firstName,lastName,street,building,floor,apartmentUnit,additionalAddress,phone,cellPhone,email,comment,classification;
  String neighbourId,neighbourhood,password;
  String status;

  UserModel(
      this.id,
      this.firstName,
      this.lastName,
      this.street,
      this.building,
      this.floor,
      this.apartmentUnit,
      this.additionalAddress,
      this.phone,
      this.cellPhone,
      this.email,
      this.comment,
      this.classification,
      this.neighbourId,
      this.neighbourhood,
      this.password,
      this.status);

  UserModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        firstName = map['firstName'],
        lastName = map['lastName'],
        street = map['street'],
        password = map['password'],
        building = map['building'],
        status = map['status'],
        floor = map['floor'],
        apartmentUnit = map['apartmentUnit'],
        additionalAddress = map['additionalAddress'],
        phone = map['phone'],
        cellPhone = map['cellPhone'],
        comment = map['comment'],
        classification = map['classification'],
        neighbourId = map['neighbourId'],
        neighbourhood = map['neighbourhood'],
        email = map['email'];



  UserModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}