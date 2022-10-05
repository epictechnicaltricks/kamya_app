class varient_data{

  final String product_id;
  final String varient_name;
  final String varient_price;
  final String varient_mrp;
  final String varient_id;
  //final String status;
  final String product_varient_id;
  late List<varient_data> data;


  varient_data({
    required this.product_id,
    required this.product_varient_id,
    required this.varient_name,
    required this.varient_price,
    required this.varient_id,
    required this.varient_mrp,
    //required this.status
  });

  factory varient_data.fromJson(Map<String, dynamic> json) {
    return varient_data(
      product_id: json['product_id'] as String,
      product_varient_id:json['product_varient_id'] as String,
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


