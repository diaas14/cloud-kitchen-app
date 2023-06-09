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
  List<String> tags = [];
  bool _showAllTags = false;
  final List<String> _suggestedTags = [
    'Vegan',
    'Vegetarian',
    'Gluten-free',
    'Dairy-free',
    'Nut-free',
    'Egg-free',
    'Soy-free',
    'Shellfish-free',
    'Fish-free',
    'Halal',
    'Kosher',
    'Organic',
    'Locally sourced',
    'Sugar-free',
    'Low-carb',
    'Paleo',
    'Keto-friendly',
    'Whole30',
    'Allergen-free',
    'Non-GMO',
    'Non-Vegetarian',
    'Jain',
    'Sattvic',
    'Punjabi',
    'South Indian',
    'North Indian',
    'Gujarati',
    'Rajasthani',
    'Bengali',
    'Maharashtrian',
    'Goan',
    'Hyderabadi',
    'Kashmiri',
    'Awadhi',
    'Chettinad',
    'Kerala',
    'Mughlai',
  ];

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
      if (tags.isNotEmpty) {
        data["itemTags"] = tags;
      }
      data["itemQuantity"] = _quantity;
      final result = await addItemToMenu(data, _imageFile);
      Fluttertoast.showToast(
        msg: result,
      );
      if (result == 'success' && mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  void _toggleTag(String tag) {
    if (tags.contains(tag)) {
      setState(() {
        tags.remove(tag);
      });
    } else if (tags.length < 5) {
      setState(() {
        tags.add(tag);
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Maximum number of tags reached',
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  List<String> get _displayedTags =>
      _showAllTags ? _suggestedTags : _suggestedTags.take(8).toList();

// Toggle the _showAllTags value to show/hide all tags
  void _toggleShowAllTags() {
    setState(() {
      _showAllTags = !_showAllTags;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Menu Item"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(190, 61, 135, 118),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: (_imageFile != null)
                                ? Image.file(
                                    File(_imageFile!.path),
                                    height: height / 3,
                                    width: width,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/icons/kairuchi_icon.png',
                                    height: height / 3,
                                    width: width,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                              size: 35,
                            ),
                            onPressed: _pickImage,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                      controller: _itemNameController,
                      decoration: InputDecoration(
                        labelText: 'Item Name*',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(190, 61, 135, 118),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(190, 61, 135, 118),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(190, 61, 135, 118),
                            width: 2.0,
                          ),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        errorStyle: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an item name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      controller: _itemDescriptionController,
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(190, 61, 135, 118),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(190, 61, 135, 118),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(190, 61, 135, 118),
                            width: 2.0,
                          ),
                        ),
                      ),
                      maxLength: 100,
                    ),
                    TextFormField(
                      controller: _itemPriceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price*',
                        prefixText: '\u20B9',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(190, 61, 135, 118),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(190, 61, 135, 118),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(190, 61, 135, 118),
                            width: 2.0,
                          ),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        errorStyle: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an item price';
                        }
                        final price = double.tryParse(value);
                        if (price == null || price <= 0) {
                          return 'Please enter a valid item price greater than zero';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quantity',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color.fromARGB(190, 61, 135, 118),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        QuantitySelector(
                          quantity: _quantity,
                          onChanged: (int newQuantity) {
                            setState(() {
                              _quantity = newQuantity;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      'Select Tags',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(190, 61, 135, 118),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Wrap(
                      children: tags.map((tag) {
                        return Container(
                          margin: EdgeInsets.all(4),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 167, 210, 197),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Suggested Tags',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color.fromARGB(190, 61, 135, 118),
                          ),
                        ),
                        TextButton(
                          onPressed: _toggleShowAllTags,
                          child: Text(
                            _showAllTags ? 'Hide' : 'Show More',
                            style: TextStyle(
                              color: Color.fromARGB(190, 61, 135, 118),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Wrap(
                      children: _displayedTags.map((tag) {
                        bool isSelected = tags.contains(tag);

                        return GestureDetector(
                          onTap: () {
                            _toggleTag(tag);
                          },
                          child: Container(
                            margin: EdgeInsets.all(4),
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Color.fromARGB(255, 167, 210, 197)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? Color.fromARGB(255, 167, 210, 197)
                                    : Color.fromARGB(190, 61, 135, 118),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  tag,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Color.fromARGB(190, 61, 135, 118),
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                Icon(isSelected ? Icons.close : Icons.add,
                                    color: isSelected
                                        ? Colors.white
                                        : Color.fromARGB(190, 61, 135, 118),
                                    size: 16),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: _addItem,
                      child: Text('Add Item'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
