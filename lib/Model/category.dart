class Category {

  final String category_id;
  final String category_img;
  final String category_name;
 // final String  status;
  late List<Category> data;

  Category({
    required this.category_id,
    required this.category_img,
    required this.category_name,
    //required this.status,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      category_id: json['category_id'] as String,
      category_img: json['category_img'] as String,
      category_name: json['category_name'] as String,
    );
  }
 /* Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = required this.status;

    data['data'] = required this.data.map((v) => v.toJson()).toList();
  }*/
}


