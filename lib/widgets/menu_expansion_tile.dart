import '../models/menu_model.dart';
import 'package:flutter/material.dart';

import '../screens/master_menu_screen.dart';
import 'menu_item_tile.dart';

class MenuExpansionTile extends StatefulWidget {
  final MenuModel menu;
  final int level;
  final String? selectedTitle;
  final Function(MenuModel) onSelect;

  const MenuExpansionTile({
    required this.menu,
    required this.level,
    required this.selectedTitle,
    required this.onSelect,
  });

  @override
  State<MenuExpansionTile> createState() => _MenuExpansionTileState();
}

class _MenuExpansionTileState extends State<MenuExpansionTile> {
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
        return MenuItemTile(
          menu: menu,
          isSelected: isSelected,
          level: level,
          onTap: () => onSelect(menu),
        );
      } else {
        return MenuExpansionTile(
          menu: menu,
          level: level,
          selectedTitle: selectedTitle,
          onSelect: onSelect,
        );
      }
    }).toList(),
  );
}
