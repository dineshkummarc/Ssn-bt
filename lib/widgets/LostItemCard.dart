import 'package:flutter/material.dart';
import 'package:ssnbt/models/LostItem.dart';
import 'package:ssnbt/services/FirestoreService.dart';
import 'package:ssnbt/widgets/DeleteItemButton.dart';
import 'package:ssnbt/widgets/StatusWidget.dart';

class LostItemCard extends StatelessWidget {
  final String itemRequestId;
  LostItemCard({required this.itemRequestId});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: FutureBuilder<Map<String, dynamic>>(
          future: FirestoreService().getItemDetails(itemRequestId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              LostItem _lostItem = LostItem.fromJson(snapshot.data!);
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: (snapshot.data!['image'] == null)
                          ? Image.asset(
                              'assets/lostImagePlaceholder.png',
                            )
                          : FadeInImage.assetNetwork(
                              placeholder: 'assets/lostImageLoading.gif',
                              image: snapshot.data!['image']),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 2),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_lostItem.name,
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                            Text(_lostItem.description ?? '',
                                style: TextStyle(fontSize: 16))
                          ]),
                    ),
                  ),
                  Container(
                    height: 120,
                    padding: EdgeInsets.fromLTRB(2, 14, 2, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatusWidget(status: _lostItem.approved),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text('Delete Request'),
                                        content: Text(
                                            "Are you sure you want to delete the lost request for ${_lostItem.name}"),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('NO')),
                                          DeleteItemButton(
                                              itemRequestId: itemRequestId)
                                        ],
                                      ));
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ))
                      ],
                    ),
                  ),
                ],
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
