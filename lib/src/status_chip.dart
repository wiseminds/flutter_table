import 'package:flutter/material.dart';

enum TableStatus {
  active(Colors.green),
  pending(Color.fromARGB(255, 33, 72, 243)),
  inactive(Color.fromARGB(255, 255, 17, 0));

  final Color color;
  const TableStatus(this.color);
}

class StatusChip extends StatelessWidget {
  final String? label;
  final TableStatus status;

  const StatusChip({Key? key, this.label, required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: status.color.withOpacity(.2),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Text(
            (label ?? status.name).toUpperCase(),
            style: TextStyle(
                color: status.color,
                fontSize: 8,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5),
          ),
        ));
  }
}
