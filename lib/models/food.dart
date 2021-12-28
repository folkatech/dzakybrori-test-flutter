class Food {
  // Using final because no data will change on this values.
  final int id;
  final String name;
  final String cover;
  final String desc;
  final int price;
  bool isBookmarked;

  Food({
    required this.id,
    required this.name,
    required this.cover,
    required this.desc,
    required this.price,
    this.isBookmarked = false,
  });

  // Method to convert json value into an Food Object
  factory Food.fromJson(Map<String, dynamic> json) => Food(
        id: json['id'],
        name: json['name'],
        cover: json['cover'],
        desc: json['desc'],
        price: json['price'],
      );
}
