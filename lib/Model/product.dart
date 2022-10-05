
class product_list{

  final String product_id;
  final String product_name;
  final String product_img;
  final String varient_name;
  final String varient_price;
  final String varient_mrp;
  //final String  status;
  final String  varient_id;
  final String shopping_list_product_id;
  final String? list_status;
  final String? product_status;

  //varients_data varientdata;

  late List<product_list> data;


  product_list({
   // required this.status,
    required this.product_id,
    required this.product_name,
    required this.product_img,
    required this.varient_name,
    required this.varient_price,
    required this.varient_mrp,
    required this.varient_id,
    required this.shopping_list_product_id,
    required this.list_status,
    required this.product_status
   // required this.varientdata,

  });

  factory product_list.fromJson(Map<String, dynamic> json) {
    return product_list(
      product_id: json['product_id'] as String,
      product_name: json['product_name'] as String,
      product_img: json['product_img'] as String,
      varient_name: json['varient_name'] as String,
      varient_price: json['varient_price'] as String,
      varient_mrp: json['varient_mrp'] as String,
      varient_id: json['varient_id']==null?' ':json['varient_id'] as String,
     // status: json['status'] as String,
      list_status:json['list_status']==null?' ': json['list_status'] as String,
      //varientdata = json['varientdata'] != null ? new varients_data.fromJson(json['varientdata']) : null;

      shopping_list_product_id: json['shopping_list_product_id']==null?' ':json['shopping_list_product_id'] as String,
      product_status: json['product_status']==null?' ':json['product_status'] as String,

    );
  }
  /*Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = required this.status;

    data['data'] = required this.data.map((v) => v.toJson()).toList();
  }*/
}
class varients_data{

  final String product_id;
  final String varient_name;
  final String varient_price;
  final String varient_mrp;
  final String varient_id;
 //final  String status;
  late List<varients_data> data;


  varients_data({
    required this.product_id,
    required this.varient_name,
    required this.varient_price,
    required this.varient_id,
    required this.varient_mrp,
    //required this.status
  });

  factory varients_data.fromJson(Map<String, dynamic> json) {
    return varients_data(
      product_id: json['product_id'] as String,
      varient_name: json['varient_name'] as String,
      varient_price: json['varient_price'] as String,
      varient_mrp: json['varient_mrp'] as String,
      varient_id: json['varient_id'] as String,
    );
  }
 /* Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = required this.status;

    data['data'] = required this.data.map((v) => v.toJson()).toList();
  }*/
}


