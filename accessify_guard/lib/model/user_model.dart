import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String id,neighbourId,neighbourhood,firstName,lastName,street,building,floor,apartmentUnit,additionalAddress,phone,cellPhone,email,comment,classification,token;


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
      this.token,
      this.neighbourId,
      this.neighbourhood);

  UserModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        firstName = map['firstName'],
        lastName = map['lastName'],
        street = map['street'],
        building = map['building'],
        floor = map['floor'],
        apartmentUnit = map['apartmentUnit'],
        additionalAddress = map['additionalAddress'],
        phone = map['phone'],
        cellPhone = map['cellPhone'],
        comment = map['comment'],
        classification = map['classification'],
        email = map['email'],
        neighbourId = map['neighbourId'],
        neighbourhood = map['neighbourhood'],
        token = map['token'];

}