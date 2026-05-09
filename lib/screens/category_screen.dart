import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../models/meal_category.dart';
import '../services/meal_api_service.dart';
import 'error_view.dart';
import 'meal_detail_screen.dart';

/// Category screen — lists all meals within a selected [category].
class CategoryScreen extends StatefulWidget {
  final MealCategory category;

  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final MealApiService _apiService = MealApiService();
  late Future<List<Meal>> _mealsFuture;

  @override
  void initState() {
    super.initState();
    _mealsFuture =
        _apiService.fetchMealsByCategory(widget.category.strCategory);
  }

  void _reload() {
    setState(() {
      _mealsFuture =
          _apiService.fetchMealsByCategory(widget.category.strCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Collapsible header with category image ──────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.category.strCategory,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black45)],
                ),
              ),
              background: Image.network(
                widget.category.strCategoryThumb,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: theme.colorScheme.primary),
              ),
            ),
          ),

          // ── Meal list ───────────────────────────────────────────────────
          SliverFillRemaining(
            child: FutureBuilder<List<Meal>>(
              future: _mealsFuture,
              builder: (context, snapshot) {
                // Waiting
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Error
                if (snapshot.hasError) {
                  return ErrorView(
                      error: snapshot.error!, onRetry: _reload);
                }

                // No data
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No meals found in this category.'),
                  );
                }

                // Data
                final meals = snapshot.data!;
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 16),
                  itemCount: meals.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final meal = meals[index];
                    return _MealListTile(meal: meal);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Private tile widget ───────────────────────────────────────────────────────

class _MealListTile extends StatelessWidget {
  final Meal meal;

  const _MealListTile({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            meal.strMealThumb,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 64,
              height: 64,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.broken_image_outlined),
            ),
          ),
        ),
        title: Text(
          meal.strMeal,
          style: const TextStyle(fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MealDetailScreen(mealId: meal.idMeal),
            ),
          );
        },
      ),
    );
  }
}
