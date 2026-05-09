/// Represents a meal category returned from /categories.php
class MealCategory {
  final String idCategory;
  final String strCategory;
  final String strCategoryThumb;
  final String strCategoryDescription;

  const MealCategory({
    required this.idCategory,
    required this.strCategory,
    required this.strCategoryThumb,
    required this.strCategoryDescription,
  });

  factory MealCategory.fromJson(Map<String, dynamic> json) {
    return MealCategory(
      idCategory: json['idCategory'] as String,
      strCategory: json['strCategory'] as String,
      strCategoryThumb: json['strCategoryThumb'] as String,
      strCategoryDescription:
          json['strCategoryDescription'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'idCategory': idCategory,
        'strCategory': strCategory,
        'strCategoryThumb': strCategoryThumb,
        'strCategoryDescription': strCategoryDescription,
      };

  MealCategory copyWith({
    String? idCategory,
    String? strCategory,
    String? strCategoryThumb,
    String? strCategoryDescription,
  }) {
    return MealCategory(
      idCategory: idCategory ?? this.idCategory,
      strCategory: strCategory ?? this.strCategory,
      strCategoryThumb: strCategoryThumb ?? this.strCategoryThumb,
      strCategoryDescription:
          strCategoryDescription ?? this.strCategoryDescription,
    );
  }
}
