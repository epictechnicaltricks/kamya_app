class Notification_list{

  final String notification_id;
  final String title;
  final String message;
  final String notification_datetime;
  //final String  status;
  late List<Notification_list> data;

  Notification_list({
    required this.notification_id,
    required this.title,
    required this.message,
    required this.notification_datetime,
    //required this.status,
  });

  factory Notification_list.fromJson(Map<String, dynamic> json) {
    return Notification_list(
      notification_id: json['notification_id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      notification_datetime: json['notification_datetime'] as String,
    );
  }
 /* Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = required this.status;

    data['data'] = required this.data.map((v) => v.toJson()).toList();
  }*/
}


