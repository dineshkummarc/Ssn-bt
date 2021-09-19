import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ssnbt/screens/report_lost_item.dart';
import 'package:ssnbt/services/firestore_service.dart';
import 'package:ssnbt/widgets/lost_item_card.dart';

class LostFound extends StatelessWidget {
  const LostFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Report Lost Item',
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ReportLostItem()));
        },
      ),
      body: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Requests Raised",
              style: TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: StreamBuilder<DocumentSnapshot?>(
                  stream: FirestoreService().userDataStream,
                  builder: (context, snapshot) {
                    if (snapshot.data?.exists == false) {
                      return const Center(
                        child: Text(
                          'No Requests Raised',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    }
                    if (snapshot.connectionState == ConnectionState.active) {
                      List lostItemRequests =
                          snapshot.data?.get('lostItemRequests') ?? [];
                      if (lostItemRequests.isEmpty) {
                        return const Center(
                          child: Text(
                            'No Requests Raised',
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      } else {
                        return ListView(
                          children: lostItemRequests
                              .map((lostItemId) =>
                                  LostItemCard(itemRequestId: lostItemId))
                              .toList(),
                        );
                      }
                    }
                    return const Center(child: CircularProgressIndicator());
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
