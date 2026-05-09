import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/meal.dart';
import '../services/meal_api_service.dart';
import 'error_view.dart';

/// Meal detail screen — shows the full recipe, ingredient list, instructions,
/// and a button to open the YouTube tutorial via [url_launcher].
class MealDetailScreen extends StatefulWidget {
  final String mealId;

  const MealDetailScreen({super.key, required this.mealId});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final MealApiService _apiService = MealApiService();
  late Future<Meal> _mealFuture;

  @override
  void initState() {
    super.initState();
    _mealFuture = _apiService.fetchMealById(widget.mealId);
  }

  void _reload() {
    setState(() {
      _mealFuture = _apiService.fetchMealById(widget.mealId);
    });
  }

  Future<void> _openYouTube(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open YouTube link.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Meal>(
        future: _mealFuture,
        builder: (context, snapshot) {
          // Waiting
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Error
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Recipe')),
              body: ErrorView(error: snapshot.error!, onRetry: _reload),
            );
          }

          // No data
          if (!snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(title: const Text('Recipe')),
              body: const Center(child: Text('Meal details unavailable.')),
            );
          }

          // Data
          final meal = snapshot.data!;
          return _MealDetailBody(
            meal: meal,
            onWatchYouTube: () => _openYouTube(meal.strYoutube),
          );
        },
      ),
    );
  }
}

// ── Body widget ───────────────────────────────────────────────────────────────

class _MealDetailBody extends StatelessWidget {
  final Meal meal;
  final VoidCallback onWatchYouTube;

  const _MealDetailBody({
    required this.meal,
    required this.onWatchYouTube,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        // ── Hero image + app bar ──────────────────────────────────────────
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              meal.strMeal,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                shadows: [Shadow(blurRadius: 6, color: Colors.black54)],
              ),
            ),
            background: meal.strMealThumb.isNotEmpty
                ? Image.network(meal.strMealThumb, fit: BoxFit.cover)
                : Container(color: theme.colorScheme.primary),
          ),
        ),

        // ── Content ───────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Meta chips
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    if (meal.strCategory.isNotEmpty)
                      _MetaChip(
                          icon: Icons.category_outlined,
                          label: meal.strCategory),
                    if (meal.strArea.isNotEmpty)
                      _MetaChip(
                          icon: Icons.public_rounded, label: meal.strArea),
                  ],
                ),
                const SizedBox(height: 24),

                // Ingredients section
                if (meal.ingredients.isNotEmpty) ...[
                  _SectionTitle(title: 'Ingredients (${meal.ingredients.length})'),
                  const SizedBox(height: 10),
                  _IngredientTable(ingredients: meal.ingredients),
                  const SizedBox(height: 28),
                ],

                // Instructions section
                if (meal.strInstructions.isNotEmpty) ...[
                  const _SectionTitle(title: 'Instructions'),
                  const SizedBox(height: 10),
                  Text(
                    meal.strInstructions,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.65,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                    ),
                  ),
                  const SizedBox(height: 28),
                ],

                // YouTube button
                if (meal.strYoutube.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFF0000),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.play_circle_fill_rounded),
                      label: const Text(
                        'Watch on YouTube',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      onPressed: onWatchYouTube,
                    ),
                  ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Chip(
      avatar: Icon(icon, size: 16, color: scheme.primary),
      label: Text(label),
      backgroundColor: scheme.primaryContainer,
      labelStyle: TextStyle(color: scheme.onPrimaryContainer),
    );
  }
}

class _IngredientTable extends StatelessWidget {
  final List<Ingredient> ingredients;
  const _IngredientTable({required this.ingredients});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outline.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: List.generate(ingredients.length, (i) {
          final ing = ingredients[i];
          final isOdd = i.isOdd;
          return Container(
            color: isOdd
                ? scheme.surfaceContainerHighest.withValues(alpha: 0.4)
                : Colors.transparent,
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 6),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    ing.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  ing.measure,
                  style: TextStyle(
                      color: scheme.onSurface.withValues(alpha: 0.65)),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
