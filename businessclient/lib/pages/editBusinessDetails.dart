import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:businessclient/services/profile_service.dart';

class EditBusinessDetails extends StatefulWidget {
  final Map<String, dynamic> profile;
  final Function onUpdateProfileData;
  const EditBusinessDetails(
      {super.key, required this.profile, required this.onUpdateProfileData});

  @override
  State<EditBusinessDetails> createState() => _EditBusinessDetailsState();
}

class _EditBusinessDetailsState extends State<EditBusinessDetails> {
  final TextEditingController _businessNameController = TextEditingController();
  bool _isbusinessNameChanged = false;
  XFile? _imageFile;

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

  _submitForm() async {
    final data = <String, dynamic>{};

    if (_businessNameController.text.trim() != widget.profile['businessName']) {
      data['businessName'] = _businessNameController.text.trim();
    }

    if (data.isNotEmpty || _imageFile != null) {
      final res = await updateBusinessData(data, _imageFile);
      Fluttertoast.showToast(msg: res);

      if (res == 'success' && mounted) {
        widget.onUpdateProfileData();
        Navigator.pop(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _businessNameController.text = widget.profile['businessName'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 21, 120, 131),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  child: widget.profile.containsKey("businessLogoUrl")
                      ? ClipOval(
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              Colors.black
                                  .withOpacity(0.5), // Adjust opacity as needed
                              BlendMode.darken,
                            ),
                            child: Image.network(
                              widget.profile["businessLogoUrl"],
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : IconTheme(
                          data: IconThemeData(
                            size: 55,
                          ),
                          child: Icon(
                            Icons.person,
                          ),
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
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0x7fffffff),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                validator: ((value) {
                  return null;
                }),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Business\' Name',
                  hintText: 'Enter your Business\' Name',
                ),
                controller: _businessNameController,
                onChanged: (value) {
                  setState(() {
                    _isbusinessNameChanged =
                        value.trim() != widget.profile["businessName"];
                  });
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: _imageFile != null || _isbusinessNameChanged
                  ? _submitForm
                  : null,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
