import 'dart:html';

import 'package:accesfy_admin/model/neighbour_model.dart';
import 'package:accesfy_admin/navigators/main_screen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:intl/intl.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import '../../../constants.dart';

class NeighourTable extends StatefulWidget {
  const NeighourTable({Key? key}) : super(key: key);

  @override
  _NeighourTableState createState() => _NeighourTableState();
}

class _NeighourTableState extends State<NeighourTable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Neighbours",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('neighbours').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  margin: EdgeInsets.all(30),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.size==0){
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(80),
                  alignment: Alignment.center,
                  child: Text("No Records"),
                );
              }
              print("size ${snapshot.data!.size}");
              return new SizedBox(
                width: double.infinity,
                child: DataTable2(
                    columnSpacing: defaultPadding,
                    showCheckboxColumn: false,
                    minWidth: 600,
                    columns: [
                      DataColumn(
                        label: Text("Name"),
                      ),
                      DataColumn(
                        label: Text("Code"),
                      ),
                      DataColumn(
                        label: Text("Address"),
                      ),
                      DataColumn(
                        label: Text("Houses"),
                      ),
                      DataColumn(
                        label: Text("Logo"),
                      ),
                      DataColumn(
                        label: Text("Actions"),
                      ),



                    ],
                    rows: _buildList(context, snapshot.data!.docs)

                ),
              );
            },
          ),


        ],
      ),
    );
  }
}
List<DataRow> _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return  snapshot.map((data) => _buildListItem(context, data)).toList();
}



DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
  final model = NeighbourModel.fromSnapshot(data);

  Future<void> _showInfoDialog(NeighbourModel model,BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          insetAnimationDuration: const Duration(seconds: 1),
          insetAnimationCurve: Curves.fastOutSlowIn,
          elevation: 2,

          child: Container(
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height*0.8,
            width: MediaQuery.of(context).size.width*0.5,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Text("Neighbourhood Information",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: secondaryColor),),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: IconButton(
                            icon: Icon(Icons.close,color: Colors.grey,),
                            onPressed: ()=>Navigator.pop(context),
                          ),
                        ),
                      )
                    ],
                  ),

                  Expanded(
                    child: ListView(
                      children: [
                        Text(
                          "${model.name}",
                          style: Theme.of(context).textTheme.headline6!.apply(color: Colors.black),
                        ),
                        Text(
                          model.address,
                          style: Theme.of(context).textTheme.bodyText2!.apply(color: Colors.grey[600]),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.home,color: Colors.grey[600],size: 20,),
                                Text(
                                  "   Quantity of Houses",
                                  style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            Text(
                              "${model.quantity}",
                              style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.black),
                            ),
                          ],
                        ),
                        Divider(color: Colors.grey[300],),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.monetization_on,color: Colors.grey[600],size: 20,),
                                Text(
                                  "   Price Per House",
                                  style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            Text(
                              "${model.pricePerHouse}",
                              style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.black),
                            ),
                          ],
                        ),
                        Divider(color: Colors.grey[300],),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.list_alt_sharp,color: Colors.grey[600],size: 20,),
                                Text(
                                  "   Annual Fee",
                                  style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            Text(
                              "${model.annualFee}",
                              style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.black),
                            ),
                          ],
                        ),
                        Divider(color: Colors.grey[300],),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.receipt_long,color: Colors.grey[600],size: 20,),
                                Text(
                                  "   Billing Data",
                                  style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            Text(
                              "${model.billingData}",
                              style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.black),
                            ),
                          ],
                        ),
                        Divider(color: Colors.grey[300],),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.timer_off,color: Colors.grey[600],size: 20,),
                                Text(
                                  "   Expiration Services",
                                  style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            Text(
                              "${model.expiration}",
                              style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.black),
                            ),
                          ],
                        ),

                        Divider(color: Colors.grey[300],),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.unsubscribe,color: Colors.grey[600],size: 20,),
                                Text(
                                  "   Subscription Renewal",
                                  style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            Text(
                              "${model.subscriptionRenewal}",
                              style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.black),
                            ),
                          ],
                        ),
                        Divider(color: Colors.grey[300],),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.local_offer_outlined,color: Colors.grey[600],size: 20,),
                                Text(
                                  "   Discount",
                                  style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            Text(
                              "${model.discount}",
                              style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.black),
                            ),
                          ],
                        ),
                        Divider(color: Colors.grey[300],),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.photo,color: Colors.grey[600],size: 20,),
                                Text(
                                  "   Photo",
                                  style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            Image.network(model.photo,height: 80,width: 80,)
                          ],
                        ),
                        Divider(color: Colors.grey[300],),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.photo,color: Colors.grey[600],size: 20,),
                                Text(
                                  "   Logo",
                                  style: Theme.of(context).textTheme.subtitle2!.apply(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            Image.network(model.logo,height: 80,width: 80,)
                          ],
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                        Text(
                          "Vendor Information",
                          style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                        ),
                        Text(
                          model.vendorInfo,
                          style: Theme.of(context).textTheme.bodyText2!.apply(color: Colors.grey[600]),
                        ),

                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  var nameController=TextEditingController();
  var addressController=TextEditingController();
  var codeController=TextEditingController();
  var discountController=TextEditingController();
  var quantityOfHouseController=TextEditingController();
  var pricePerHouseController=TextEditingController();
  var annualFeeController=TextEditingController();
  var billingDataController=TextEditingController();
  var vendorInfoController=TextEditingController();
  var expirationController=TextEditingController();
  var subscriptionController=TextEditingController();

  update(String photo,logo,id) async{
    print("rr");
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Please wait");
    FirebaseFirestore.instance.collection('neighbours').doc(id).update({
      'name': nameController.text,
      'codeId': codeController.text,
      'address': addressController.text,
      'photo':  photo,
      'logo':  logo,
      'quantity':quantityOfHouseController.text,
      'pricePerHouse':pricePerHouseController.text,
      'annualFee':annualFeeController.text,
      'billingData':billingDataController.text,
      'expiration':expirationController.text,
      'subscriptionRenewal':subscriptionController.text,
      'discount':discountController.text,
      'vendorInfo':vendorInfoController.text
    }).then((value) {
      pr.close();
      print("added");
      Navigator.pop(context);
    });
  }



  Future<void> _showEditDialog(NeighbourModel model,BuildContext context) async {
    String imageUrl=model.photo;
    fb.UploadTask? _uploadTask;
    Uri imageUri;
    bool imageUploading=false;
    DateTime? expire;
    DateTime? subscription;
    String logoUrl=model.logo;
    fb.UploadTask? _logoUploadTask;
    Uri logoUri;
    bool logoUploading=false;
    final _formKey = GlobalKey<FormState>();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        nameController.text=model.name;
        addressController.text=model.address;
        codeController.text=model.codeId;
        discountController.text=model.discount;
        quantityOfHouseController.text=model.quantity;
        pricePerHouseController.text=model.pricePerHouse;
        annualFeeController.text=model.annualFee;
        billingDataController.text=model.billingData;
        vendorInfoController.text=model.vendorInfo;
        expirationController.text=model.expiration;
        subscriptionController.text=model.subscriptionRenewal;
        return StatefulBuilder(
          builder: (context, setState) {
            uploadToFirebase(File imageFile) async {
              final filePath = 'images/${DateTime.now()}.png';
              print("put");
              setState((){
                imageUploading=true;
                _uploadTask = fb.storage().refFromURL('gs://accesfy-882e6.appspot.com').child(filePath).put(imageFile);
              });

              fb.UploadTaskSnapshot taskSnapshot = await _uploadTask!.future;
              imageUri = await taskSnapshot.ref.getDownloadURL();
              setState((){
                print("heer");
                imageUrl=imageUri.toString();
                imageUploading=false;
                print(imageUrl);
              });


            }
            uploadImage() async {
              // HTML input element
              FileUploadInputElement uploadInput = FileUploadInputElement();
              uploadInput.click();

              uploadInput.onChange.listen(
                    (changeEvent) {
                  final file = uploadInput.files!.first;
                  final reader = FileReader();
                  reader.readAsDataUrl(file);
                  reader.onLoadEnd.listen(
                        (loadEndEvent) async {
                      uploadToFirebase(file);
                    },
                  );
                },
              );
            }
            _expDate(BuildContext context) async {

              expire = await showDatePicker(
                context: context,
                initialDate: DateTime.now(), // Refer step 1
                firstDate: DateTime.now(),

                lastDate: DateTime(2025),
              );
              if (expire != null && expire != DateTime.now())
                setState(() {
                  final f = new DateFormat('dd-MM-yyyy');
                  expirationController.text=f.format(expire!).toString();

                });
            }
            _subDate(BuildContext context) async {
              subscription = await showDatePicker(
                context: context,
                initialDate: DateTime.now(), // Refer step 1
                firstDate: DateTime.now(),
                lastDate: DateTime(2025),
              );
              if (subscription != null && subscription != DateTime.now())
                setState(() {
                  final f = new DateFormat('dd-MM-yyyy');
                  subscriptionController.text=f.format(subscription!).toString();

                });
            }

            uploadLogoToFirebase(File imageFile) async {
              final filePath = 'images/${DateTime.now()}.png';
              print("put");
              setState((){
                logoUploading=true;
                _logoUploadTask = fb.storage().refFromURL('gs://accesfy-882e6.appspot.com').child(filePath).put(imageFile);
              });

              fb.UploadTaskSnapshot taskSnapshot = await _logoUploadTask!.future;
              logoUri = await taskSnapshot.ref.getDownloadURL();
              setState((){
                print("heer");
                logoUrl=logoUri.toString();
                logoUploading=false;
              });

            }
            uploadLogo() async {
              // HTML input element
              FileUploadInputElement uploadInput = FileUploadInputElement();
              uploadInput.click();

              uploadInput.onChange.listen(
                    (changeEvent) {
                  final file = uploadInput.files!.first;
                  final reader = FileReader();
                  reader.readAsDataUrl(file);
                  reader.onLoadEnd.listen(
                        (loadEndEvent) async {
                      uploadLogoToFirebase(file);
                    },
                  );
                },
              );
            }
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              insetAnimationDuration: const Duration(seconds: 1),
              insetAnimationCurve: Curves.fastOutSlowIn,
              elevation: 2,

              child: Container(
                padding: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height*0.9,
                width: MediaQuery.of(context).size.width*0.7,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Text("Edit Neighbour",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: secondaryColor),),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: IconButton(
                                icon: Icon(Icons.close,color: Colors.grey,),
                                onPressed: ()=>Navigator.pop(context),
                              ),
                            ),
                          )
                        ],
                      ),

                      Expanded(
                        child: ListView(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                                ),
                                TextFormField(
                                  controller: nameController,
                                  style: TextStyle(color: Colors.black),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                          color: primaryColor,
                                          width: 0.5
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5,
                                      ),
                                    ),
                                    hintText: "",
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Code",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                                ),
                                TextFormField(
                                  controller: codeController,
                                  style: TextStyle(color: Colors.black),
                                  validator: (value) {
                                    if (double.tryParse(value!)== null) {
                                      return "please enter a number";
                                    }
                                    else if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                          color: primaryColor,
                                          width: 0.5
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5,
                                      ),
                                    ),
                                    hintText: "",
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Address",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                                ),
                                TextFormField(
                                  controller: addressController,
                                  style: TextStyle(color: Colors.black),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                          color: primaryColor,
                                          width: 0.5
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5,
                                      ),
                                    ),
                                    hintText: "",
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 10,),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Quantity of Houses",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                                ),
                                TextFormField(
                                  controller: quantityOfHouseController,
                                  style: TextStyle(color: Colors.black),
                                  validator: (value) {
                                    if (double.tryParse(value!)== null) {
                                      return "please enter a number";
                                    }
                                    else if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                          color: primaryColor,
                                          width: 0.5
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5,
                                      ),
                                    ),
                                    hintText: "",
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Price Per House",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                                ),
                                TextFormField(
                                  controller: pricePerHouseController,
                                  style: TextStyle(color: Colors.black),
                                  validator: (value) {
                                    if (double.tryParse(value!)== null) {
                                      return "please enter a number";
                                    }
                                    else if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                          color: primaryColor,
                                          width: 0.5
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5,
                                      ),
                                    ),
                                    hintText: "",
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Annual Fee",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                                ),
                                TextFormField(
                                  controller: annualFeeController,
                                  style: TextStyle(color: Colors.black),
                                  validator: (value) {
                                    if (double.tryParse(value!)== null) {
                                      return "please enter a number";
                                    }
                                    else if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                          color: primaryColor,
                                          width: 0.5
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5,
                                      ),
                                    ),
                                    hintText: "",
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Billing Data",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                                ),
                                TextFormField(
                                  controller: billingDataController,
                                  style: TextStyle(color: Colors.black),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                          color: primaryColor,
                                          width: 0.5
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5,
                                      ),
                                    ),
                                    hintText: "",
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Expiration Services",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                                ),
                                TextFormField(
                                  readOnly: true,
                                  onTap: (){
                                    _expDate(context);
                                  },
                                  controller: expirationController,
                                  style: TextStyle(color: Colors.black),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                          color: primaryColor,
                                          width: 0.5
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5,
                                      ),
                                    ),
                                    hintText: "",
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Subscription Renewal",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                                ),
                                TextFormField(
                                  onTap: (){
                                    _subDate(context);
                                  },
                                  readOnly: true,
                                  controller: subscriptionController,
                                  style: TextStyle(color: Colors.black),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                          color: primaryColor,
                                          width: 0.5
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5,
                                      ),
                                    ),
                                    hintText: "",
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Discount",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                                ),
                                TextFormField(
                                  controller: discountController,
                                  style: TextStyle(color: Colors.black),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                          color: primaryColor,
                                          width: 0.5
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5,
                                      ),
                                    ),
                                    hintText: "",
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Vendor Information",
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryColor),
                                ),
                                TextFormField(
                                  controller: vendorInfoController,
                                  style: TextStyle(color: Colors.black),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                          color: primaryColor,
                                          width: 0.5
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5,
                                      ),
                                    ),
                                    hintText: "",
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 200,
                                  width: 250,
                                  child: logoUploading?Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Uploading",style: TextStyle(color: primaryColor),),
                                        SizedBox(width: 10,),
                                        CircularProgressIndicator()
                                      ],),
                                  ):logoUrl==""?
                                  Image.asset("assets/images/placeholder.png",height: 100,width: 100,fit: BoxFit.cover,)
                                      :Image.network(logoUrl,height: 100,width: 100,fit: BoxFit.cover,),
                                ),

                                InkWell(
                                  onTap: (){
                                    uploadLogo();
                                  },
                                  child: Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width*0.15,
                                    color: secondaryColor,
                                    alignment: Alignment.center,
                                    child: Text("Update Logo",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 200,
                                  width: 250,
                                  child: imageUploading?Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Uploading",style: TextStyle(color: primaryColor),),
                                        SizedBox(width: 10,),
                                        CircularProgressIndicator()
                                      ],),
                                  ):imageUrl==""?
                                  Image.asset("assets/images/placeholder.png",height: 100,width: 100,fit: BoxFit.cover,)
                                      :Image.network(imageUrl,height: 100,width: 100,fit: BoxFit.cover,),
                                ),

                                InkWell(
                                  onTap: (){
                                    uploadImage();
                                  },
                                  child: Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width*0.15,
                                    color: secondaryColor,
                                    alignment: Alignment.center,
                                    child: Text("Update Photo",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 15,),
                            InkWell(
                              onTap: (){
                                if (_formKey.currentState!.validate()) {
                                  update(imageUrl,logoUrl,model.id);
                                }
                              },
                              child: Container(
                                height: 50,
                                color: secondaryColor,
                                alignment: Alignment.center,
                                child: Text("Update",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  return DataRow(
      onSelectChanged: (newValue) {
        print('row pressed');
       _showInfoDialog(model, context);
      },
      cells: [

    DataCell(Text(model.name)),
    DataCell(Text(model.codeId)),
    DataCell(Text(model.address)),
        DataCell(Text(model.quantity)),
        DataCell(Image.network(model.logo,height: 50,width: 50,)),
        DataCell(Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: IconButton(
                icon: Icon(Icons.edit,color: Colors.white,),
                onPressed: (){
                  _showEditDialog(model, context);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: IconButton(
                icon: Icon(Icons.delete_forever,color: Colors.white,),
                onPressed: (){
                  AwesomeDialog(
                    width: MediaQuery.of(context).size.width*0.3,
                    context: context,
                    dialogType: DialogType.QUESTION,
                    animType: AnimType.BOTTOMSLIDE,
                    dialogBackgroundColor: secondaryColor,
                    title: 'Delete Neighbourhood',
                    desc: 'Are you sure you want to delete this record?',
                    btnCancelOnPress: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
                    },
                    btnOkOnPress: () {
                      FirebaseFirestore.instance.collection('neighbours').doc(model.id).delete().then((value) =>
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MainScreen())));
                    },
                  )..show();

                },
              ),
            )

          ],
        )),
  ]);
}


