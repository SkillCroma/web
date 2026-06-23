import 'package:flutter/material.dart';

class SearchFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onFilterTap;
  final String searchHint;
  final bool isLoading;

  const SearchFilterBar({
    super.key,
    required this.searchController,
    required this.onFilterTap,
    this.searchHint = 'Search...',
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: _buildSearchBar(context, colorScheme),
        ),
        const SizedBox(width: 16),
        FilledButton.tonal(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: isLoading ? null : onFilterTap,
          child: const Icon(Icons.tune_rounded),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context, ColorScheme colorScheme) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: searchHint,
        prefixIcon: Icon(Icons.search_rounded, color: colorScheme.onSurfaceVariant),
        filled: true,
        fillColor: colorScheme.surfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    );
  }
}

class FilterDialog<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final T selectedItem;
  final Widget Function(T) itemLabelBuilder;
  final VoidCallback onClear;
  final ValueChanged<T> onApply;
  final String allLabel;

  const FilterDialog({
    super.key,
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.itemLabelBuilder,
    required this.onClear,
    required this.onApply,
    this.allLabel = 'All',
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    T? tempSelected = selectedItem;

    return StatefulBuilder(
      builder: (context, setStateOverlay) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
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
                  children: items.map((item) {
                    final isSelected = tempSelected == item;
                    return ChoiceChip(
                      label: itemLabelBuilder(item),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setStateOverlay(() {
                            tempSelected = item;
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
                        onClear();
                        Navigator.pop(context);
                      },
                      child: const Text("Clear"),
                    ),
                    const SizedBox(width: 16),
                    FilledButton(
                      onPressed: () {
                        if (tempSelected != null) {
                          onApply(tempSelected as T);
                        }
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
  }
}
