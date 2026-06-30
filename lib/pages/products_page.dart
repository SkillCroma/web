// Packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Models
import 'package:skillcroma/models/product_models.dart';

// Widgets
import 'package:skillcroma/widgets/app_bar.dart';
import 'package:skillcroma/widgets/footer.dart';
import 'package:skillcroma/widgets/reusable_dialog.dart';
import 'package:skillcroma/widgets/skeleton_product_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skillcroma/values.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ScrollController _scrollController = ScrollController();
  
  bool _isLoading = true;
  CatalogData? _catalogData;

  // Filters State
  String _searchQuery = '';
  int? _selectedCategoryId;
  final Set<String> _selectedAttributeValues = {}; // e.g., "Red", "Size 5"

  // Pagination
  int _currentPage = 1;
  final int _itemsPerPage = 20;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Mock loading delay to visualize elegant shimmer animation
      await Future.delayed(const Duration(seconds: 2));
      final String jsonString = await rootBundle.loadString('assets/data/products.json');
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      if (!mounted) return;
      setState(() {
        _catalogData = CatalogData.fromJson(jsonData);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading products: $e");
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToFooter() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  void _resetPagination() {
    _currentPage = 1;
  }

  List<Product> _getFilteredProducts() {
    if (_catalogData == null) return [];
    
    return _catalogData!.products.where((product) {
      if (!product.isVisible) return false;

      // Category filter
      if (_selectedCategoryId != null && product.categoryId != _selectedCategoryId) {
        return false;
      }

      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!product.title.toLowerCase().contains(query) && 
            !product.description.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Attribute filter
      if (_selectedAttributeValues.isNotEmpty) {
        final productAttrValues = _catalogData!.productAttributeValues
            .where((attr) => attr.productId == product.id)
            .map((attr) => attr.value)
            .toSet();
        
        // Product must have ALL selected attribute values or AT LEAST ONE?
        // Usually it's an OR within the same attribute, but for simplicity let's say it must have ALL.
        // Or better, it must have at least one if we treat it as an OR filter.
        bool hasMatch = false;
        for (var val in _selectedAttributeValues) {
          if (productAttrValues.contains(val)) {
            hasMatch = true;
            break;
          }
        }
        if (!hasMatch) return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isDesktop = size.width > 900;
    
    return Scaffold(
      appBar: NavBar(
        currentPage: PageName.products,
        onContactTapped: _scrollToFooter,
      ),
      body: _isLoading
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isDesktop)
                  SizedBox(
                    width: 280,
                    child: _buildSkeletonSidebar(),
                  ),
                Expanded(
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      if (!isDesktop)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.filter_list),
                              label: const Text('Filters'),
                              onPressed: null,
                            ),
                          ),
                        ),
                      SliverToBoxAdapter(
                        child: _buildSkeletonTopBar(),
                      ),
                      _buildSkeletonProductGrid(isDesktop),
                      const SliverToBoxAdapter(
                        child: Footer(),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : _catalogData == null
              ? const Center(child: Text("Failed to load products"))
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isDesktop)
                      SizedBox(
                        width: 280,
                        child: _buildSidebar(),
                      ),
                    Expanded(
                      child: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          if (!isDesktop)
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.filter_list),
                                  label: const Text('Filters'),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) => DraggableScrollableSheet(
                                        initialChildSize: 0.8,
                                        minChildSize: 0.5,
                                        maxChildSize: 0.9,
                                        expand: false,
                                        builder: (_, controller) => SingleChildScrollView(
                                          controller: controller,
                                          child: _buildSidebar(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          SliverToBoxAdapter(
                            child: _buildTopBar(),
                          ),
                          _buildProductGrid(isDesktop),
                          SliverToBoxAdapter(
                            child: _buildPagination(),
                          ),
                          const SliverToBoxAdapter(
                            child: Footer(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildSidebar() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSidebarHeader(),
          const SizedBox(height: 16),
          CollapsibleFilterSection(
            title: "Sports Categories",
            isInitiallyExpanded: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _catalogData!.categories.map((cat) => _buildCategoryItem(cat)).toList(),
            ),
          ),
          _buildAttributeSection(),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader() {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    bool hasActiveFilters = _selectedCategoryId != null || _selectedAttributeValues.isNotEmpty;

    return Row(
      children: [
        Text(
          "Filters",
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        if (hasActiveFilters)
          TextButton.icon(
            icon: const Icon(Icons.clear_all, size: 16),
            label: const Text("Clear All", style: TextStyle(fontSize: 12)),
            onPressed: () {
              setState(() {
                _selectedCategoryId = null;
                _selectedAttributeValues.clear();
                _resetPagination();
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.error,
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryItem(Category category) {
    bool isSelected = _selectedCategoryId == category.id;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    int count = _getProductCountForCategory(category.id);

    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedCategoryId = null;
          } else {
            _selectedCategoryId = category.id;
          }
          _resetPagination();
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                category.name,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected 
                    ? colorScheme.primaryContainer 
                    : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getProductCountForCategory(int categoryId) {
    if (_catalogData == null) return 0;
    return _catalogData!.products.where((p) => p.categoryId == categoryId && p.isVisible).length;
  }

  int _getProductCountForAttribute(String value) {
    if (_catalogData == null) return 0;
    final productIds = _catalogData!.productAttributeValues
        .where((v) => v.value == value)
        .map((v) => v.productId)
        .toSet();
    return _catalogData!.products.where((p) => productIds.contains(p.id) && p.isVisible).length;
  }

  Widget _buildAttributeSection() {
    List<String> colors = [];
    List<String> sizes = [];
    List<String> materials = [];
    List<String> skillLevels = [];

    for (var attrVal in _catalogData!.productAttributeValues) {
      final attr = _catalogData!.attributes.firstWhere((a) => a.id == attrVal.attributeId);
      final slug = attr.slug.toLowerCase();
      if (slug.contains('color')) {
        if (!colors.contains(attrVal.value)) colors.add(attrVal.value);
      } else if (slug.contains('size') || slug.contains('variant')) {
        if (!sizes.contains(attrVal.value)) sizes.add(attrVal.value);
      } else if (slug.contains('material')) {
        if (!materials.contains(attrVal.value)) materials.add(attrVal.value);
      } else if (slug.contains('skill')) {
        if (!skillLevels.contains(attrVal.value)) skillLevels.add(attrVal.value);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (skillLevels.isNotEmpty)
          CollapsibleFilterSection(
            title: "Skill Level",
            isInitiallyExpanded: true,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skillLevels.map((s) => _buildAttributeChip(s)).toList(),
            ),
          ),
        if (colors.isNotEmpty)
          CollapsibleFilterSection(
            title: "Color",
            isInitiallyExpanded: false,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: colors.map((c) => _buildAttributeChip(c)).toList(),
            ),
          ),
        if (sizes.isNotEmpty)
          CollapsibleFilterSection(
            title: "Size / Variant",
            isInitiallyExpanded: false,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: sizes.map((s) => _buildAttributeChip(s)).toList(),
            ),
          ),
        if (materials.isNotEmpty)
          CollapsibleFilterSection(
            title: "Material",
            isInitiallyExpanded: false,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: materials.map((m) => _buildAttributeChip(m)).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildAttributeChip(String value) {
    bool isSelected = _selectedAttributeValues.contains(value);
    int count = _getProductCountForAttribute(value);
    var colorScheme = Theme.of(context).colorScheme;

    return FilterChip(
      label: Text(value, style: const TextStyle(fontSize: 12)),
      avatar: CircleAvatar(
        backgroundColor: isSelected ? colorScheme.onPrimary : colorScheme.surfaceContainerHighest,
        child: Text(
          '$count',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            _selectedAttributeValues.add(value);
          } else {
            _selectedAttributeValues.remove(value);
          }
          _resetPagination();
        });
      },
    );
  }

  Widget _buildTopBar() {
    var colorScheme = Theme.of(context).colorScheme;
    var filteredProducts = _getFilteredProducts();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
                _resetPagination();
              });
            },
          ),
          const SizedBox(height: 16),
          
          // Active Filters
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (_selectedCategoryId != null)
                Chip(
                  label: Text(_catalogData!.categories.firstWhere((c) => c.id == _selectedCategoryId).name),
                  onDeleted: () {
                    setState(() {
                      _selectedCategoryId = null;
                      _resetPagination();
                    });
                  },
                ),

              ..._selectedAttributeValues.map((val) => Chip(
                label: Text(val),
                onDeleted: () {
                  setState(() {
                    _selectedAttributeValues.remove(val);
                    _resetPagination();
                  });
                },
              )),
            ],
          ),
          
          if (_selectedCategoryId != null || _selectedAttributeValues.isNotEmpty)
            const SizedBox(height: 16),
          
          // Results Count
          Text(
            "Showing ${filteredProducts.isEmpty ? 0 : (_currentPage - 1) * _itemsPerPage + 1}-${(_currentPage * _itemsPerPage).clamp(0, filteredProducts.length)} of ${filteredProducts.length} products",
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(bool isDesktop) {
    var filteredProducts = _getFilteredProducts();
    
    int startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    if (endIndex > filteredProducts.length) {
      endIndex = filteredProducts.length;
    }
    
    var displayProducts = startIndex < filteredProducts.length 
        ? filteredProducts.sublist(startIndex, endIndex)
        : <Product>[];

    if (displayProducts.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search_off, size: 64, color: Theme.of(context).colorScheme.outline),
                const SizedBox(height: 16),
                const Text("No products found matching your criteria", style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isDesktop ? 4 : 2,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          childAspectRatio: isDesktop ? 0.72 : 0.65,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return _buildProductCard(displayProducts[index]);
          },
          childCount: displayProducts.length,
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    // Get primary image
    String imageUrl = 'https://via.placeholder.com/400';
    try {
      final media = _catalogData!.productMedia.firstWhere(
        (m) => m.productId == product.id && m.isPrimary,
        orElse: () => _catalogData!.productMedia.firstWhere((m) => m.productId == product.id)
      );
      imageUrl = media.filePath;
    } catch (e) {
      // Fallback to placeholder
    }

    // Get Skill Level (attributeId: 4)
    String skillLevel = '';
    try {
      skillLevel = _catalogData!.productAttributeValues.firstWhere(
        (v) => v.productId == product.id && v.attributeId == 4
      ).value;
    } catch (e) {
      // Not found
    }

    // Get Brand Name
    String brandName = '';
    if (product.brandId != null) {
      try {
        brandName = _catalogData!.brands.firstWhere((b) => b.id == product.brandId).name;
      } catch (e) {
        // Fallback
      }
    }

    // Specs (Size, Color, Material)
    final specs = _catalogData!.productAttributeValues
        .where((v) => v.productId == product.id && v.attributeId != 4)
        .toList();

    return HoverProductCard(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image (Media Canvas) with absolute Tag overlay
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: colorScheme.surfaceContainerHighest,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => 
                        Icon(Icons.image_not_supported, size: 48, color: colorScheme.outline),
                    ),
                  ),
                  if (skillLevel.isNotEmpty)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          skillLevel,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Content
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (brandName.isNotEmpty) ...[
                      Text(
                        brandName.toUpperCase(),
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    Text(
                      product.title,
                      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.description,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (specs.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: specs.map((spec) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              spec.value,
                              style: textTheme.bodySmall?.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => _showProductDetailsDialog(context, product),
                          child: const Text('View Details', style: TextStyle(fontSize: 12)),
                        ),
                        const SizedBox(width: 4),
                        FilledButton(
                          onPressed: () => _showConfirmPurchaseDialog(context, product),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Buy Now', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showProductDetailsDialog(BuildContext context, Product product) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    String brandName = 'SkillCroma';
    if (product.brandId != null) {
      try {
        brandName = _catalogData!.brands.firstWhere((b) => b.id == product.brandId).name;
      } catch (e) {
        // Fallback
      }
    }

    final specs = _catalogData!.productAttributeValues
        .where((v) => v.productId == product.id)
        .toList();

    showDialog(
      context: context,
      builder: (context) => ReusableDialog(
        title: product.title,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (brandName.isNotEmpty) ...[
              Text(
                brandName.toUpperCase(),
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              product.description,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            if (specs.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Specifications:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...specs.map((spec) {
                String attrName = 'Attribute';
                try {
                  attrName = _catalogData!.attributes.firstWhere((a) => a.id == spec.attributeId).name;
                } catch (e) {
                  // Fallback
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Text(
                        '$attrName: ',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(spec.value),
                    ],
                  ),
                );
              }),
            ],
            const SizedBox(height: 16),
            Text(
              'Price: \$${product.price.toStringAsFixed(2)}',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showConfirmPurchaseDialog(context, product);
            },
            child: const Text('Buy Now'),
          ),
        ],
      ),
    );
  }

  void _showConfirmPurchaseDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => ReusableDialog(
        title: 'Confirm Purchase',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Would you like to buy ${product.title}?'),
            const SizedBox(height: 12),
            Text(
              'Price: \$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Successfully bought ${product.title}!'),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    var filteredProducts = _getFilteredProducts();
    int totalPages = (filteredProducts.length / _itemsPerPage).ceil();

    if (totalPages <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _currentPage > 1
                ? () {
                    setState(() {
                      _currentPage--;
                      _scrollToTop();
                    });
                  }
                : null,
          ),
          const SizedBox(width: 16),
          ...List.generate(totalPages, (index) {
            int page = index + 1;
            bool isSelected = page == _currentPage;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ChoiceChip(
                label: Text(page.toString()),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _currentPage = page;
                    _scrollToTop();
                  });
                },
              ),
            );
          }),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _currentPage < totalPages
                ? () {
                    setState(() {
                      _currentPage++;
                      _scrollToTop();
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildSkeletonSidebar() {
    var colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Shimmer.fromColors(
        baseColor: colorScheme.surfaceContainerHighest,
        highlightColor: colorScheme.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 120, height: 24, color: Colors.white),
            const SizedBox(height: 16),
            ...List.generate(5, (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(width: double.infinity, height: 16, color: Colors.white),
            )),
            const Divider(height: 48),
            Container(width: 120, height: 24, color: Colors.white),
            const SizedBox(height: 16),
            ...List.generate(3, (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(width: 100, height: 32, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonTopBar() {
    var colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            enabled: false,
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSkeletonProductGrid(bool isDesktop) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isDesktop ? 4 : 2,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          childAspectRatio: isDesktop ? 0.72 : 0.65,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => const SkeletonProductCard(),
          childCount: 20,
        ),
      ),
    );
  }
}

class HoverProductCard extends StatefulWidget {
  final Widget child;
  const HoverProductCard({super.key, required this.child});

  @override
  State<HoverProductCard> createState() => _HoverProductCardState();
}

class _HoverProductCardState extends State<HoverProductCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.only(top: _isHovered ? 0 : 6, bottom: _isHovered ? 6 : 0),
        child: AnimatedScale(
          scale: _isHovered ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: _isHovered ? 0.15 : 0.0),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class CollapsibleFilterSection extends StatefulWidget {
  final String title;
  final Widget child;
  final bool isInitiallyExpanded;

  const CollapsibleFilterSection({
    super.key,
    required this.title,
    required this.child,
    this.isInitiallyExpanded = true,
  });

  @override
  State<CollapsibleFilterSection> createState() => _CollapsibleFilterSectionState();
}

class _CollapsibleFilterSectionState extends State<CollapsibleFilterSection> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isInitiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _isExpanded ? 0.0 : 0.5,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
            child: widget.child,
          ),
          secondChild: const SizedBox.shrink(),
          crossFadeState: _isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 200),
        ),
        const Divider(height: 24, thickness: 0.5),
      ],
    );
  }
}
