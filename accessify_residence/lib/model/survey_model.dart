import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyModel{
  String id,question,status;
  List choices,attempts;
  bool isMCQ;

  SurveyModel(this.id, this.question, this.status, this.choices, this.isMCQ,this.attempts);

  SurveyModel.fromMap(Map<String,dynamic> map,String key)
      : id=key,
        question = map['question'],
        status = map['status'],
        choices = map['choices'],
        isMCQ = map['isMCQ'],
        attempts = map['attempts'];



  SurveyModel.fromSnapshot(DocumentSnapshot snapshot )
      : this.fromMap(snapshot.data() as Map<String, dynamic>,snapshot.reference.id);
}
class SurveyAttemptModel{
  String id,userId,name,choiceSelected,answer;
  bool isMCQ;

  SurveyAttemptModel(this.id, this.userId, this.name, this.choiceSelected,
      this.answer,this.isMCQ);
}