import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel{
  String id,address,month,year,invoiceNumber,concept,interest,expiration,status,userId,name,proofUrl,submissionDate;
  int amount,expirationInMilli,submissionInMilli;
  String neighbourId,neighbourhood;

  PaymentModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        address = map['address'],
        month = map['month'],
        year = map['year'],
        invoiceNumber = map['invoiceNumber'],
        concept = map['concept'],
        interest = map['interest'],
        expiration = map['expiration'],
        status = map['status'],
        userId = map['userId'],
        name = map['name'],
        proofUrl = map['proofUrl'],
        submissionDate = map['submissionDate'],
        amount = map['amount'],
        neighbourId = map['neighbourId'],
        neighbourhood = map['neighbourhood'],
        expirationInMilli = map['expirationInMilli'],
        submissionInMilli = map['submissionInMilli'];



  PaymentModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}