class Banners {

  final String banner_id;
  final String banner_img;
  //final String  status;
  late List<Banners> data;

  Banners({
    required this.banner_id,
    required this.banner_img,
   // required this.status,
  });

  factory Banners.fromJson(Map<String, dynamic> json) {
    return Banners(
      banner_id: json['banner_id'] as String,
      banner_img: json['banner_img'] as String,
    );
  }
/*  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.status;

    data['data'] = this.data.map((v) => v.toJson()).toList();
  }*/
}


