import 'package:flutter/material.dart';
import '../models/menu_model.dart';
import '../widgets/crud_table.dart';

class MasterMenuScreen extends StatefulWidget {
  const MasterMenuScreen({super.key});

  @override
  State<MasterMenuScreen> createState() => _MasterMenuScreenState();
}

class _MasterMenuScreenState extends State<MasterMenuScreen> {
  MenuModel? selectedMenu;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 280,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[900]!, Colors.blue[800]!],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.dashboard_customize,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quản lý',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              'Hệ thống',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Menu List
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: buildMenuTree(
                      menus: menuList,
                      selectedTitle: selectedMenu?.title,
                      onSelect: (menu) {
                        setState(() => selectedMenu = menu);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Column(
              children: [
                // Top Bar
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      if (selectedMenu != null) ...[
                        Icon(
                          Icons.folder_open,
                          color: Colors.blue[700],
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          selectedMenu!.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ] else ...[
                        Icon(
                          Icons.home_outlined,
                          color: Colors.grey[400],
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Trang chủ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.search, color: Colors.grey[600]),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.notifications_outlined,
                          color: Colors.grey[600],
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.blue[100],
                        child: Icon(Icons.person, color: Colors.blue[700]),
                      ),
                    ],
                  ),
                ),

                // Content Area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: selectedMenu == null
                          ? _buildWelcomeScreen()
                          : Container(
                              key: ValueKey(selectedMenu!.title),
                              child: CrudTable(title: selectedMenu!.title),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.touch_app, size: 80, color: Colors.blue[300]),
          ),
          const SizedBox(height: 24),
          Text(
            'Chào mừng đến với Hệ thống Quản lý',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Vui lòng chọn menu bên trái để bắt đầu',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

Widget buildMenuTree({
  required List<MenuModel> menus,
  required Function(MenuModel) onSelect,
  String? selectedTitle,
  int level = 0,
}) {
  return Column(
    children: menus.map((menu) {
      final isSelected = selectedTitle == menu.title;
      final hasChildren = menu.subMenus.isNotEmpty;

      if (!hasChildren) {
        return _MenuItemTile(
          menu: menu,
          isSelected: isSelected,
          level: level,
          onTap: () => onSelect(menu),
        );
      } else {
        return _MenuExpansionTile(
          menu: menu,
          level: level,
          selectedTitle: selectedTitle,
          onSelect: onSelect,
        );
      }
    }).toList(),
  );
}

class _MenuItemTile extends StatefulWidget {
  final MenuModel menu;
  final bool isSelected;
  final int level;
  final VoidCallback onTap;

  const _MenuItemTile({
    required this.menu,
    required this.isSelected,
    required this.level,
    required this.onTap,
  });

  @override
  State<_MenuItemTile> createState() => _MenuItemTileState();
}

class _MenuItemTileState extends State<_MenuItemTile> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          margin: EdgeInsets.only(
            left: 12 + (widget.level * 16.0),
            right: 12,
            bottom: 4,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? Colors.white.withOpacity(0.2)
                : isHovered
                ? Colors.white.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.isSelected
                  ? Colors.white.withOpacity(0.3)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              if (widget.level > 0)
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                )
              else if (widget.menu.icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(
                    widget.menu.icon,
                    size: 20,
                    color: widget.isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.8),
                  ),
                ),
              Expanded(
                child: Text(
                  widget.menu.title,
                  style: TextStyle(
                    color: widget.isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.9),
                    fontWeight: widget.isSelected
                        ? FontWeight.bold
                        : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              if (widget.isSelected)
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.greenAccent,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuExpansionTile extends StatefulWidget {
  final MenuModel menu;
  final int level;
  final String? selectedTitle;
  final Function(MenuModel) onSelect;

  const _MenuExpansionTile({
    required this.menu,
    required this.level,
    required this.selectedTitle,
    required this.onSelect,
  });

  @override
  State<_MenuExpansionTile> createState() => _MenuExpansionTileState();
}

class _MenuExpansionTileState extends State<_MenuExpansionTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => isExpanded = !isExpanded),
          child: Container(
            margin: EdgeInsets.only(
              left: 12 + (widget.level * 16.0),
              right: 12,
              bottom: 4,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isExpanded
                  ? Colors.white.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                if (widget.menu.icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      widget.menu.icon,
                      size: 20,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                Expanded(
                  child: Text(
                    widget.menu.title,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_right,
                  color: Colors.white.withOpacity(0.7),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          buildMenuTree(
            menus: widget.menu.subMenus,
            onSelect: widget.onSelect,
            selectedTitle: widget.selectedTitle,
            level: widget.level + 1,
          ),
      ],
    );
  }
}
