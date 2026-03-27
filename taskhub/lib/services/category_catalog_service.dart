import 'dart:convert';

import 'package:flutter/services.dart';

class ServiceSubcategory {
  final String id;
  final String name;
  final String categoryId;
  final String categoryName;

  const ServiceSubcategory({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
  });

  String get qualifiedId => '$categoryId::$id';
  String get displayName => '$categoryName > $name';
}

class ServiceCategory {
  final String id;
  final String name;
  final List<ServiceSubcategory> subcategories;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.subcategories,
  });
}

class CategoryCatalogService {
  static const String _assetPath = 'assets/data/categorias.json';

  static Future<List<ServiceCategory>> loadCategories() async {
    final raw = await rootBundle.loadString(_assetPath);
    final decoded = jsonDecode(raw) as List<dynamic>;

    final categoryById = <String, ServiceCategory>{};

    for (final item in decoded) {
      final map = item as Map<String, dynamic>;
      final categoryId = (map['id'] ?? '').toString().trim();
      final categoryName = (map['name'] ?? '').toString().trim();
      if (categoryId.isEmpty || categoryName.isEmpty) {
        continue;
      }

      final subItems = (map['subcategories'] as List<dynamic>? ?? [])
          .map((sub) {
            final subMap = sub as Map<String, dynamic>;
            return ServiceSubcategory(
              id: (subMap['id'] ?? '').toString().trim(),
              name: (subMap['name'] ?? '').toString().trim(),
              categoryId: categoryId,
              categoryName: categoryName,
            );
          })
          .where((sub) => sub.id.isNotEmpty && sub.name.isNotEmpty)
          .toList();

      if (!categoryById.containsKey(categoryId)) {
        categoryById[categoryId] = ServiceCategory(
          id: categoryId,
          name: categoryName,
          subcategories: [],
        );
      }

      final existing = categoryById[categoryId]!;
      final deduped = <String, ServiceSubcategory>{
        for (final sub in existing.subcategories) sub.qualifiedId: sub,
      };
      for (final sub in subItems) {
        deduped[sub.qualifiedId] = sub;
      }

      categoryById[categoryId] = ServiceCategory(
        id: existing.id,
        name: existing.name,
        subcategories: deduped.values.toList(),
      );
    }

    return categoryById.values.toList();
  }

  static List<ServiceSubcategory> flattenSubcategories(
    List<ServiceCategory> categories,
  ) {
    return categories.expand((category) => category.subcategories).toList();
  }

  static List<ServiceSubcategory> filterSubcategoriesByQualifiedIds(
    List<ServiceCategory> categories,
    List<String> qualifiedIds,
  ) {
    final wanted = qualifiedIds.toSet();
    return flattenSubcategories(
      categories,
    ).where((sub) => wanted.contains(sub.qualifiedId)).toList();
  }
}
