class place_order_model{

  final String product_id;
  final String varient_id;
  final String address_id;
  final String payment_method;
  final String order_date;
  final String transaction_id;
  final String  payment_status;
  final String qty;
  final String choosen_date;
  final String choosen_time;
  late List<place_order_model> data;


  place_order_model({
    required this.product_id,
    required this.varient_id,
    required this.address_id,
    required this.payment_method,
    required this.order_date,
    required this.transaction_id,
    required this.payment_status,
    required this.qty,
    required this.choosen_date,
    required this.choosen_time,

  });

  factory place_order_model.fromJson(Map<String, dynamic> json) {
    return place_order_model(
      product_id: json['product_id'] as String,
      varient_id: json['varient_id'] as String,
      address_id: json['address_id'] as String,
      payment_method: json['payment_method'] as String,
      order_date: json['order_date'] as String,
      transaction_id: json['transaction_id'] as String,
      payment_status: json['payment_status'] as String,
      qty: json['qty'] as String,
      choosen_date: json['choosen_date']==null?'':json['choosen_date'] as String,
      choosen_time: json['choosen_time']==null?'':json['choosen_time'] as String,

    );
  }
  /*Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = required this.data.map((v) => v.toJson()).toList();
  }*/
}


