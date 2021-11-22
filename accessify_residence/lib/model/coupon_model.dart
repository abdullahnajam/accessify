import 'package:cloud_firestore/cloud_firestore.dart';

class CouponsModel{
  String id,price,title,description,image,expiration,status,phone,classification,userId,username;

  String neighbourId;
  CouponsModel(this.id, this.price, this.title, this.description, this.image,
      this.expiration, this.status, this.phone,this.classification,this.userId,this.username,this.neighbourId);

  CouponsModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        price = map['price'],
        title = map['title'],
        description = map['description'],
        image = map['image'],
        expiration = map['expiration'],
        status = map['status'],
        phone = map['phone'],
        classification = map['classification'],
        userId = map['userId'],
        neighbourId = map['neighbourId'],
        username = map['username'];



  CouponsModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}