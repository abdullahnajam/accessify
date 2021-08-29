class VehicleModel{
  String id,make,model,color,plate,year;bool tag,acceptance;

  VehicleModel(this.id, this.make, this.model, this.color, this.plate,this.year,
      this.tag,this.acceptance);

  VehicleModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        make = map['make'],
        model = map['model'],
        color = map['color'],
        plate = map['plate'],
        year = map['year'];
}