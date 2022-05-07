import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String id,firstName,lastName,photoId,companyName,phone,supervisor,email,password,status,neighbourId,token,neighbourhood;

  UserModel(this.id, this.firstName, this.lastName, this.photoId,
      this.companyName, this.phone, this.supervisor, this.email,this.password,this.status,this.neighbourId,this.neighbourhood,this.token);

  UserModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        firstName = map['firstName'],
        lastName = map['lastName'],
        photoId = map['photoId'],
        companyName = map['companyName'],
        neighbourId = map['neighbourId'],
        neighbourhood = map['neighbourhood'],
        token = map['token'],
        phone = map['phone'],
        supervisor = map['supervisor'],
        password = map['password'],
        status = map['status'],
        email = map['email'];



  UserModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}