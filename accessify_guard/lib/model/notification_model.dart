class NotificationModel{
  String id,type,date,body,title,icon,userId;
  bool isOpened;

  NotificationModel(this.id, this.isOpened, this.type, this.date, this.body,
      this.title, this.icon, this.userId);
}