import 'package:flutter/material.dart';
import 'package:ssnbt/models/stop.dart';

class StopCard extends StatelessWidget {
  final Stop stop;
  final bool isSelected;
  const StopCard({Key? key, required this.stop, required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: (isSelected) ? const Color(0xFFA29DFF) : Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 12),
          Text(
            stop.getTimeString(),
            style: TextStyle(
              fontSize: 18,
              color: (isSelected) ? Colors.white : const Color(0xFFA29DFF),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            stop.stopName,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: (isSelected) ? Colors.white : const Color(0xFFA29DFF),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
