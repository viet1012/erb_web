import 'package:flutter/material.dart';

import '../models/menu_model.dart';

class MenuItemTile extends StatefulWidget {
  final MenuModel menu;
  final bool isSelected;
  final int level;
  final VoidCallback onTap;

  const MenuItemTile({
    required this.menu,
    required this.isSelected,
    required this.level,
    required this.onTap,
  });

  @override
  State<MenuItemTile> createState() => _MenuItemTileState();
}

class _MenuItemTileState extends State<MenuItemTile> {
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
