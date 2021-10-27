import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssnbt/controllers/lost_item_controller.dart';
import 'package:ssnbt/models/lost_item.dart';
import 'package:ssnbt/widgets/status_widget.dart';

class LostItemCard extends StatelessWidget {
  final LostItem lostItem;
  LostItemCard({Key? key, required this.lostItem}) : super(key: key);
  final LostItemController _lostItemController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: (lostItem.imagePath == null)
                  ? Image.asset(
                      'assets/lostImagePlaceholder.png',
                    )
                  : FadeInImage.assetNetwork(
                      placeholder: 'assets/lostImageLoading.gif',
                      image: lostItem.imagePath!,
                    ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lostItem.name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    lostItem.description ?? '',
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 120,
            padding: const EdgeInsets.fromLTRB(2, 14, 2, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatusWidget(status: lostItem.approved),
                IconButton(
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        title: const Text('Delete Request'),
                        content: Text(
                            "Are you sure you want to delete the lost request for ${lostItem.name}"),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('NO'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await _lostItemController
                                  .deleteLostItem(lostItem.id);
                              Get.back();
                            },
                            child: const Text('YES'),
                          )
                        ],
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
//TODO improve this layout
