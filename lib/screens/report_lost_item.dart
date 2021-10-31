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
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Report Lost Item",
                style: TextStyle(color: Colors.white, fontSize: 32),
              ),
              Obx(() {
                return Center(
                  child: Container(
                    height: size.height / 4,
                    width: size.height / 4,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: (_lostItemController.imagePath.value != null)
                        ? Stack(
                            children: [
                              Image.file(
                                File(_lostItemController.imagePath.value!),
                                height: size.height / 4,
                                width: size.height / 4,
                                fit: BoxFit.cover,
                                isAntiAlias: true,
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  onPressed: () {
                                    _lostItemController.imagePath.value = null;
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
                            child: Text(
                              "Add Image\n (optional)",
                              style: TextStyle(
                                fontSize: 24,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ),
                  ),
                );
              }),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      onChanged: (val) {
                        _lostItemController.addLostItemFields.name = val;
                      },
                      validator: (val) =>
                          val!.isEmpty ? "Please Enter the item name" : null,
                      decoration:
                          textInputDecoration.copyWith(hintText: "Item Name"),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      onChanged: (val) {
                        _lostItemController.addLostItemFields.contactNumber =
                            int.tryParse(val) ?? 0;
                      },
                      validator: (val) => val!.length < 10
                          ? "Please Enter a valid Contact Number"
                          : null,
                      decoration: textInputDecoration.copyWith(
                        prefixIcon: const Padding(
                          padding: EdgeInsets.fromLTRB(15, 15, 0, 15),
                          child: Text('+91'),
                        ),
                        hintText: "Contact Number",
                        counterStyle: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      elevation: 8,
                      menuMaxHeight: size.height * 0.6,
                      decoration: textInputDecoration,
                      validator: (val) => (val == null || val.isEmpty)
                          ? 'Select a Route'
                          : null,
                      hint: const Text('Route Number'),
                      onChanged: (val) {
                        _lostItemController.addLostItemFields.busNumber = val!;
                      },
                      items: routesList.map((routeIndex) {
                        return DropdownMenuItem<String>(
                          value: routeIndex.routeNumber,
                          child: Text("Route Number ${routeIndex.routeNumber}"),
                          alignment: AlignmentDirectional.center,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      minLines: 4,
                      maxLines: 7,
                      onChanged: (val) {
                        _lostItemController.addLostItemFields.description = val;
                      },
                      textInputAction: TextInputAction.done,
                      decoration: textInputDecoration.copyWith(
                        hintText: "Description (optional)",
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.07),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
                            fontSize: 20,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 30,
                          ),
                        ),
                      );
                    },
                  ),
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
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 20),
                            ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 30,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
