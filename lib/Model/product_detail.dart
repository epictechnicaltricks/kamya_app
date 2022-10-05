class product_detail_list{

  final String product_id;
  final String product_name;
  final String product_img;
  final String varient_name;
  final String varient_price;
  //final String  status;
  final String product_desc;
  final String varient_mrp;
  final String varient_id;
  final String product_varient_id;
  String product_status;
  String varient_status;
  late List<product_detail_list> data;


  product_detail_list({
    //required this.status,
    required this.product_id,
    required this.product_name,
    required this.product_img,
    required this.varient_name,
    required this.varient_price,
    required this.product_desc,
    required this.varient_id,
    required this.product_varient_id,
    required this.varient_mrp,
    required this.product_status,
    required this.varient_status,

  });

  factory product_detail_list.fromJson(Map<String, dynamic> json) {
    return product_detail_list(
      product_id: json['product_id'] as String,
      product_name: json['product_name'] as String,
      product_desc:json['product_desc'] as String,
      product_img: json['product_img'] as String,
      varient_name: json['varient_name'] as String,
      varient_price: json['varient_price'] as String,
      varient_mrp: json['varient_mrp'] as String,
      varient_id: json['varient_id'] as String,
      product_varient_id:json['product_varient_id'] as String,
      product_status: json['product_status']==null?' ':json['product_status'] as String,
      varient_status: json['varient_status']==null?' ':json['varient_status'] as String,

      // status: json['status'] as String,
    );
  }
 /* Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = required this.status;

    data['data'] = required this.data.map((v) => v.toJson()).toList();
  }*/
}


