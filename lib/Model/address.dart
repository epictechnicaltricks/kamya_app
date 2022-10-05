class address_list{

  final String addr_id;
  //final String addruser_id;
  final String addr_address_1;
  final String addr_address_2;
  final String addr_city;
  final String addr_pincode;
  final String addr_phone;
  final String addr_type;
  final String addr_near_by;

  //final String  status;
  late List<address_list> data;

  address_list({
    required this.addr_id,
    //required this.addruser_id,
    required this.addr_address_1,
    required this.addr_address_2,
    required this.addr_city,
    required this.addr_phone,
    required this.addr_pincode,
    required this.addr_type,
    required this.addr_near_by,
    //required this.status,
  });

  factory address_list.fromJson(Map<String, dynamic> json) {
    return address_list(
      addr_id: json['addr_id'] as String,
      addr_address_1: json['addr_address_1'] as String,
      addr_address_2: json['addr_address_2'] as String,
      addr_city: json['addr_city'] as String,
      addr_pincode: json['addr_pincode'] as String,
      addr_phone: json['addr_phone'] as String,
      addr_type: json['addr_type'] as String,
      addr_near_by: json['addr_near_by'] as String,
      //status: '',
      //addruser_id: '',
    );
  }
  /*Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.status;

    data['data'] = this.data.map((v) => v.toJson()).toList();
  }*/
}


