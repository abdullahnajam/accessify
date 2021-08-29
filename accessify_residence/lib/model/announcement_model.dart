import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncmentModel{
  String id,audience,description,information,photo,expDate;bool neverExpire;

  AnnouncmentModel(
      this.id, this.audience,this.description ,this.information,this.photo, this.expDate, this.neverExpire);

  AnnouncmentModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        audience = map['audience'],
        description = map['description'],
        information = map['information'],
        photo = map['photo'],
        expDate = map['expDate'],
        neverExpire = map['neverExpire'];



  AnnouncmentModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}