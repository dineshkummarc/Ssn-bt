import 'package:flutter/material.dart';

class StatusWidget extends StatelessWidget {
  final bool? status;
  StatusWidget({required this.status});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Status',
          style: TextStyle(color: Colors.grey),
        ),
        (status == null)
            ? Icon(Icons.pending_actions, color: Colors.grey)
            : (status == true)
                ? Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                : Icon(
                    Icons.block,
                    color: Colors.red,
                  ),
      ],
    );
  }
}
