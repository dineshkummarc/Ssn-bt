import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ssnbt/controllers/lost_item_controller.dart';
import 'package:ssnbt/models/lost_item.dart';

class LostItemCard extends StatelessWidget {
  final LostItem lostItem;
  LostItemCard({Key? key, required this.lostItem}) : super(key: key);
  final LostItemController _lostItemController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (lostItem.imagePath == null)
              ? Image.asset(
                  'assets/lostImagePlaceholder.png',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  isAntiAlias: true,
                )
              : FadeInImage.assetNetwork(
                  placeholder: 'assets/lostImageLoading.gif',
                  image: lostItem.imagePath!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lostItem.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.directions_bus,
                          size: 18,
                          color: Colors.amber,
                        ),
                        Text(
                          lostItem.busNumber,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Text(
                  lostItem.description ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (lostItem.approved == null)
                      const Text(
                        'Request Pending',
                        style: TextStyle(color: Colors.grey),
                      )
                    else if (lostItem.approved!)
                      const Text(
                        'Request Approved',
                        style: TextStyle(color: Colors.green),
                      )
                    else
                      const Text(
                        'Request Declined',
                        style: TextStyle(color: Colors.red),
                      ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
