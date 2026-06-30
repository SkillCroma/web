import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Models
import 'package:skillcroma/models/athlete.dart';

// Widgets
import 'package:skillcroma/widgets/leaderboard/athlete_row.dart';
import 'package:skillcroma/widgets/leaderboard/skeleton_leaderboard.dart';
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
  final List<String> _sports = ['All Sports'];
  
  String _searchQuery = '';
  String _selectedLocation = 'All States';
  String _selectedSport = 'All Sports';
  final TextEditingController _searchController = TextEditingController();
  
  static const int _pageSize = 20;
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
    _applyFilters(showFeedback: false);
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

        // Extract unique locations and sports
        final Set<String> uniqueLocations = _allAthletes.map((a) => a.state).toSet();
        _locations.addAll(uniqueLocations.toList()..sort());

        final Set<String> uniqueSports = _allAthletes.map((a) => a.sport).toSet();
        _sports.addAll(uniqueSports.toList()..sort());

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
                            athlete.sport.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesLocation = _selectedLocation == 'All States' || athlete.state == _selectedLocation;
      final matchesSport = _selectedSport == 'All Sports' || athlete.sport == _selectedSport;
      return matchesSearch && matchesLocation && matchesSport;
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
        // Name Search & Autocomplete Region Filter Input
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 700;
            return Flex(
              direction: isDesktop ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: isDesktop ? CrossAxisAlignment.center : CrossAxisAlignment.stretch,
              children: [
                // Name Search
                Expanded(
                  flex: isDesktop ? 3 : 0,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search athletes by name...',
                      prefixIcon: Icon(Icons.search_rounded, color: colorScheme.onSurfaceVariant),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    ),
                  ),
                ),
                SizedBox(width: isDesktop ? 16 : 0, height: isDesktop ? 0 : 16),
                // Region Autocomplete Form Select
                Expanded(
                  flex: isDesktop ? 2 : 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Autocomplete<String>(
                      initialValue: TextEditingValue(
                        text: _selectedLocation == 'All States' ? '' : _selectedLocation,
                      ),
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return _locations.where((l) => l != 'All States');
                        }
                        return _locations.where((String option) {
                          return option.toLowerCase().contains(textEditingValue.text.toLowerCase()) && option != 'All States';
                        });
                      },
                      onSelected: (String selection) {
                        setState(() {
                          _selectedLocation = selection;
                          _applyFilters(showFeedback: false);
                        });
                      },
                      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                        if (_selectedLocation == 'All States' && textEditingController.text.isNotEmpty) {
                          textEditingController.clear();
                        }
                        return TextFormField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            hintText: 'Search Region / State...',
                            prefixIcon: Icon(Icons.location_on_rounded, color: colorScheme.onSurfaceVariant),
                            suffixIcon: _selectedLocation != 'All States'
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded),
                                    onPressed: () {
                                      textEditingController.clear();
                                      setState(() {
                                        _selectedLocation = 'All States';
                                        _applyFilters(showFeedback: false);
                                      });
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                          ),
                        );
                      },
                      optionsViewBuilder: (context, onSelected, options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(12),
                            color: colorScheme.surface,
                            child: Container(
                              width: 300,
                              constraints: const BoxConstraints(maxHeight: 250),
                              decoration: BoxDecoration(
                                border: Border.all(color: colorScheme.outlineVariant),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: options.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final String option = options.elementAt(index);
                                  return InkWell(
                                    onTap: () => onSelected(option),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                      child: Text(
                                        option,
                                        style: textTheme.bodyMedium,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),

        // Active Filters chips & Reset All
        if (_selectedLocation != 'All States' || _selectedSport != 'All Sports' || _searchQuery.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Active Filters:',
                style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurfaceVariant),
              ),
              if (_searchQuery.isNotEmpty)
                InputChip(
                  label: Text('Search: "$_searchQuery"'),
                  onDeleted: () {
                    _searchController.clear();
                  },
                ),
              if (_selectedLocation != 'All States')
                InputChip(
                  label: Text('Region: $_selectedLocation'),
                  onDeleted: () {
                    setState(() {
                      _selectedLocation = 'All States';
                      _applyFilters(showFeedback: false);
                    });
                  },
                ),
              if (_selectedSport != 'All Sports')
                InputChip(
                  label: Text('Sport: $_selectedSport'),
                  onDeleted: () {
                    setState(() {
                      _selectedSport = 'All Sports';
                      _applyFilters(showFeedback: false);
                    });
                  },
                ),
              TextButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _selectedLocation = 'All States';
                    _selectedSport = 'All Sports';
                    _applyFilters(showFeedback: false);
                  });
                },
                child: const Text('Reset All', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],

        // Organized Sports Filtering Chips
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
              child: Row(
                children: [
                  Icon(Icons.sports_basketball_rounded, size: 16, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Filter by Sport Domain',
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurfaceVariant,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: _sports.map((sport) {
                  final isSelected = _selectedSport == sport;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(sport),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedSport = selected ? sport : 'All Sports';
                          _applyFilters(showFeedback: false);
                        });
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      selectedColor: colorScheme.primaryContainer,
                      checkmarkColor: colorScheme.onPrimaryContainer,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Matched counts info
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Text(
            'Found ${_filteredAthletes.length} athlete${_filteredAthletes.length == 1 ? '' : 's'} matching your filters',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),

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
              "Try adjusting your search filters.",
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
        width: 1000,
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
                  _buildTableHeader('Age / Gender', 2, textTheme, colorScheme),
                  _buildTableHeader('Sport', 2, textTheme, colorScheme),
                  _buildTableHeader('Credit Points', 1, textTheme, colorScheme),
                  _buildTableHeader('State / Region', 2, textTheme, colorScheme),
                ],
              ),
            ),
            Divider(color: colorScheme.outlineVariant, height: 1),
            const SizedBox(height: 16),

            // Athletes
            ...List.generate(_currentPageAthletes.length, (index) {
              final athlete = _currentPageAthletes[index];
              final relativeRank = _filteredAthletes.indexOf(athlete) + 1;
              return AthleteRow(
                athlete: athlete,
                displayRank: relativeRank,
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
