import 'package:cloud_firestore/cloud_firestore.dart';

class NeighbourModel{
  String id,name,address,codeId,photo,logo,quantity,pricePerHouse,annualFee,billingData,expiration,subscriptionRenewal,
      discount,vendorInfo;

  NeighbourModel(this.id, this.name, this.address, this.codeId,this.photo,this.logo,this.quantity,this.expiration,this.discount,this.annualFee,
      this.billingData,this.pricePerHouse,this.subscriptionRenewal,this.vendorInfo);

  /*'photo':  photo,
  'logo':  logo,
  'quantity':quantityOfHouseController.text,
  'pricePerHouse':pricePerHouseController.text,
  'annualFee':annualFeeController.text,
  'billingData':billingDataController.text,
  'expiration':expirationController.text,
  'subscriptionRenewal':subscriptionController,
  'discount':discountController.text,
  'vendorInfo':vendorInfoController.text*/

  NeighbourModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        name = map['name'],
        address = map['address'],
        photo = map['photo'],
        logo = map['logo'],
        quantity = map['quantity'],
        pricePerHouse = map['pricePerHouse'],
        annualFee = map['annualFee'],
        billingData = map['billingData'],
        expiration = map['expiration'],
        subscriptionRenewal = map['subscriptionRenewal'],
        discount = map['discount'],
        vendorInfo = map['vendorInfo'],
        codeId = map['codeId'];



  NeighbourModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}