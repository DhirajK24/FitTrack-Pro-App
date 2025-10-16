import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/design_tokens.dart';
import '../../design_system/components/app_button.dart';
import '../../design_system/components/app_card.dart';
import '../../design_system/components/app_input.dart';
import '../../design_system/components/app_navigation.dart';
import '../../design_system/components/app_modal.dart';

class ExerciseLibraryScreen extends StatefulWidget {
  const ExerciseLibraryScreen({super.key});

  @override
  State<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedDifficulty = 'All';
  String _searchQuery = '';

  final List<String> _categories = [
    'All',
    'Chest',
    'Back',
    'Shoulders',
    'Arms',
    'Legs',
    'Core',
    'Cardio',
    'Full Body',
  ];

  final List<String> _difficulties = [
    'All',
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  final List<ExerciseData> _exercises = [
    ExerciseData(
      id: '1',
      name: 'Push-ups',
      category: 'Chest',
      difficulty: 'Beginner',
      imageUrl:
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=200&h=200&fit=crop',
      gifUrl: 'https://media.giphy.com/media/3o7btPCcdNniyf0ArS/giphy.gif',
      description:
          'Classic bodyweight exercise for chest, shoulders, and triceps',
      instructions: [
        'Start in a plank position with hands slightly wider than shoulders',
        'Lower your body until chest nearly touches the floor',
        'Push back up to starting position',
        'Keep core tight throughout the movement',
      ],
      muscles: ['Chest', 'Shoulders', 'Triceps', 'Core'],
    ),
    ExerciseData(
      id: '2',
      name: 'Squats',
      category: 'Legs',
      difficulty: 'Beginner',
      imageUrl:
          'https://images.unsplash.com/photo-1534258936925-c58bed479fcb?w=200&h=200&fit=crop',
      gifUrl: 'https://media.giphy.com/media/3o7btPCcdNniyf0ArS/giphy.gif',
      description:
          'Fundamental lower body exercise targeting quads, glutes, and hamstrings',
      instructions: [
        'Stand with feet shoulder-width apart',
        'Lower your body as if sitting back into a chair',
        'Keep knees behind toes and chest up',
        'Return to starting position by pushing through heels',
      ],
      muscles: ['Quads', 'Glutes', 'Hamstrings', 'Core'],
    ),
    ExerciseData(
      id: '3',
      name: 'Plank',
      category: 'Core',
      difficulty: 'Beginner',
      imageUrl:
          'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=200&h=200&fit=crop',
      gifUrl: 'https://media.giphy.com/media/3o7btPCcdNniyf0ArS/giphy.gif',
      description: 'Isometric exercise for core strength and stability',
      instructions: [
        'Start in a push-up position',
        'Lower to forearms, keeping body in straight line',
        'Hold position while engaging core',
        'Breathe normally throughout',
      ],
      muscles: ['Core', 'Shoulders', 'Glutes'],
    ),
    ExerciseData(
      id: '4',
      name: 'Pull-ups',
      category: 'Back',
      difficulty: 'Intermediate',
      imageUrl:
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=200&h=200&fit=crop',
      gifUrl: 'https://media.giphy.com/media/3o7btPCcdNniyf0ArS/giphy.gif',
      description: 'Upper body pulling exercise for back and biceps',
      instructions: [
        'Hang from pull-up bar with overhand grip',
        'Pull body up until chin clears the bar',
        'Lower with control to full arm extension',
        'Keep core engaged throughout',
      ],
      muscles: ['Lats', 'Rhomboids', 'Biceps', 'Rear Delts'],
    ),
    ExerciseData(
      id: '5',
      name: 'Deadlift',
      category: 'Full Body',
      difficulty: 'Advanced',
      imageUrl:
          'https://images.unsplash.com/photo-1534258936925-c58bed479fcb?w=200&h=200&fit=crop',
      gifUrl: 'https://media.giphy.com/media/3o7btPCcdNniyf0ArS/giphy.gif',
      description: 'Compound movement targeting posterior chain',
      instructions: [
        'Stand with feet hip-width apart, bar over mid-foot',
        'Bend at hips and knees to grip the bar',
        'Keep back straight and chest up',
        'Drive through heels to stand up with the bar',
      ],
      muscles: ['Hamstrings', 'Glutes', 'Erector Spinae', 'Traps'],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredExercises = _getFilteredExercises();

    return Scaffold(
      backgroundColor: DesignTokens.brandDark,
      appBar: AppAppBarWithBack(
        title: 'Exercise Library',
        onBackPressed: () => context.go('/dashboard'),
      ),
      body: Column(
        children: [
          // Search and filters
          _buildSearchAndFilters(),
          // Exercise list
          Expanded(
            child: filteredExercises.isEmpty
                ? _buildEmptyState()
                : _buildExerciseList(filteredExercises),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: AppSpacing.screenPadding,
      child: Column(
        children: [
          // Search bar
          AppSearchInput(
            controller: _searchController,
            hintText: 'Search exercises...',
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: DesignTokens.spacing4),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Category', _selectedCategory, _categories),
                const SizedBox(width: DesignTokens.spacing2),
                _buildFilterChip(
                  'Difficulty',
                  _selectedDifficulty,
                  _difficulties,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String selected, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: DesignTokens.textMuted),
        ),
        const SizedBox(height: DesignTokens.spacing1),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: options.map((option) {
              final isSelected = selected == option;
              return Padding(
                padding: const EdgeInsets.only(right: DesignTokens.spacing2),
                child: AppChip(
                  label: option,
                  isSelected: isSelected,
                  onDeleted: isSelected
                      ? () {
                          setState(() {
                            if (label == 'Category') {
                              _selectedCategory = 'All';
                            } else {
                              _selectedDifficulty = 'All';
                            }
                          });
                        }
                      : null,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseList(List<ExerciseData> exercises) {
    return ListView.builder(
      padding: AppSpacing.screenPadding,
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        return ExerciseCard(
          name: exercise.name,
          category: exercise.category,
          imageUrl: exercise.imageUrl,
          sets: 3,
          reps: 12,
          weight: 0,
          onTap: () => _showExerciseDetails(exercise),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: DesignTokens.textMuted),
          const SizedBox(height: DesignTokens.spacing4),
          Text('No exercises found', style: AppTextStyles.h3),
          const SizedBox(height: DesignTokens.spacing2),
          Text(
            'Try adjusting your search or filters',
            style: AppTextStyles.body.copyWith(color: DesignTokens.textMuted),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignTokens.spacing6),
          AppButton(
            text: 'Clear Filters',
            onPressed: _clearFilters,
            variant: AppButtonVariant.secondary,
          ),
        ],
      ),
    );
  }

  List<ExerciseData> _getFilteredExercises() {
    return _exercises.where((exercise) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          exercise.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          exercise.description.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );

      final matchesCategory =
          _selectedCategory == 'All' || exercise.category == _selectedCategory;

      final matchesDifficulty =
          _selectedDifficulty == 'All' ||
          exercise.difficulty == _selectedDifficulty;

      return matchesSearch && matchesCategory && matchesDifficulty;
    }).toList();
  }

  void _showExerciseDetails(ExerciseData exercise) {
    AppModalBottomSheet.show(
      context: context,
      title: exercise.name,
      height: MediaQuery.of(context).size.height * 0.8,
      child: ExerciseDetailsModal(exercise: exercise),
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = 'All';
      _selectedDifficulty = 'All';
      _searchQuery = '';
      _searchController.clear();
    });
  }
}

class ExerciseDetailsModal extends StatelessWidget {
  const ExerciseDetailsModal({super.key, required this.exercise});

  final ExerciseData exercise;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise image/GIF
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
              image: DecorationImage(
                image: NetworkImage(exercise.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: DesignTokens.spacing4),
          // Exercise info
          Row(
            children: [
              _buildInfoChip(exercise.category),
              const SizedBox(width: DesignTokens.spacing2),
              _buildInfoChip(exercise.difficulty),
            ],
          ),
          const SizedBox(height: DesignTokens.spacing4),
          // Description
          Text('Description', style: AppTextStyles.h4),
          const SizedBox(height: DesignTokens.spacing2),
          Text(exercise.description, style: AppTextStyles.body),
          const SizedBox(height: DesignTokens.spacing4),
          // Instructions
          Text('Instructions', style: AppTextStyles.h4),
          const SizedBox(height: DesignTokens.spacing2),
          ...exercise.instructions.asMap().entries.map((entry) {
            final index = entry.key;
            final instruction = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: DesignTokens.spacing2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: DesignTokens.accent1,
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusFull,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: AppTextStyles.caption.copyWith(
                          color: DesignTokens.brandDark,
                          fontWeight: DesignTokens.semiBold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacing3),
                  Expanded(child: Text(instruction, style: AppTextStyles.body)),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: DesignTokens.spacing4),
          // Muscles worked
          Text('Muscles Worked', style: AppTextStyles.h4),
          const SizedBox(height: DesignTokens.spacing2),
          Wrap(
            spacing: DesignTokens.spacing2,
            runSpacing: DesignTokens.spacing2,
            children: exercise.muscles.map((muscle) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacing3,
                  vertical: DesignTokens.spacing1,
                ),
                decoration: BoxDecoration(
                  color: DesignTokens.accent1.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
                ),
                child: Text(
                  muscle,
                  style: AppTextStyles.caption.copyWith(
                    color: DesignTokens.accent1,
                    fontWeight: DesignTokens.medium,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: DesignTokens.spacing6),
          // Add to workout button
          AppButton(
            text: 'Add to Workout',
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Add to current workout
            },
            size: AppButtonSize.large,
            icon: Icons.add,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacing3,
        vertical: DesignTokens.spacing1,
      ),
      decoration: BoxDecoration(
        color: DesignTokens.surface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
        border: Border.all(color: DesignTokens.border),
      ),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(color: DesignTokens.textLight),
      ),
    );
  }
}

class ExerciseData {
  final String id;
  final String name;
  final String category;
  final String difficulty;
  final String imageUrl;
  final String gifUrl;
  final String description;
  final List<String> instructions;
  final List<String> muscles;

  ExerciseData({
    required this.id,
    required this.name,
    required this.category,
    required this.difficulty,
    required this.imageUrl,
    required this.gifUrl,
    required this.description,
    required this.instructions,
    required this.muscles,
  });
}
