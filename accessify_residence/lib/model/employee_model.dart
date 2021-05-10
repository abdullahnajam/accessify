class EmployeeModel{
  String id,name,email,fromDate,expDate,vehicle,photo,hoursAllowed;
  List<dynamic> daysAllowed;

  EmployeeModel(this.id, this.name, this.email, this.fromDate, this.expDate,
      this.vehicle, this.photo, this.hoursAllowed, this.daysAllowed);
}