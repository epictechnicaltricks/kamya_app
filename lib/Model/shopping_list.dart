class shopping_list_model{

  final String shopping_list_id;
  final String list_name;
  //final String  status;
  final String total;
  late List<shopping_list_model> data;


  shopping_list_model({
   // required this.status,
    required this.shopping_list_id,
    required this.list_name,
    required this.total,
  });

  factory shopping_list_model.fromJson(Map<String, dynamic> json) {
    return shopping_list_model(
      shopping_list_id: json['shopping_list_id'] as String,
      list_name: json['list_name'] as String,
      total: json['total'] as String,
    );
  }
 /* Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = required this.status;

    data['data'] = required this.data.map((v) => v.toJson()).toList();
  }*/
}


