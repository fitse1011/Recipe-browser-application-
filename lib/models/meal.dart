/// A single ingredient with its measurement.
class Ingredient {
  final String name;
  final String measure;

  const Ingredient({required this.name, required this.measure});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] as String,
      measure: json['measure'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'measure': measure,
      };

  Ingredient copyWith({String? name, String? measure}) {
    return Ingredient(
      name: name ?? this.name,
      measure: measure ?? this.measure,
    );
  }
}

/// Represents a full meal or a meal summary.
///
/// When loaded from /filter.php, only [idMeal], [strMeal], and [strMealThumb]
/// are populated. When loaded from /lookup.php all fields are populated.
class Meal {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;
  final String strCategory;
  final String strArea;
  final String strInstructions;
  final String strYoutube;
  final List<Ingredient> ingredients;

  const Meal({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
    required this.strCategory,
    required this.strArea,
    required this.strInstructions,
    required this.strYoutube,
    required this.ingredients,
  });

  /// Parses a full meal detail response (from /lookup.php).
  factory Meal.fromJson(Map<String, dynamic> json) {
    final ingredients = <Ingredient>[];
    for (int i = 1; i <= 20; i++) {
      final name = json['strIngredient$i'] as String? ?? '';
      final measure = json['strMeasure$i'] as String? ?? '';
      if (name.trim().isNotEmpty) {
        ingredients.add(
          Ingredient(name: name.trim(), measure: measure.trim()),
        );
      }
    }

    return Meal(
      idMeal: json['idMeal'] as String,
      strMeal: json['strMeal'] as String,
      strMealThumb: json['strMealThumb'] as String? ?? '',
      strCategory: json['strCategory'] as String? ?? '',
      strArea: json['strArea'] as String? ?? '',
      strInstructions: json['strInstructions'] as String? ?? '',
      strYoutube: json['strYoutube'] as String? ?? '',
      ingredients: ingredients,
    );
  }

  /// Parses a meal summary from /filter.php (only id, name, thumbnail).
  factory Meal.fromSummaryJson(Map<String, dynamic> json) {
    return Meal(
      idMeal: json['idMeal'] as String,
      strMeal: json['strMeal'] as String,
      strMealThumb: json['strMealThumb'] as String? ?? '',
      strCategory: '',
      strArea: '',
      strInstructions: '',
      strYoutube: '',
      ingredients: const [],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'idMeal': idMeal,
      'strMeal': strMeal,
      'strMealThumb': strMealThumb,
      'strCategory': strCategory,
      'strArea': strArea,
      'strInstructions': strInstructions,
      'strYoutube': strYoutube,
    };
    for (int i = 0; i < ingredients.length; i++) {
      map['strIngredient${i + 1}'] = ingredients[i].name;
      map['strMeasure${i + 1}'] = ingredients[i].measure;
    }
    return map;
  }

  Meal copyWith({
    String? idMeal,
    String? strMeal,
    String? strMealThumb,
    String? strCategory,
    String? strArea,
    String? strInstructions,
    String? strYoutube,
    List<Ingredient>? ingredients,
  }) {
    return Meal(
      idMeal: idMeal ?? this.idMeal,
      strMeal: strMeal ?? this.strMeal,
      strMealThumb: strMealThumb ?? this.strMealThumb,
      strCategory: strCategory ?? this.strCategory,
      strArea: strArea ?? this.strArea,
      strInstructions: strInstructions ?? this.strInstructions,
      strYoutube: strYoutube ?? this.strYoutube,
      ingredients: ingredients ?? this.ingredients,
    );
  }
}
