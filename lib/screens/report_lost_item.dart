import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ssnbt/constants.dart';
import 'package:ssnbt/controllers/lost_item_controller.dart';
import 'package:ssnbt/models/route.dart';

class ReportLostItem extends StatelessWidget {
  ReportLostItem({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final LostItemController _lostItemController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Report Lost Item",
                    style: TextStyle(color: Colors.white, fontSize: 32),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              onChanged: (val) {
                                _lostItemController.addLostItemFields.name =
                                    val;
                              },
                              validator: (val) => val!.isEmpty
                                  ? "Please Enter the item name"
                                  : null,
                              decoration: textInputDecoration.copyWith(
                                  hintText: "Item Name"),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              onChanged: (val) {
                                _lostItemController.addLostItemFields
                                    .contactNumber = int.tryParse(val) ?? 0;
                              },
                              validator: (val) => val!.length < 10
                                  ? "Please Enter a valid Contact Number"
                                  : null,
                              decoration: textInputDecoration.copyWith(
                                  prefixText: (_lostItemController
                                              .addLostItemFields
                                              .contactNumber !=
                                          0)
                                      ? "+91 "
                                      : "",
                                  counterText: '',
                                  hintText: "Contact Number"),
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              decoration: textInputDecoration.copyWith(
                                  prefixText: "Bus Number "),
                              validator: (val) => (val == null || val.isEmpty)
                                  ? 'Select a bus'
                                  : null,
                              hint: const Text(''),
                              onChanged: (val) {
                                _lostItemController
                                    .addLostItemFields.busNumber = val!;
                              },
                              items: routesList.map((routeIndex) {
                                return DropdownMenuItem<String>(
                                  value: routeIndex.routeNumber,
                                  child: Text(routeIndex.routeNumber),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Obx(() {
                          return Container(
                            height: 120,
                            margin: const EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            child: (_lostItemController.imagePath.value != null)
                                ? Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          File(_lostItemController
                                              .imagePath.value!),
                                          height: 120,
                                          width: double.infinity,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                          onPressed: () {
                                            _lostItemController
                                                .imagePath.value = null;
                                          },
                                          icon: const Icon(
                                            Icons.cancel_outlined,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : TextButton(
                                    onPressed: () async {
                                      final image = await _picker.pickImage(
                                          source: ImageSource.gallery);
                                      if (image != null) {
                                        _lostItemController.imagePath.value =
                                            image.path;
                                      }
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Add Image",
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).hintColor),
                                        ),
                                        Text(
                                          "(optional)",
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).hintColor),
                                        ),
                                      ],
                                    ),
                                  ),
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    minLines: 3,
                    maxLines: 7,
                    onChanged: (val) {
                      _lostItemController.addLostItemFields.description = val;
                    },
                    textInputAction: TextInputAction.done,
                    decoration: textInputDecoration.copyWith(
                        hintText: "Description (optional)"),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/lostImageVector.png'),
                  Column(
                    children: [
                      Obx(() {
                        return ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _lostItemController.addLostItem();
                            }
                          },
                          child: (_lostItemController.isLoading.value)
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'Submit',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 20),
                                ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                          ),
                        );
                      }),
                      const SizedBox(height: 20),
                      Obx(
                        () {
                          return ElevatedButton(
                            onPressed: (_lostItemController.isLoading.value)
                                ? null
                                : () => Get.back(),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  color: (_lostItemController.isLoading.value)
                                      ? Colors.grey
                                      : Colors.red,
                                  fontSize: 20),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30),
                            ),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//TODO implement a better design
