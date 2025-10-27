import 'package:flutter/material.dart';

/// =====================
/// CONFIG CLASSES
/// =====================

class TableColumnConfig<T> {
  final String key;
  final String label;
  final bool filterable;
  final bool sortable;
  final double? width;
  final String Function(T item) valueGetter;
  final Widget Function(T item)? cellBuilder;

  TableColumnConfig({
    required this.key,
    required this.label,
    required this.valueGetter,
    this.filterable = true,
    this.sortable = true,
    this.width,
    this.cellBuilder,
  });
}

class DateColumnConfig<T> {
  final String key;
  final String label;
  final DateTime? Function(T item) dateGetter;

  DateColumnConfig({
    required this.key,
    required this.label,
    required this.dateGetter,
  });
}

class RowAction<T> {
  final IconData icon;
  final String tooltip;
  final Color color;
  final void Function(T item) onPressed;

  RowAction({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onPressed,
  });
}

/// =====================
/// MAIN WIDGET
/// =====================

class DataTableManager<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final List<TableColumnConfig<T>> columns;
  final DateColumnConfig<T>? dateColumn;
  final List<RowAction<T>> rowActions;
  final List<Widget> Function()? headerActions;
  final bool Function(T item, String query) searchFilter;
  final bool isLoading;
  final VoidCallback? onRefresh;
  final Future<void> Function(BuildContext context, T? item)? onEditItem;

  const DataTableManager({
    super.key,
    required this.title,
    required this.items,
    required this.columns,
    required this.searchFilter,
    required this.rowActions,
    this.dateColumn,
    this.headerActions,
    this.isLoading = false,
    this.onRefresh,
    this.onEditItem,
  });

  @override
  State<DataTableManager<T>> createState() => _DataTableManagerState<T>();
}

class _DataTableManagerState<T> extends State<DataTableManager<T>> {
  List<T> filteredItems = [];
  final TextEditingController searchController = TextEditingController();

  Map<String, Set<String>> columnFilters = {};
  Map<String, Set<String>> availableValues = {};

  DateTime? filterFromDate;
  DateTime? filterToDate;

  String? sortColumnKey;
  bool sortAscending = true;

  @override
  void initState() {
    super.initState();
    _initializeFilters();
    filteredItems = widget.items;
    _extractAvailableValues();
    searchController.addListener(_applyFilters);
  }

  @override
  void didUpdateWidget(DataTableManager<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _extractAvailableValues();
      _applyFilters();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _initializeFilters() {
    for (var column in widget.columns.where((c) => c.filterable)) {
      columnFilters[column.key] = {};
      availableValues[column.key] = {};
    }
  }

  void _extractAvailableValues() {
    for (var column in widget.columns.where((c) => c.filterable)) {
      availableValues[column.key] = widget.items
          .map((item) => column.valueGetter(item))
          .toSet();
    }
  }

  void _applyFilters() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredItems = widget.items.where((item) {
        final matchesSearch = query.isEmpty || widget.searchFilter(item, query);

        bool matchesColumnFilters = true;
        for (var column in widget.columns.where((c) => c.filterable)) {
          final filterSet = columnFilters[column.key]!;
          if (filterSet.isNotEmpty &&
              !filterSet.contains(column.valueGetter(item))) {
            matchesColumnFilters = false;
            break;
          }
        }

        bool matchesDateRange = true;
        if (widget.dateColumn != null) {
          final date = widget.dateColumn!.dateGetter(item);
          if (date != null) {
            matchesDateRange =
                (filterFromDate == null ||
                    date.isAfter(
                      filterFromDate!.subtract(const Duration(days: 1)),
                    )) &&
                (filterToDate == null ||
                    date.isBefore(filterToDate!.add(const Duration(days: 1))));
          }
        }

        return matchesSearch && matchesColumnFilters && matchesDateRange;
      }).toList();

      if (sortColumnKey != null) _sortData();
    });
  }

  void _sortData() {
    final column = widget.columns.firstWhere((c) => c.key == sortColumnKey);
    filteredItems.sort((a, b) {
      final aValue = column.valueGetter(a);
      final bValue = column.valueGetter(b);
      final comparison = aValue.compareTo(bValue);
      return sortAscending ? comparison : -comparison;
    });
  }

  void _onSort(String key) {
    setState(() {
      if (sortColumnKey == key) {
        sortAscending = !sortAscending;
      } else {
        sortColumnKey = key;
        sortAscending = true;
      }
      _sortData();
    });
  }

  /// =====================
  /// UI BUILDERS
  /// =====================

  Widget _buildActionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _showAddDialog() async {
    if (widget.onEditItem != null) {
      await widget.onEditItem!(context, null);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chức năng thêm mới đang phát triển')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(
                width: 500,
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ACTION BUTTONS
          Row(
            children: [
              _buildActionButton(
                Icons.file_upload,
                'Import Excel',
                Colors.green,
                () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chức năng import Excel đang phát triển'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                Icons.file_download,
                'Export Excel',
                Colors.blue,
                () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chức năng export Excel đang phát triển'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                Icons.add,
                'Thêm mới',
                Colors.blue[700]!,
                _showAddDialog,
              ),
              if (widget.headerActions != null) ...[
                const SizedBox(width: 8),
                Row(children: widget.headerActions!()),
              ],
            ],
          ),

          const SizedBox(height: 20),

          // TABLE CONTENT
          Expanded(
            child: widget.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredItems.isEmpty
                ? const Center(child: Text('Không có dữ liệu'))
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(
                        Colors.blue[50],
                      ),
                      columns: [
                        const DataColumn(label: Text('STT')),
                        ...widget.columns.map(
                          (column) => DataColumn(
                            label: InkWell(
                              onTap: column.sortable
                                  ? () => _onSort(column.key)
                                  : null,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(column.label),
                                  if (column.sortable)
                                    Icon(
                                      sortColumnKey == column.key
                                          ? (sortAscending
                                                ? Icons.arrow_upward
                                                : Icons.arrow_downward)
                                          : Icons.unfold_more,
                                      size: 16,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (widget.rowActions.isNotEmpty)
                          const DataColumn(label: Text('Hành động')),
                      ],
                      rows: filteredItems.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return DataRow(
                          cells: [
                            DataCell(Text('${index + 1}')),
                            ...widget.columns.map((column) {
                              if (column.cellBuilder != null) {
                                return DataCell(column.cellBuilder!(item));
                              }
                              return DataCell(Text(column.valueGetter(item)));
                            }),
                            if (widget.rowActions.isNotEmpty)
                              DataCell(
                                Row(
                                  children: widget.rowActions
                                      .map(
                                        (action) => IconButton(
                                          icon: Icon(
                                            action.icon,
                                            color: action.color,
                                          ),
                                          tooltip: action.tooltip,
                                          onPressed: () =>
                                              action.onPressed(item),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
