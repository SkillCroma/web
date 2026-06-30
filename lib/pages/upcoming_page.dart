// Packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Values
import 'package:skillcroma/values.dart';

// Widgets
import 'package:skillcroma/widgets/app_bar.dart';
import 'package:skillcroma/widgets/footer.dart';
import 'package:skillcroma/widgets/event_card.dart';
import 'package:skillcroma/widgets/skeleton_event_card.dart';

// Models
import 'package:skillcroma/models/event.dart';

class UpcomingPage extends StatefulWidget {
  const UpcomingPage({super.key});

  @override
  State<UpcomingPage> createState() => _UpcomingPageState();
}

class _UpcomingPageState extends State<UpcomingPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<Event> _allEvents = [];
  List<Event> _filteredEvents = [];
  final List<String> _states = ['All States'];
  final List<String> _sports = ['All Sports'];

  String _selectedState = 'All States';
  String _selectedSport = 'All Sports';
  String _searchQuery = '';
  int _displayCount = 10;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    try {
      // Intentional delay for skeleton loading visibility
      await Future.delayed(const Duration(seconds: 2));

      final String response = await rootBundle.loadString(
        'assets/data/events.json',
      );
      final List<dynamic> data = json.decode(response);

      if (!mounted) return;
      setState(() {
        _allEvents = data.map((json) => Event.fromJson(json)).toList();

        // Sort by upcoming (closest timestamp first)
        _allEvents.sort((a, b) => a.timestamp.compareTo(b.timestamp));

        // Extract unique states and sports
        final Set<String> uniqueStates = _allEvents
            .map((e) => e.state)
            .toSet();
        _states.addAll(uniqueStates.toList()..sort());

        final Set<String> uniqueSports = _allEvents
            .map((e) => e.sport)
            .toSet();
        _sports.addAll(uniqueSports.toList()..sort());

        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      debugPrint("Error loading events: $e");
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredEvents = _allEvents.where((event) {
        final matchesSearch =
            event.title.toLowerCase().contains(_searchQuery) ||
            event.description.toLowerCase().contains(_searchQuery);
        final matchesState =
            _selectedState == 'All States' ||
            event.state == _selectedState;
        final matchesSport =
            _selectedSport == 'All Sports' ||
            event.sport == _selectedSport;
        return matchesSearch && matchesState && matchesSport;
      }).toList();
      _displayCount = 10; // Reset display count on filter change
    });
  }

  void _loadMore() {
    setState(() {
      _displayCount += 10;
    });
  }

  void _scrollToFooter() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isDesktop = size.width > 800;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: NavBar(
        currentPage: PageName.upcoming,
        onContactTapped: _scrollToFooter,
      ),
      body: ListView(
        controller: _scrollController,
        children: [
          ClipRect(
            child: Stack(
              children: [
                AnimatedBuilder(
                  animation: _scrollController,
                  builder: (context, child) {
                    double offset = _scrollController.hasClients ? _scrollController.offset : 0;
                    return Transform.translate(
                      offset: Offset(0, offset * 0.5),
                      child: child,
                    );
                  },
                  child: Image.asset(
                    'assets/common/About_Image_1.png',
                    width: size.width,
                    fit: BoxFit.cover,
                    height: 300,
                  ),
                ),
                Container(
                  height: 300,
                  width: size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [colorScheme.surface, Colors.transparent],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 24,
                  left: isDesktop ? 80 : 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Upcoming Events",
                        style: textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Discover and register for the latest sports events and competitions.",
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 80 : 24,
              vertical: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),

                // Search and Filter Bar
                _buildFilterBar(context, colorScheme),

                const SizedBox(height: 48),

                // Content
                _isLoading
                    ? _buildSkeletonList()
                    : _filteredEvents.isEmpty
                    ? _buildEmptyState(textTheme, colorScheme)
                    : _buildEventList(),
              ],
            ),
          ),
          const Footer(),
        ],
      ),
    );
  }

  Widget _buildSkeletonList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4, // Show 4 skeletons
      separatorBuilder: (context, index) => const SizedBox(height: 24),
      itemBuilder: (context, index) {
        return const SkeletonEventCard();
      },
    );
  }

  Widget _buildFilterBar(BuildContext context, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(child: _buildSearchBar(colorScheme)),
        const SizedBox(width: 16),
        FilledButton.tonal(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () => _showFilterOverlay(context),
          child: const Icon(Icons.tune_rounded),
        ),
      ],
    );
  }

  void _showFilterOverlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateOverlay) {
            var textTheme = Theme.of(context).textTheme;

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Filter by State & Sport",
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text("State", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 12,
                      children: _states.map((state) {
                        final isSelected = _selectedState == state;
                        return ChoiceChip(
                          label: Text(state),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setStateOverlay(() {
                                _selectedState = state;
                              });
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    Text("Sport", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 12,
                      children: _sports.map((sport) {
                        final isSelected = _selectedSport == sport;
                        return ChoiceChip(
                          label: Text(sport),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setStateOverlay(() {
                                _selectedSport = sport;
                              });
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
                              _selectedState = 'All States';
                              _selectedSport = 'All Sports';
                            });
                            setState(() {
                              _selectedState = 'All States';
                              _selectedSport = 'All Sports';
                              _applyFilters();
                            });
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

  Widget _buildSearchBar(ColorScheme colorScheme) {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        _searchQuery = value.toLowerCase();
        _applyFilters();
      },
      decoration: InputDecoration(
        hintText: 'Search events by name...',
        prefixIcon: Icon(
          Icons.search_rounded,
          color: colorScheme.onSurfaceVariant,
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildEventList() {
    final displayEvents = _filteredEvents.take(_displayCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayEvents.length,
          separatorBuilder: (context, index) => const SizedBox(height: 32),
          itemBuilder: (context, index) {
            return EventCard(event: displayEvents[index]);
          },
        ),
        if (_displayCount < _filteredEvents.length) ...[
          const SizedBox(height: 48),
          Center(
            child: FilledButton.tonalIcon(
              onPressed: _loadMore,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              label: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Text("Load More Events"),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEmptyState(TextTheme textTheme, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64.0),
        child: Column(
          children: [
            Icon(Icons.search_rounded, size: 80, color: colorScheme.outline),
            const SizedBox(height: 24),
            Text(
              "No events found",
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Try adjusting your search, state or sport filter.",
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
