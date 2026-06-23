import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Models
import 'package:skillcroma/models/athlete.dart';

// Widgets
import 'package:skillcroma/widgets/leaderboard/athlete_row.dart';
import 'package:skillcroma/widgets/leaderboard/skeleton_leaderboard.dart';
import 'package:skillcroma/widgets/common/search_filter_bar.dart';
import 'package:skillcroma/widgets/common/pagination_controls.dart';

class LeaderboardContainer extends StatefulWidget {
  const LeaderboardContainer({super.key});

  @override
  State<LeaderboardContainer> createState() => _LeaderboardContainerState();
}

class _LeaderboardContainerState extends State<LeaderboardContainer> {
  List<Athlete> _allAthletes = [];
  List<Athlete> _filteredAthletes = [];
  final List<String> _locations = ['All States'];
  
  String _searchQuery = '';
  String _selectedLocation = 'All States';
  final TextEditingController _searchController = TextEditingController();
  
  static const int _pageSize = 5;
  int _currentPage = 1;
  bool _isLoading = true;
  bool _isFiltering = false;
  String? _errorMessage;

  int get _totalPages => (_filteredAthletes.length / _pageSize).ceil();
  List<Athlete> get _currentPageAthletes {
    final start = (_currentPage - 1) * _pageSize;
    final end = start + _pageSize;
    return _filteredAthletes.sublist(start, end > _filteredAthletes.length ? _filteredAthletes.length : end);
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadAthletes();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
    _applyFilters();
  }

  Future<void> _loadAthletes() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Simulate network delay for skeleton loading
      await Future.delayed(const Duration(milliseconds: 1500));

      final String response = await rootBundle.loadString('assets/data/athletes.json');
      final List<dynamic> data = json.decode(response);
      
      setState(() {
        _allAthletes = data.map((json) => Athlete.fromJson(json as Map<String, dynamic>)).toList();

        // Extract unique locations
        final Set<String> uniqueLocations = _allAthletes.map((a) => a.state).toSet();
        _locations.addAll(uniqueLocations.toList()..sort());

        _applyFilters(showFeedback: false);
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      debugPrint('Error loading athletes: $e');
      debugPrintStack(stackTrace: stackTrace);
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load leaderboard. Please try again.';
      });
      if (mounted) {
        _showSnackBar('Error loading athletes: $e', isError: true);
      }
    }
  }

  void _applyFilters({bool showFeedback = true}) {
    setState(() {
      _isFiltering = true;
    });

    // DSA Optimized Search (simple iteration since dataset is small)
    _filteredAthletes = _allAthletes.where((athlete) {
      final matchesSearch = athlete.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                            athlete.type.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesLocation = _selectedLocation == 'All States' || athlete.state == _selectedLocation;
      return matchesSearch && matchesLocation;
    }).toList();

    // Reset to first page on filter change
    _currentPage = 1;

    setState(() {
      _isFiltering = false;
    });

    // Show feedback
    if (showFeedback && (_searchQuery.isNotEmpty || _selectedLocation != 'All States')) {
      _showSnackBar('Found ${_filteredAthletes.length} athlete${_filteredAthletes.length == 1 ? '' : 's'}');
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateOverlay) {
            final textTheme = Theme.of(context).textTheme;

            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Filter by State",
                            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 8,
                      runSpacing: 12,
                      children: _locations.map((location) {
                        final isSelected = _selectedLocation == location;
                        return ChoiceChip(
                          label: Text(location),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setStateOverlay(() {
                                _selectedLocation = location;
                              });
                            }
                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            setStateOverlay(() {
                              _selectedLocation = 'All States';
                            });
                            setState(() {
                              _selectedLocation = 'All States';
                              _applyFilters();
                            });
                            Navigator.pop(context);
                          },
                          child: const Text("Clear"),
                        ),
                        const SizedBox(width: 16),
                        FilledButton(
                          onPressed: () {
                            setState(() {
                              _applyFilters();
                            });
                            Navigator.pop(context);
                          },
                          child: const Text("Apply Filters"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_rounded : Icons.check_circle_rounded,
              color: isError ? colorScheme.onError : colorScheme.onPrimary,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? colorScheme.error : colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages) {
      setState(() {
        _currentPage++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isLoading
              ? const SkeletonLeaderboard()
              : _errorMessage != null
                  ? _buildErrorWidget(colorScheme, textTheme)
                  : _buildContent(colorScheme, textTheme),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 80,
              color: colorScheme.error,
            ),
            const SizedBox(height: 24),
            Text(
              _errorMessage ?? 'An unexpected error occurred',
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _loadAthletes,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SearchFilterBar(
                searchController: _searchController,
                searchHint: 'Search athletes...',
                isLoading: _isFiltering,
                onFilterTap: _showFilterDialog,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Table or Empty State
        _filteredAthletes.isEmpty
            ? _buildEmptyState(textTheme, colorScheme)
            : _buildTable(textTheme, colorScheme),

        const SizedBox(height: 32),

        // Pagination
        if (_filteredAthletes.isNotEmpty && _totalPages > 1)
          PaginationControls(
            currentPage: _currentPage,
            totalPages: _totalPages,
            isLoading: _isFiltering,
            onPrevious: _previousPage,
            onNext: _nextPage,
            onPageChanged: _goToPage,
          ),
      ],
    );
  }

  Widget _buildEmptyState(TextTheme textTheme, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64.0),
        child: Column(
          children: [
            Icon(Icons.search_off_rounded, size: 80, color: colorScheme.outline),
            const SizedBox(height: 24),
            Text(
              "No athletes found",
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Try adjusting your search or state filter.",
              style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(TextTheme textTheme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 900,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Table Headers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  _buildTableHeader('Rank', 1, textTheme, colorScheme),
                  _buildTableHeader('Name', 3, textTheme, colorScheme),
                  _buildTableHeader('Type', 2, textTheme, colorScheme),
                  _buildTableHeader('Credit', 2, textTheme, colorScheme),
                  _buildTableHeader('State', 2, textTheme, colorScheme),
                ],
              ),
            ),
            Divider(color: colorScheme.outlineVariant, height: 1),
            const SizedBox(height: 16),

            // Athletes
            ...List.generate(_currentPageAthletes.length, (index) {
              return AthleteRow(
                athlete: _currentPageAthletes[index],
                index: index,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(String text, int flex, TextTheme textTheme, ColorScheme colorScheme) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          text,
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
