import 'package:flutter/material.dart';

class StatusWidget extends StatelessWidget {
  final bool? status;
  const StatusWidget({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Status',
          style: TextStyle(color: Colors.grey),
        ),
        (status == null)
            ? const Icon(Icons.pending_actions, color: Colors.grey)
            : (status == true)
                ? const Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                : const Icon(
                    Icons.block,
                    color: Colors.red,
                  ),
      ],
    );
  }
}
