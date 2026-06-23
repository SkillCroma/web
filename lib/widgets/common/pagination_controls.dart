import 'package:flutter/material.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final ValueChanged<int>? onPageChanged;
  final bool isLoading;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPrevious,
    required this.onNext,
    this.onPageChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: isLoading || currentPage <= 1 ? null : onPrevious,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        const SizedBox(width: 8),
        ..._buildPageIndicators(context, colorScheme),
        const SizedBox(width: 8),
        IconButton(
          onPressed: isLoading || currentPage >= totalPages ? null : onNext,
          icon: const Icon(Icons.arrow_forward_rounded),
        ),
      ],
    );
  }

  List<Widget> _buildPageIndicators(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    final List<Widget> indicators = [];
    const maxVisible = 5;

    // Handle case when totalPages is small
    if (totalPages <= maxVisible) {
      for (int i = 1; i <= totalPages; i++) {
        indicators.add(_buildPageButton(context, colorScheme, i));
      }
      return indicators;
    }

    int start = (currentPage - (maxVisible ~/ 2)).clamp(
      1,
      totalPages - maxVisible + 1,
    );
    int end = (start + maxVisible - 1).clamp(1, totalPages);

    if (start > 1) {
      indicators.add(_buildPageButton(context, colorScheme, 1));
      if (start > 2) {
        indicators.add(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text('...'),
          ),
        );
      }
    }

    for (int i = start; i <= end; i++) {
      indicators.add(_buildPageButton(context, colorScheme, i));
    }

    if (end < totalPages) {
      if (end < totalPages - 1) {
        indicators.add(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text('...'),
          ),
        );
      }
      indicators.add(_buildPageButton(context, colorScheme, totalPages));
    }

    return indicators;
  }

  Widget _buildPageButton(
    BuildContext context,
    ColorScheme colorScheme,
    int page,
  ) {
    final isSelected = page == currentPage;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: isSelected
          ? FilledButton(
              style: FilledButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
              ),
              onPressed: null,
              child: Text(page.toString()),
            )
          : OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
              ),
              onPressed: isLoading
                  ? null
                  : () {
                      if (onPageChanged != null) {
                        onPageChanged!(page);
                      }
                    },
              child: Text(page.toString()),
            ),
    );
  }
}
