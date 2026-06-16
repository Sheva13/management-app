import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';

class PlatformSelector extends StatefulWidget {
  final String? selectedPlatformId;
  final String? selectedPlatformName;
  final List<Map<String, dynamic>> platforms;
  final ValueChanged<String?> onPlatformSelected;
  final String hintText;

  const PlatformSelector({
    super.key,
    this.selectedPlatformId,
    this.selectedPlatformName,
    required this.platforms,
    required this.onPlatformSelected,
    this.hintText = 'Pilih platform...',
  });

  @override
  State<PlatformSelector> createState() => _PlatformSelectorState();
}

class _PlatformSelectorState extends State<PlatformSelector> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Map<String, dynamic>> _filteredPlatforms = [];
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _filteredPlatforms = widget.platforms;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _filterPlatforms(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredPlatforms = widget.platforms;
      } else {
        _filteredPlatforms = widget.platforms
            .where((p) =>
                p['name'].toString().toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Platform',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            setState(() {
              _isOpen = !_isOpen;
            });
            if (_isOpen) {
              _focusNode.requestFocus();
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMd,
              vertical: AppSizes.paddingSm + 4,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(AppSizes.textFieldRadius),
              border: Border.all(
                color: _isOpen ? AppColors.greenPrimary : AppColors.border,
                width: _isOpen ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                if (widget.selectedPlatformName != null) ...[
                  Icon(
                    _getPlatformIcon(widget.selectedPlatformName!),
                    size: 20,
                    color: AppColors.greenPrimary,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    widget.selectedPlatformName ?? widget.hintText,
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.selectedPlatformName != null
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isOpen) ...[
          const SizedBox(height: 4),
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.textFieldRadius),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    onChanged: _filterPlatforms,
                    decoration: InputDecoration(
                      hintText: 'Cari platform...',
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        size: 20,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                    ),
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 8),
                    itemCount: _filteredPlatforms.length,
                    itemBuilder: (context, index) {
                      final platform = _filteredPlatforms[index];
                      final isSelected =
                          platform['id'] == widget.selectedPlatformId;

                      return InkWell(
                        onTap: () {
                          widget.onPlatformSelected(platform['id']);
                          setState(() {
                            _isOpen = false;
                          });
                          _searchController.clear();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          color: isSelected
                              ? AppColors.greenPrimary.withOpacity(0.1)
                              : null,
                          child: Row(
                            children: [
                              Icon(
                                _getPlatformIcon(platform['name']),
                                size: 20,
                                color: isSelected
                                    ? AppColors.greenPrimary
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  platform['name'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? AppColors.greenPrimary
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  size: 20,
                                  color: AppColors.greenPrimary,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  IconData _getPlatformIcon(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('dana')) return Icons.account_balance_wallet_rounded;
    if (lowerName.contains('ovo')) return Icons.phone_android_rounded;
    if (lowerName.contains('gopay')) return Icons.payment_rounded;
    if (lowerName.contains('shopee')) return Icons.shopping_bag_rounded;
    if (lowerName.contains('bca') ||
        lowerName.contains('mandiri') ||
        lowerName.contains('bri') ||
        lowerName.contains('bni')) {
      return Icons.account_balance_rounded;
    }
    return Icons.credit_card_rounded;
  }
}
