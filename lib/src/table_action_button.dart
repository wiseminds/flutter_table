// import 'package:admin/constants/app_colors.dart';
// import 'package:admin/core/extensions/index.dart';
import 'package:flutter/material.dart';

class TableActionButton extends StatelessWidget {
  final Function()? onPressed;
  final IconData icon;
  final String label;
  final Color color;
  const TableActionButton(
      {Key? key,
      this.onPressed,
      required this.icon,
      required this.label,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(icon, size: 12),
            const SizedBox(height: 10.0),
            Text(label),
          ],
        ));
  }
}
