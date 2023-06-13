import 'dart:io';
import 'package:flutter/material.dart';
import 'package:businessclient/widgets/quantitySelector.dart';
import 'package:businessclient/services/profile_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditMenuItem extends StatefulWidget {
  final Map<String, dynamic> item;
  const EditMenuItem({super.key, required this.item});

  @override
  _EditMenuItemState createState() => _EditMenuItemState();
}

class _EditMenuItemState extends State<EditMenuItem> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemDescriptionController =
      TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  late int _quantity;
  bool _isitemNameChanged = false;
  bool _isitemDescriptionChanged = false;
  bool _isitemPriceChanged = false;
  bool _isitemQuantityChanged = false;

  final _formKey = GlobalKey<FormState>();
  XFile? _imageFile;

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
  void initState() {
    super.initState();
    _itemNameController.text = widget.item["itemName"] ?? '';
    _itemDescriptionController.text = widget.item["itemDescription"] ?? '';
    _itemPriceController.text = widget.item.containsKey("itemPrice")
        ? widget.item["itemPrice"].toString()
        : '0';
    _quantity = widget.item.containsKey("itemQuantity")
        ? widget.item["itemQuantity"]
        : 1;
  }

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

  void _editItem() async {
    if (_formKey.currentState!.validate()) {
      final data = <String, dynamic>{};

      if (_isitemNameChanged) {
        data["itemName"] = _itemNameController.text;
      }
      if (_isitemDescriptionChanged) {
        data["itemDescription"] = _itemDescriptionController.text;
      }
      if (_isitemPriceChanged) {
        data["itemPrice"] = _itemPriceController.text;
      }
      if (_isitemQuantityChanged) {
        data["itemQuantity"] = _quantity;
      }

      if (data.isNotEmpty || _imageFile != null) {
        final res =
            await updateMenuItem(data, _imageFile, widget.item["itemId"]);
        Fluttertoast.showToast(msg: res);
        if (res == 'success' && mounted) {
          Navigator.pop(context, true);
        }
      }
    }
  }

  void _deleteItem() async {
    final res = await deleteMenuItem(widget.item["itemId"]);
    Fluttertoast.showToast(msg: res);
    if (res == 'success' && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Menu Item"),
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
                                : widget.item.containsKey("itemImgUrl")
                                    ? Image.network(
                                        widget.item["itemImgUrl"],
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
                      onChanged: (value) {
                        setState(() {
                          _isitemNameChanged =
                              value.trim() != widget.item["itemName"];
                        });
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
                      onChanged: (value) {
                        setState(() {
                          _isitemDescriptionChanged = value.trim() != ''
                              ? (widget.item.containsKey("itemDescription")
                                  ? value.trim() !=
                                      widget.item["itemDescription"]
                                  : true)
                              : false;
                        });
                      },
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
                      onChanged: (value) {
                        setState(() {
                          _isitemPriceChanged = value.trim() !=
                              widget.item["itemPrice"].toString();
                        });
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
                              _isitemQuantityChanged =
                                  _quantity != widget.item["itemQuantity"];
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: _imageFile != null ||
                                  _isitemNameChanged ||
                                  _isitemDescriptionChanged ||
                                  _isitemPriceChanged ||
                                  _isitemQuantityChanged
                              ? _editItem
                              : null,
                          child: Text('Edit Item'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        ),
                        ElevatedButton.icon(
                          label: Text("Delete Item"),
                          onPressed: _deleteItem,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          icon: Icon(
                            Icons.delete_outline,
                          ),
                        ),
                      ],
                    )
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
