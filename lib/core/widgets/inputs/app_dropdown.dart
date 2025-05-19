import 'package:flutter/material.dart';
import 'package:base_project2/core/theme/app_colors.dart';

/// A dropdown widget that can be used throughout the application.
/// Supports async loading, search, and custom item builders.
class AppDropdown<T> extends StatefulWidget {
  final String? label;
  final String? hint;
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemText;
  final Widget Function(T)? itemBuilder;
  final bool isSearchable;
  final bool isLoading;
  final String? errorText;
  final Future<List<T>> Function(String)? onSearch;
  final EdgeInsetsGeometry? contentPadding;
  final bool isRequired;

  const AppDropdown({
    Key? key,
    this.label,
    this.hint,
    this.value,
    required this.items,
    required this.onChanged,
    required this.itemText,
    this.itemBuilder,
    this.isSearchable = false,
    this.isLoading = false,
    this.errorText,
    this.onSearch,
    this.contentPadding,
    this.isRequired = false,
  }) : super(key: key);

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  final TextEditingController _searchController = TextEditingController();
  List<T> _filteredItems = [];
  bool _isSearching = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  @override
  void didUpdateWidget(covariant AppDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _filteredItems = widget.items;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onSearch(String query) async {
    if (widget.onSearch != null) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        final results = await widget.onSearch!(query);
        setState(() {
          _filteredItems = results;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _filteredItems = widget.items.where((item) {
          final itemText = widget.itemText(item).toLowerCase();
          return itemText.contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Text(
                  widget.label!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (widget.isRequired)
                  const Text(
                    ' *',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.error,
                    ),
                  ),
              ],
            ),
          ),
        GestureDetector(
          onTap: widget.isLoading
              ? null
              : () {
                  _showDropdownMenu(context);
                },
          child: Container(
            padding: widget.contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.errorText != null
                    ? AppColors.error
                    : AppColors.border,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: AppColors.surface,
            ),
            child: Row(
              children: [
                Expanded(
                  child: widget.value != null
                      ? widget.itemBuilder != null
                          ? widget.itemBuilder!(widget.value as T)
                          : Text(
                              widget.itemText(widget.value as T),
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textPrimary,
                              ),
                            )
                      : Text(
                          widget.hint ?? 'Select an option',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textHint,
                          ),
                        ),
                ),
                if (widget.isLoading)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  )
                else
                  const Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.textSecondary,
                  ),
              ],
            ),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0),
            child: Text(
              widget.errorText!,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.error,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _showDropdownMenu(BuildContext context) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    final T? selectedItem = await showMenu<T>(
      context: context,
      position: position,
      items: [
        if (widget.isSearchable)
          PopupMenuItem<T>(
            enabled: false,
            padding: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  _onSearch(value);
                },
                autofocus: true,
              ),
            ),
          ),
        if (_isLoading)
           PopupMenuItem<T>(
            enabled: false,
            child:const Center(
              child: CircularProgressIndicator(),
            ),
          )
        else if (_filteredItems.isEmpty)
           PopupMenuItem<T>(
            enabled: false,
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No items found'),
              ),
            ),
          )
        else
          ..._filteredItems.map((T item) {
            return PopupMenuItem<T>(
              value: item,
              child: widget.itemBuilder != null
                  ? widget.itemBuilder!(item)
                  : Text(widget.itemText(item)),
            );
          }).toList(),
      ],
    );

    if (selectedItem != null) {
      widget.onChanged(selectedItem);
    }

    // Reset search
    _searchController.clear();
    setState(() {
      _filteredItems = widget.items;
      _isSearching = false;
    });
  }
}
