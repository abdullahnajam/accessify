class EventModel{
  String id,name,location,date,startTime,qr,userId;
  List<EventGuestList> guests;

  EventModel(this.id, this.name, this.location, this.date, this.startTime,
      this.guests,this.qr,this.userId);

}
class EventGuestList{
  String id,name,email;
  EventGuestList(this.id,this.name, this.email);

}
