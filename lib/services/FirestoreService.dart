import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ssnbt/models/LostItem.dart';
import 'package:ssnbt/services/AuthenticationService.dart';

class FirestoreService {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;
  final String userId = AuthenticationService().getUser()!.uid;

  Future<Map<String, dynamic>> getItemDetails(String itemRequestId) async {
    DocumentSnapshot documentSnapshot =
        await _instance.collection("lostItems").doc(itemRequestId).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return data;
  }

  Future addLostItem(LostItem data) async {
    DocumentReference _itemReference =
        await _instance.collection('lostItems').add({
      'name': data.name,
      'description': data.description,
      'contactNumber': data.contactNumber,
      'busNumber': data.busNumber,
      'image': null,
      'approved': null
    });
    if (data.image != null) {
      Reference ref = FirebaseStorage.instance
          .ref('lostItems/${_itemReference.id}/itemImage');
      await ref.putFile(data.image!);
      String url = await ref.getDownloadURL();
      await _itemReference.update({'image': url});
    }
    DocumentSnapshot _documentSnapshot =
        await _instance.collection("users").doc(userId).get();
    Map<String, dynamic> userCreatedData =
        _documentSnapshot.data() as Map<String, dynamic>? ??
            {'lostItemRequests': []};
    List productsList = userCreatedData['lostItemRequests'] ?? [];
    productsList.add(_itemReference.id);
    await _instance
        .collection('users')
        .doc(userId)
        .set({'lostItemRequests': productsList});
  }

  Future deleteLostItem(String itemRequestId) async {
    //delete image from storage
    final _firebaseStorage = FirebaseStorage.instance;
    Map<String, dynamic> itemData = await getItemDetails(itemRequestId);
    if (itemData['image'] != null) {
      String imageUrl = itemData['image'];
      await _firebaseStorage.refFromURL(imageUrl).delete();
    }
    //delete user data
    DocumentSnapshot documentSnapshot =
        await _instance.collection('users').doc(userId).get();
    List itemRequestsList = documentSnapshot.get('lostItemRequests');
    itemRequestsList.remove(itemRequestId);
    _instance
        .collection('users')
        .doc(userId)
        .update({'lostItemRequests': itemRequestsList});
    //delete request from common database
    await _instance.collection('lostItems').doc(itemRequestId).delete();
  }

  Stream<DocumentSnapshot?> get userDataStream =>
      _instance.collection('users').doc(userId).snapshots();
}
