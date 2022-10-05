class cart_list{

  final String product_id;
  final String product_name;
  final String product_img;
  final String varient_id;
  final String varient_name;
  final String varient_price;
  final String varient_mrp;
  //final String  status;
  final String category_name;
  final String cart_id;
  final String qty;
  late List<cart_list> data;


  cart_list({
    //required this.status,
    required this.product_id,
    required this.product_name,
    required this.product_img,
    required this.varient_id,
    required this.varient_name,
    required this.varient_price,
    required this.varient_mrp,
    required this.category_name,
    required this.cart_id,
    required this.qty
  });

  factory cart_list.fromJson(Map<String, dynamic> json) {
    return cart_list(
      product_id: json['product_id'] as String,
      product_name: json['product_name'] as String,
      product_img: json['product_img'] as String,
      varient_id: json['varient_id'] as String,
      varient_name: json['varient_name'] as String,
      varient_price: json['varient_price'] as String,
      varient_mrp: json['varient_mrp'] as String,
      category_name: json['category_name'] as String,
      cart_id: json['cart_id'] as String,
      qty: json['qty'] as String,
     // status: json['status'] as String,
    );
  }
  /*Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = required this.status;
    data['data'] = required this.data.map((v) => v.toJson()).toList();
  }*/
}


