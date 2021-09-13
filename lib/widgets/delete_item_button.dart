import 'package:flutter/material.dart';
import 'package:ssnbt/services/firestore_service.dart';

class DeleteItemButton extends StatefulWidget {
  final String itemRequestId;
  DeleteItemButton({required this.itemRequestId});
  @override
  _DeleteItemButtonState createState() => _DeleteItemButtonState();
}

class _DeleteItemButtonState extends State<DeleteItemButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          await FirestoreService().deleteLostItem(widget.itemRequestId);
          Navigator.pop(context);
        },
        child: (isLoading) ? CircularProgressIndicator() : Text('YES'));
  }
}
