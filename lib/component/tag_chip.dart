import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart'show Material,RawChip;

class TagChip extends StatefulWidget {
  final String label;
  final Function(bool) onSelectionChanged;

  const TagChip({
    Key? key,
    required this.label,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _TagChipState createState() => _TagChipState();
}

class _TagChipState extends State<TagChip> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: RawChip(
        label: Text(widget.label),
        selected: _isSelected,
        onSelected: (isSelected) {
          setState(() {
            _isSelected = isSelected;
          });
          widget.onSelectionChanged(isSelected);
        },
      ),
    );
  }
}