// Packages
import 'package:flutter/material.dart';

// Functions
import 'package:skillcroma/functions.dart';

// Values
import 'package:skillcroma/values.dart';

class NavBarLinks extends StatefulWidget {
  const NavBarLinks({
    super.key,
    required this.label,
    required this.page,
    required this.isCurrentPage,
    this.onTap,
  });

  final String label;
  final PageName page;
  final bool isCurrentPage;
  final VoidCallback? onTap;

  @override
  State<NavBarLinks> createState() => _NavBarLinksState();
}

class _NavBarLinksState extends State<NavBarLinks> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: widget.isCurrentPage
                ? colorScheme.surfaceContainer
                : (_isHovering ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5) : Colors.transparent),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap ?? () => navigatePage(context, widget.page),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: AnimatedScale(
                  scale: _isHovering ? 1.05 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: textTheme.titleMedium!.copyWith(
                      color: widget.isCurrentPage
                          ? colorScheme.primary
                          : (_isHovering ? colorScheme.primary : colorScheme.onPrimaryContainer),
                      fontWeight: widget.isCurrentPage || _isHovering ? FontWeight.bold : FontWeight.normal,
                    ),
                    child: Text(widget.label),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
