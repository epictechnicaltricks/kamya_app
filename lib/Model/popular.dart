class Popular {

  final String event_id;
  final String category_id;
  final String event_img;
 // final String  status;
  late List<Popular> data;

  Popular({
    required this.event_id,
    required this.category_id,
    required this.event_img,
    //required this.status,
  });

  factory Popular.fromJson(Map<String, dynamic> json) {
    return Popular(
      event_id: json['event_id'] as String,
      event_img: json['event_img'] as String,
      category_id: json['category_id'] as String,
    );
  }
  /*Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = required this.status;

    data['data'] = required this.data.map((v) => v.toJson()).toList();
  }*/
}


