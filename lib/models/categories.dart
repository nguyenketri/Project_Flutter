class CategoryModel {
  final int id;
  final String name;
  final int retailerId;

  CategoryModel({
    required this.id,
    required this.name,
    required this.retailerId,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['Id'],
      name: json['Name'] ?? '',
      retailerId: json['RetailerId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {"Id": id, "Name": name, "RetailerId": retailerId};
  }
}
