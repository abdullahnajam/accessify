class EventModel{
  String id,name,location,date,startTime,qr,userId;
  List<EventGuestList> guests;
  String status;

  EventModel(this.id, this.name, this.location, this.date, this.startTime,
      this.guests,this.qr,this.userId,this.status);

}
class EventGuestList{
  String name,email;

  EventGuestList(this.name, this.email);

}