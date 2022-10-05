class City_list {

  final String city_id;
  final String city_img;
  final String city_name;
  //final String  status;
  late List<City_list> data;

  City_list({
    required this.city_id,
    required this.city_img,
    required this.city_name,
    //required this.status,
  });

  factory City_list.fromJson(Map<String, dynamic> json) {
    return City_list(
      city_id: json['city_id'] as String,
      city_img: json['city_img'] as String,
      city_name: json['city_name'] as String,
    );
  }
 /* Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = required this.status;

    data['data'] = required this.data.map((v) => v.toJson()).toList();
  }*/
}


