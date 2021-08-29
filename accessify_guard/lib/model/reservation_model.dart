import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationModel{
  String id,date,facilityName,hourStart,totalGuests,status;

  ReservationModel(this.id, this.date, this.facilityName, this.hourStart,
      this.totalGuests,this.status);

  ReservationModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        date = map['date'],
        facilityName = map['facilityName'],
        hourStart = map['hourStart'],
        status = map['status'],
        totalGuests = map['totalGuests'];



  ReservationModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}