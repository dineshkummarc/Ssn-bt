import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ssnbt/constants.dart';
import 'package:ssnbt/models/lost_item.dart';
import 'package:ssnbt/services/firestore_service.dart';

List<String> busRoutes = [
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '9A',
  '10',
  '11',
  '12',
  '13',
  '14',
  '15',
  '16',
  '17',
  '18',
  '19',
  '20',
  '21',
  '22',
  '23',
  '24',
  '25',
  '26',
  '27',
  '28',
  '29',
  '30',
  '30A',
  '31',
  '32',
  '33',
  '34',
  '35',
  '36',
  '37',
  '38',
  '39',
  '40',
  '41',
  '42',
  '43',
];

class ReportLostItem extends StatefulWidget {
  const ReportLostItem({Key? key}) : super(key: key);

  @override
  _ReportLostItemState createState() => _ReportLostItemState();
}

class _ReportLostItemState extends State<ReportLostItem> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  LostItem lostItem = LostItem(busNumber: '1');
  bool _isLoading = false;
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
                                  lostItem.name = val;
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
                                  setState(() {
                                    lostItem.contactNumber =
                                        int.tryParse(val) ?? 0;
                                  });
                                },
                                validator: (val) => val!.length < 10
                                    ? "Please Enter a valid Contact Number"
                                    : null,
                                decoration: textInputDecoration.copyWith(
                                    prefixText: (lostItem.contactNumber != 0)
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
                                  setState(() {
                                    lostItem.busNumber = val!;
                                  });
                                },
                                items: busRoutes.map((busNumber) {
                                  return DropdownMenuItem<String>(
                                    value: busNumber,
                                    child: Text(busNumber),
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 120,
                            margin: const EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white),
                            child: (lostItem.imagePath != null)
                                ? Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          File(lostItem.imagePath!),
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
                                              setState(() {
                                                lostItem.imagePath = null;
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.cancel_outlined,
                                              color: Colors.blue,
                                            )),
                                      )
                                    ],
                                  )
                                : TextButton(
                                    onPressed: () async {
                                      final image = await _picker.pickImage(
                                          source: ImageSource.gallery);
                                      if (image != null) {
                                        setState(() {
                                          lostItem.imagePath = image.path;
                                        });
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
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      minLines: 3,
                      maxLines: 7,
                      onChanged: (val) {
                        lostItem.description = val;
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
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              await FirestoreService().addLostItem(lostItem);
                              Navigator.pop(context);
                            }
                          },
                          child: (_isLoading)
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'Submit',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 20),
                                ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30)),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: (_isLoading)
                              ? null
                              : () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                color: (_isLoading) ? Colors.grey : Colors.red,
                                fontSize: 20),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30)),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
