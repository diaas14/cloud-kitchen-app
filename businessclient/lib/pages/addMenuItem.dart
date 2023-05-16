import 'dart:io';

import 'package:flutter/material.dart';
import 'package:businessclient/widgets/quantitySelector.dart';
import 'package:businessclient/services/profile_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddMenuItem extends StatefulWidget {
  @override
  _AddMenuItemState createState() => _AddMenuItemState();
}

class _AddMenuItemState extends State<AddMenuItem> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  final TextEditingController _itemDescriptionController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  XFile? _imageFile = null;
  int _quantity = 1;

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemPriceController.dispose();
    _itemDescriptionController.dispose();
    super.dispose();
  }

  Future _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Image picker error $e");
    }
  }

  void _addItem() async {
    if (_formKey.currentState!.validate()) {
      final data = <String, dynamic>{};
      data["itemName"] = _itemNameController.text;
      data["itemPrice"] = _itemPriceController.text;
      if (_itemDescriptionController.text.isNotEmpty) {
        data["itemDescription"] = _itemDescriptionController.text;
      }
      data["itemQuantity"] = _quantity;
      final result = await addItemToMenu(data, _imageFile);
      Fluttertoast.showToast(
        msg: result,
      );
      if (result == 'success') {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Menu Item"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 36, 151, 164),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Fill to Add Menu Item',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _itemNameController,
                    decoration: InputDecoration(
                      labelText: 'Item Name*',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an item name';
                      }
                      return null; // Return null to indicate no validation error
                    },
                  ),
                  TextFormField(
                    controller: _itemDescriptionController,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                    maxLength: 100,
                  ),
                  TextFormField(
                    controller: _itemPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Price*',
                      prefixText: '\u20B9',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an item price';
                      }
                      final price = double.tryParse(value);
                      if (price == null || price <= 0) {
                        return 'Please enter a valid item price greater than zero';
                      }
                      return null; // Return null to indicate no validation error
                    },
                  ),
                  Row(children: [
                    Text('Quantity'),
                    QuantitySelector(
                      quantity: _quantity,
                      onChanged: (int newQuantity) {
                        setState(() {
                          _quantity = newQuantity;
                        });
                      },
                    ),
                  ]),
                  if (_imageFile != null)
                    Stack(
                      children: [
                        Image.file(
                          File(_imageFile!.path),
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _imageFile = null;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.withOpacity(0.8),
                              ),
                              padding: EdgeInsets.all(2),
                              child: Icon(
                                Icons.clear,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  TextButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(
                      Icons.file_upload,
                      size: 18,
                    ),
                    label: Text(
                      'Add a Photo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _addItem,
                    child: Text('Add Item'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
