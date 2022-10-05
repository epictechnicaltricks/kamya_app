class order_list_model{

  final String order_id;
  final String order_date;
  final String order_status;
  final String order_total;
  final String payment_method;
  final String addr_address_1;
  final String addr_address_2;
  final String addr_city;
  final String addr_near_by;
  final String addr_pincode;
  final String rating;
  final String choosen_date;
  final String choosen_time;
  final String order_type;

  late List<order_list_model> data;


  order_list_model({
    required this.order_id,
    required this.order_date,
    required this.order_status,
    required this.order_total,
    required this.payment_method,
    required this.addr_address_1,
    required this.addr_address_2,
    required this.addr_near_by,
    required this.addr_city,
    required this.addr_pincode,
    required this.rating,
    required this.choosen_date,
    required this.choosen_time,
    required this.order_type,


  });

  factory order_list_model.fromJson(Map<String, dynamic> json) {
    return order_list_model(
      order_id: json['order_id'] as String,
      order_date: json['order_date'] as String,
      order_status: json['order_status'] as String,
      order_total: json['order_total'] as String,
      payment_method: json['payment_method'] as String,
      addr_address_1: json['addr_address_1']==null?'-':json['addr_address_1'] as String,
      addr_address_2: json['addr_address_2']==null?'-':json['addr_address_2'] as String,
      addr_city: json['addr_city']==null?'-':json['addr_city'] as String,
      addr_near_by:json['addr_near_by']==null?'-': json['addr_near_by'] as String,
      addr_pincode: json['addr_pincode']==null?'-':json['addr_pincode'] as String,
      rating: json['rating']==null?'0':json['rating'] as String,
      choosen_date: json['choosen_date']==null?'':json['choosen_date'] as String,
      choosen_time: json['choosen_time']==null?'':json['choosen_time'] as String,
      order_type: json['order_type']==null?'':json['order_type'] as String,

    );
  }
  /*Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = required this.data.map((v) => v.toJson()).toList();
  }*/
}


