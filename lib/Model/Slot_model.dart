class Slot_Model {
  late String status;
  late List<All_Slot> data=[];

  Slot_Model({required this.status, required this.data});

  Slot_Model.fromJson(Map<String, dynamic> json) {
    status = json['success'];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(new All_Slot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['success'] = required this.status;

    if ( this.data != null) {
      data['data'] =  this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class All_Slot {

  late String slot_day;
  late String slot_time;

  All_Slot({required this.slot_day, required this.slot_time});

  All_Slot.fromJson(Map<String, dynamic> json) {
    slot_day = json['slot_day']==null?'':json['slot_day'];
    slot_time = json['slot_time'];}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slot_time'] =  this.slot_time;
    data['slot_day'] =  this.slot_day;
    return data;
  }
}