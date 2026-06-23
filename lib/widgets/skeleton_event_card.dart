import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonEventCard extends StatelessWidget {
  const SkeletonEventCard({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isDesktop = size.width > 800;
    var colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Shimmer.fromColors(
        baseColor: colorScheme.surfaceContainerHighest,
        highlightColor: colorScheme.surface,
        child: isDesktop ? _buildDesktopSkeleton() : _buildMobileSkeleton(),
      ),
    );
  }

  Widget _buildDesktopSkeleton() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: 300,
          height: 240,
          color: Colors.white,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 28,
                  color: Colors.white,
                  margin: const EdgeInsets.only(right: 48), // leave space for menu icon
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 16,
                  color: Colors.white,
                  margin: const EdgeInsets.only(right: 24),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 250,
                  height: 16,
                  color: Colors.white,
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Container(width: 20, height: 20, color: Colors.white),
                    const SizedBox(width: 8),
                    Container(width: 100, height: 16, color: Colors.white),
                    const SizedBox(width: 24),
                    Container(width: 20, height: 20, color: Colors.white),
                    const SizedBox(width: 8),
                    Container(width: 120, height: 16, color: Colors.white),
                    const SizedBox(width: 24),
                    Container(width: 20, height: 20, color: Colors.white),
                    const SizedBox(width: 8),
                    Container(width: 80, height: 16, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
      ),
    );
  }

  Widget _buildMobileSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 200,
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 24,
                color: Colors.white,
                margin: const EdgeInsets.only(right: 48),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 16,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Container(
                width: 200,
                height: 16,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(width: 18, height: 18, color: Colors.white),
                  const SizedBox(width: 8),
                  Container(width: 100, height: 14, color: Colors.white),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(width: 18, height: 18, color: Colors.white),
                  const SizedBox(width: 8),
                  Container(width: 120, height: 14, color: Colors.white),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(width: 18, height: 18, color: Colors.white),
                  const SizedBox(width: 8),
                  Container(width: 80, height: 14, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
