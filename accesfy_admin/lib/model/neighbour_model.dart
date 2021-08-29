import 'package:cloud_firestore/cloud_firestore.dart';

class NeighbourModel{
  String id,name,address,codeId;

  NeighbourModel(this.id, this.name, this.address, this.codeId);

  NeighbourModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        address = map['address'],
        codeId = map['codeId'];



  NeighbourModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}