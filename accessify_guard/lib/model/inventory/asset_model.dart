import 'package:cloud_firestore/cloud_firestore.dart';

class AssetModel{
  String id,description,serial,datePurchased,maintenanceSchedule,location,warranty,checkInOut,assignedTo,condition,comment,assignedId,
      inventoryFrequency,lastScanDate,photo,qr_image;

  AssetModel(
      this.id,
      this.description,
      this.serial,
      this.datePurchased,
      this.maintenanceSchedule,
      this.location,
      this.warranty,
      this.checkInOut,
      this.assignedTo,
      this.condition,
      this.comment,
      this.assignedId,
      this.inventoryFrequency,
      this.lastScanDate,
      this.photo,
      this.qr_image);

  AssetModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        description = map['description'],
        serial = map['serial'],
        datePurchased = map['datePurchased'],
        maintenanceSchedule = map['maintenanceSchedule'],
        location = map['location'],
        warranty = map['warranty'],
        checkInOut = map['checkInOut'],
        assignedTo = map['assignedTo'],
        condition = map['condition'],
        comment = map['comment'],
        assignedId = map['assignedId'],
        inventoryFrequency = map['inventoryFrequency'],
        lastScanDate = map['lastScanDate'],
        photo = map['photo'],
        qr_image = map['qr_image'];


}