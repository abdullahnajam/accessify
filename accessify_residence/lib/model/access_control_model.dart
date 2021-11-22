import 'package:cloud_firestore/cloud_firestore.dart';

class AccessControlModel{
  String id,type,qr_code,date,status,qr,requestedBy,requestedFor,neighbourId;
  int dateInMilli,datePostedInMilli;


  AccessControlModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        type = map['type']??"no type",
        qr_code = map['qr_code']??"",
        date = map['date']??DateTime.now(),
        status = map['status']??"Unknown",
        dateInMilli = map['dateInMilli']??DateTime.now().millisecondsSinceEpoch,
        datePostedInMilli = map['dateInMilli']??DateTime.now().millisecondsSinceEpoch,
        requestedBy = map['requestedBy']??"Unknown",
        requestedFor = map['requestedFor']??"Unknown",
        qr = map['qr'],
        neighbourId = map['neighbourId'];



  AccessControlModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}