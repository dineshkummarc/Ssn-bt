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
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: (isSelected) ? Colors.blue.shade800 : Colors.white,
        border: Border.all(
          width: 1,
          color: Colors.white,
        ),
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
              color: (isSelected) ? Colors.white : Colors.black,
            ),
          ),
          const Spacer(),
          Text(
            stop.stopName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: (isSelected) ? Colors.white : Colors.black,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
