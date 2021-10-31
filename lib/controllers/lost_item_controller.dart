import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:ssnbt/models/lost_item.dart';

class LostItemController extends GetxController {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  var lostItemsList = <LostItem>[].obs;
  var isLoading = false.obs;
  var imagePath = Rxn<String>();
  LostItem addLostItemFields = LostItem();

  @override
  void onInit() {
    super.onInit();
    lostItemsList.bindStream(userLostItemStream());
  }

  Future<LostItem> getItemDetails(String itemRequestId) async {
    DocumentSnapshot documentSnapshot =
        await _instance.collection("lostItems").doc(itemRequestId).get();
    return LostItem.fromJson(
        itemRequestId, documentSnapshot.data() as Map<String, dynamic>);
  }

  Future addLostItem() async {
    isLoading.value = true;
    DocumentReference _itemReference =
        await _instance.collection('lostItems').add({
      'name': addLostItemFields.name,
      'description': addLostItemFields.description,
      'contactNumber': addLostItemFields.contactNumber,
      'busNumber': addLostItemFields.busNumber,
      'image': null,
      'approved': null
    });
    if (imagePath.value != null) {
      Reference ref = FirebaseStorage.instance
          .ref('lostItems/${_itemReference.id}/itemImage');
      await ref.putFile(File(imagePath.value!));
      String downloadUrl = await ref.getDownloadURL();
      await _itemReference.update({'image': downloadUrl});
      imagePath.value = null;
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
    isLoading.value = false;
    Get.back();
  }

  Future deleteLostItem(String itemRequestId) async {
    //delete image from storage
    final _firebaseStorage = FirebaseStorage.instance;
    LostItem itemData = await getItemDetails(itemRequestId);
    if (itemData.imagePath != null) {
      await _firebaseStorage.refFromURL(itemData.imagePath!).delete();
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

  Stream<List<LostItem>> userLostItemStream() {
    return _instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .asyncMap((documentSnapshot) async {
      List documentSnapshotList = documentSnapshot.get('lostItemRequests');
      List<LostItem> retVal = [];
      for (int i = 0; i < documentSnapshotList.length; i++) {
        retVal.add(await getItemDetails(documentSnapshotList[i]));
      }
      return retVal;
    });
  }
}
