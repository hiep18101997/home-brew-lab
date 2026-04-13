/// Flavor tag from SCA flavor wheel
class FlavorTag {
  final String name;
  final String category;

  const FlavorTag({
    required this.name,
    required this.category,
  });

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is FlavorTag &&
    runtimeType == other.runtimeType &&
    name == other.name;

  @override
  int get hashCode => name.hashCode;
}

/// SCA Flavor wheel tags
class FlavorTags {
  static const List<String> categories = [
    'Fruity',
    'Floral',
    'Sweet',
    'Nutty',
    'Cocoa',
    'Spicy',
    'Roasted',
    'Other',
  ];

  static const Map<String, List<FlavorTag>> byCategory = {
    'Fruity': [
      FlavorTag(name: 'Berry', category: 'Fruity'),
      FlavorTag(name: 'Dried Fruit', category: 'Fruity'),
      FlavorTag(name: 'Citrus', category: 'Fruity'),
      FlavorTag(name: 'Other Fruit', category: 'Fruity'),
    ],
    'Floral': [
      FlavorTag(name: 'Floral', category: 'Floral'),
      FlavorTag(name: 'Jasmine', category: 'Floral'),
      FlavorTag(name: 'Rose', category: 'Floral'),
    ],
    'Sweet': [
      FlavorTag(name: 'Caramel', category: 'Sweet'),
      FlavorTag(name: 'Honey', category: 'Sweet'),
      FlavorTag(name: 'Maple', category: 'Sweet'),
      FlavorTag(name: 'Brown Sugar', category: 'Sweet'),
    ],
    'Nutty': [
      FlavorTag(name: 'Almond', category: 'Nutty'),
      FlavorTag(name: 'Hazelnut', category: 'Nutty'),
      FlavorTag(name: 'Peanut', category: 'Nutty'),
    ],
    'Cocoa': [
      FlavorTag(name: 'Chocolate', category: 'Cocoa'),
      FlavorTag(name: 'Dark Chocolate', category: 'Cocoa'),
    ],
    'Spicy': [
      FlavorTag(name: 'Cinnamon', category: 'Spicy'),
      FlavorTag(name: 'Clove', category: 'Spicy'),
      FlavorTag(name: 'Pepper', category: 'Spicy'),
    ],
    'Roasted': [
      FlavorTag(name: 'Cereal', category: 'Roasted'),
      FlavorTag(name: 'Pipe Tobacco', category: 'Roasted'),
    ],
    'Other': [
      FlavorTag(name: 'Earthy', category: 'Other'),
      FlavorTag(name: 'Herbal', category: 'Other'),
      FlavorTag(name: 'Vegetal', category: 'Other'),
    ],
  };

  static List<FlavorTag> get all {
    return byCategory.values.expand((tags) => tags).toList();
  }

  static List<FlavorTag> getByCategory(String category) {
    return byCategory[category] ?? [];
  }
}