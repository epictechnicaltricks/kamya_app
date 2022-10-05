class promocode_list{

  final String promocode_id;
  final String promocode;
  final String valid_from;
  final String valid_till;
  final String  promocode_desc;
  final String  discount;

  late List<promocode_list> data;

  promocode_list({
    required this.promocode_id,
    required this.promocode,
    required this.valid_from,
    required this.valid_till,
    required this.promocode_desc,
    required this.discount,
  });

  factory promocode_list.fromJson(Map<String, dynamic> json) {
    return promocode_list(
      promocode_id: json['promocode_id'] as String,
      promocode: json['promocode'] as String,
      valid_from: json['valid_from'] as String,
      valid_till: json['valid_to'] as String,
      promocode_desc: json['promocode_desc'] as String,
      discount: json['discount'] as String,
    );
  }
  /*Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = required this.data.map((v) => v.toJson()).toList();
  }*/
}


