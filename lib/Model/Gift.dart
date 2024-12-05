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
}
