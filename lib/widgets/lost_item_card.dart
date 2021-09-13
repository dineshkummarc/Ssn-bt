import 'package:flutter/material.dart';
import 'package:ssnbt/models/lost_item.dart';
import 'package:ssnbt/services/firestore_service.dart';
import 'package:ssnbt/widgets/delete_item_button.dart';
import 'package:ssnbt/widgets/status_widget.dart';

class LostItemCard extends StatelessWidget {
  final String itemRequestId;
  const LostItemCard({Key? key, required this.itemRequestId}) : super(key: key);

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
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: (_lostItem.imagePath == null)
                          ? Image.asset(
                              'assets/lostImagePlaceholder.png',
                            )
                          : FadeInImage.assetNetwork(
                              placeholder: 'assets/lostImageLoading.gif',
                              image: _lostItem.imagePath!),
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
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                            Text(_lostItem.description ?? '',
                                style: const TextStyle(fontSize: 16))
                          ]),
                    ),
                  ),
                  Container(
                    height: 120,
                    padding: const EdgeInsets.fromLTRB(2, 14, 2, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatusWidget(status: _lostItem.approved),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text('Delete Request'),
                                        content: Text(
                                            "Are you sure you want to delete the lost request for ${_lostItem.name}"),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('NO')),
                                          DeleteItemButton(
                                              itemRequestId: itemRequestId)
                                        ],
                                      ));
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ))
                      ],
                    ),
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
