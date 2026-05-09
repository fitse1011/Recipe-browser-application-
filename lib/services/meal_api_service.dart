import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/meal.dart';
import '../models/meal_category.dart';
import 'api_exception.dart';

/// Handles all HTTP communication with TheMealDB API.
///
/// All API calls are centralised here — no HTTP logic exists outside this class.
class MealApiService {
  // ── Configuration ────────────────────────────────────────────────────────
  final String _baseUrl = 'www.themealdb.com';
  final String _basePath = 'api/json/v1/1';
  final Duration _timeout = const Duration(seconds: 10);
  final Map<String, String> _headers = const {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ── Private helpers ──────────────────────────────────────────────────────

  /// Throws [ApiException] when the response status is not 200.
  void _checkResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw ApiException(
        statusCode: response.statusCode,
        message:
            'Server returned status ${response.statusCode}. '
            'Please try again later.',
      );
    }
  }

  // ── Public API methods ───────────────────────────────────────────────────

  /// Fetches all meal categories from `/categories.php`.
  Future<List<MealCategory>> fetchAllCategories() async {
    final uri = Uri.https(_baseUrl, '$_basePath/categories.php');

    final response = await http
        .get(uri, headers: _headers)
        .timeout(_timeout);

    _checkResponse(response);

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final list = body['categories'] as List<dynamic>;
    return list
        .map((e) => MealCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetches all meals within a given [category] from `/filter.php?c=`.
  Future<List<Meal>> fetchMealsByCategory(String category) async {
    final uri = Uri.https(
      _baseUrl,
      '$_basePath/filter.php',
      {'c': category},
    );

    final response = await http
        .get(uri, headers: _headers)
        .timeout(_timeout);

    _checkResponse(response);

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final list = body['meals'] as List<dynamic>? ?? [];
    return list
        .map((e) => Meal.fromSummaryJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetches the full meal detail for [mealId] from `/lookup.php?i=`.
  Future<Meal> fetchMealById(String mealId) async {
    final uri = Uri.https(
      _baseUrl,
      '$_basePath/lookup.php',
      {'i': mealId},
    );

    final response = await http
        .get(uri, headers: _headers)
        .timeout(_timeout);

    _checkResponse(response);

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final list = body['meals'] as List<dynamic>?;

    if (list == null || list.isEmpty) {
      throw ApiException(
        statusCode: 404,
        message: 'Meal with id $mealId was not found.',
      );
    }

    return Meal.fromJson(list.first as Map<String, dynamic>);
  }
}
