import 'package:flutter/material.dart';
import 'package:vfxmoney/core/constants/app_colors.dart';
import 'package:vfxmoney/shared/widgets/push_button.dart';

class FilterBottomSheet extends StatefulWidget {
  final Function(FilterData)? onApplyFilters;
  final FilterData? initialFilters;

  const FilterBottomSheet({
    super.key,
    this.onApplyFilters,
    this.initialFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  double _distanceValue = 25.0;
  RangeValues _priceRange = const RangeValues(50, 120);
  String? _selectedCategory;
  String? _selectedMaterialType;
  String? _selectedSupplier;

  final List<String> _categories = [
    'Construction Materials',
    'Electrical Supplies',
    'Plumbing',
    'Hardware',
    'Tools & Equipment',
    'Paint & Finishing',
  ];

  final List<String> _materialTypes = [
    'Wood',
    'Steel',
    'Concrete',
    'Brick',
    'Aluminum',
    'Plastic',
    'Glass',
    'Ceramic',
  ];

  final List<String> _suppliers = [
    'Home Depot',
    'Lowe\'s',
    'Menards',
    'Local Supplier A',
    'Local Supplier B',
    'Wholesale Direct',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialFilters != null) {
      _distanceValue = widget.initialFilters!.distance;
      _priceRange = widget.initialFilters!.priceRange;
      _selectedCategory = widget.initialFilters!.category;
      _selectedMaterialType = widget.initialFilters!.materialType;
      _selectedSupplier = widget.initialFilters!.supplier;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: _clearAllFilters,
                  child: const Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Distance Filter
                  _buildDistanceFilter(),
                  const SizedBox(height: 32),

                  // Price Range Filter
                  _buildPriceRangeFilter(),
                  const SizedBox(height: 32),

                  // Category Filter
                  _buildDropdownFilter(
                    title: 'Category',
                    value: _selectedCategory,
                    placeholder: 'Select Material',
                    items: _categories,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Material Type Filter
                  _buildDropdownFilter(
                    title: 'Material Type',
                    value: _selectedMaterialType,
                    placeholder: 'Select Material',
                    items: _materialTypes,
                    onChanged: (value) {
                      setState(() {
                        _selectedMaterialType = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Supplier Filter
                  _buildDropdownFilter(
                    title: 'Supplier',
                    value: _selectedSupplier,
                    placeholder: 'Select Supplier',
                    items: _suppliers,
                    onChanged: (value) {
                      setState(() {
                        _selectedSupplier = value;
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Apply Filters Button
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: AppSubmitButton(
                title: "Apply Filters",
                onTap: _applyFilters,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Distance (Miles)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),

        Container(
          decoration: BoxDecoration(
            color: AppColors.bgGreyColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              // Distance Slider
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Theme.of(context).primaryColor,
                  inactiveTrackColor: Colors.grey[300],
                  thumbColor: Theme.of(context).primaryColor,
                  overlayColor: const Color(0xFF20B2AA).withValues(alpha: 0.2),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 8,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 15,
                  ),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: _distanceValue,
                  min: 0,
                  max: 50,
                  divisions: 50,
                  onChanged: (value) {
                    setState(() {
                      _distanceValue = value;
                    });
                  },
                ),
              ),

              // Distance Labels
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '0 miles',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    Text(
                      '${_distanceValue.round()} miles',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Price Range',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),

        Container(
          decoration: BoxDecoration(
            color: AppColors.bgGreyColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              // Price Range Slider
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Theme.of(context).primaryColor,
                  inactiveTrackColor: Colors.grey[300],
                  thumbColor: Theme.of(context).primaryColor,
                  overlayColor: const Color(0xFF20B2AA).withValues(alpha: 0.2),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 8,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 15,
                  ),
                  trackHeight: 4,
                ),
                child: RangeSlider(
                  values: _priceRange,
                  min: 0,
                  max: 500,
                  divisions: 100,
                  onChanged: (RangeValues values) {
                    setState(() {
                      _priceRange = values;
                    });
                  },
                ),
              ),

              // Price Labels
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${_priceRange.start.round()}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    Text(
                      '\$${_priceRange.end.round()}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownFilter({
    required String title,
    required String? value,
    required String placeholder,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.bgGreyColor,
            //border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                placeholder,
                style: TextStyle(fontSize: 16, color: Colors.grey[500]),
              ),
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  void _clearAllFilters() {
    setState(() {
      _distanceValue = 25.0;
      _priceRange = const RangeValues(50, 120);
      _selectedCategory = null;
      _selectedMaterialType = null;
      _selectedSupplier = null;
    });
  }

  void _applyFilters() {
    final filterData = FilterData(
      distance: _distanceValue,
      priceRange: _priceRange,
      category: _selectedCategory,
      materialType: _selectedMaterialType,
      supplier: _selectedSupplier,
    );

    if (widget.onApplyFilters != null) {
      widget.onApplyFilters!(filterData);
    }

    Navigator.of(context).pop(filterData);
  }
}

// Data class to hold filter values
class FilterData {
  final double distance;
  final RangeValues priceRange;
  final String? category;
  final String? materialType;
  final String? supplier;

  FilterData({
    required this.distance,
    required this.priceRange,
    this.category,
    this.materialType,
    this.supplier,
  });

  @override
  String toString() {
    return 'FilterData(distance: $distance, priceRange: $priceRange, category: $category, materialType: $materialType, supplier: $supplier)';
  }
}

// Helper function to show the filter bottom sheet
Future<FilterData?> showFilterBottomSheet(
  BuildContext context, {
  FilterData? initialFilters,
  Function(FilterData)? onApplyFilters,
}) {
  return showModalBottomSheet<FilterData>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: FilterBottomSheet(
        initialFilters: initialFilters,
        onApplyFilters: onApplyFilters,
      ),
    ),
  );
}
