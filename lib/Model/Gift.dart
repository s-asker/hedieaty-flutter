class Gift {
  final String id;
  final String name;
  final String description;
  String status;
  final String category; // Added category
  final double price; // Added price

  Gift({
    required this.id,
    required this.name,
    this.description = "",
    this.status = 'available',
    this.category = "General", // Default category
    this.price = 0.0, // Default price
  });

  // Copy constructor to create a new instance with updated properties
  Gift copyWith({
    String? name,
    String? description,
    String? status,
    String? category,
    double? price,
  }) {
    return Gift(
      id: this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      category: category ?? this.category,
      price: price ?? this.price,
    );
  }

  factory Gift.fromMap(Map<String, dynamic> gift) {
    return Gift(
      id: gift['id'] as String,  // Make sure 'id' is a String
      name: gift['name'] as String,  // Make sure 'name' is a String
      description: gift['description'] as String? ?? "",  // Make sure 'description' is a String, default to empty if null
      status: gift['status'] as String? ?? 'available',  // Default to 'available' if 'status' is null
      category: gift['category'] as String? ?? 'General',  // Default to 'General' if 'category' is null
      price: gift['price'] as double? ?? 0.0,  // Default to 0.0 if 'price' is null
    );
  }


}
