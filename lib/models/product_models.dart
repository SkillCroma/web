class Category {
  final int id;
  final String name;
  final String slug;
  final int? parentId;

  Category({required this.id, required this.name, required this.slug, this.parentId});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      parentId: json['parent_id'],
    );
  }
}

class Brand {
  final int id;
  final String name;
  final String slug;

  Brand({required this.id, required this.name, required this.slug});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
    );
  }
}

class Attribute {
  final int id;
  final String name;
  final String slug;

  Attribute({required this.id, required this.name, required this.slug});

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
    );
  }
}

class Product {
  final int id;
  final int categoryId;
  final int? brandId;
  final String title;
  final String slug;
  final String description;
  final double price;
  final bool isVisible;

  Product({
    required this.id,
    required this.categoryId,
    this.brandId,
    required this.title,
    required this.slug,
    required this.description,
    required this.price,
    required this.isVisible,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      categoryId: json['category_id'],
      brandId: json['brand_id'],
      title: json['title'],
      slug: json['slug'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      isVisible: json['is_visible'] ?? true,
    );
  }
}

class ProductMedia {
  final int id;
  final int productId;
  final String filePath;
  final bool isPrimary;
  final int sortOrder;

  ProductMedia({
    required this.id,
    required this.productId,
    required this.filePath,
    required this.isPrimary,
    required this.sortOrder,
  });

  factory ProductMedia.fromJson(Map<String, dynamic> json) {
    return ProductMedia(
      id: json['id'],
      productId: json['product_id'],
      filePath: json['file_path'],
      isPrimary: json['is_primary'] ?? false,
      sortOrder: json['sort_order'] ?? 0,
    );
  }
}

class ProductAttributeValue {
  final int productId;
  final int attributeId;
  final String value;

  ProductAttributeValue({
    required this.productId,
    required this.attributeId,
    required this.value,
  });

  factory ProductAttributeValue.fromJson(Map<String, dynamic> json) {
    return ProductAttributeValue(
      productId: json['product_id'],
      attributeId: json['attribute_id'],
      value: json['value'],
    );
  }
}

class CatalogData {
  final List<Category> categories;
  final List<Brand> brands;
  final List<Attribute> attributes;
  final List<Product> products;
  final List<ProductMedia> productMedia;
  final List<ProductAttributeValue> productAttributeValues;

  CatalogData({
    required this.categories,
    required this.brands,
    required this.attributes,
    required this.products,
    required this.productMedia,
    required this.productAttributeValues,
  });

  factory CatalogData.fromJson(Map<String, dynamic> json) {
    return CatalogData(
      categories: (json['categories'] as List).map((i) => Category.fromJson(i)).toList(),
      brands: (json['brands'] as List).map((i) => Brand.fromJson(i)).toList(),
      attributes: (json['attributes'] as List).map((i) => Attribute.fromJson(i)).toList(),
      products: (json['products'] as List).map((i) => Product.fromJson(i)).toList(),
      productMedia: (json['product_media'] as List).map((i) => ProductMedia.fromJson(i)).toList(),
      productAttributeValues: (json['product_attribute_values'] as List).map((i) => ProductAttributeValue.fromJson(i)).toList(),
    );
  }
}
