import 'package:cloud_firestore/cloud_firestore.dart';

class SupplyModel{
  String id,description,datePurchased,stock,location,assignedTo,guardId,comment,condition,inventoryFrequency,lastInventoryDate;

  SupplyModel(this.id, this.description, this.datePurchased, this.stock,
      this.location, this.assignedTo,this.guardId,this.comment, this.condition, this.inventoryFrequency,
      this.lastInventoryDate);

  SupplyModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        description = map['description'],
        datePurchased = map['datePurchased'],
        stock = map['stock'],
        location = map['location'],
        assignedTo = map['assignedTo'],
        guardId = map['guardId'],
        comment = map['comment'],
        condition = map['condition'],
        inventoryFrequency = map['inventoryFrequency'],
        lastInventoryDate = map['lastInventoryDate'];



  SupplyModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}