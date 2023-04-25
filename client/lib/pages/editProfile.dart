import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:client/services/profile_service.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final Map<String, dynamic> profile;

  const EditProfile({super.key, required this.profile});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isNameChanged = false;
  bool _isEmailChanged = false;
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

    if (_nameController.text.trim() != widget.profile['name']) {
      data['name'] = _nameController.text.trim();
    }

    if (_emailController.text.trim() != widget.profile['email']) {
      data['email'] = _emailController.text.trim();
    }

    if (data.isNotEmpty || _imageFile != null) {
      final res = await updateProfile(data, _imageFile);
      Fluttertoast.showToast(msg: res);
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.profile['name'] ?? '';
    _emailController.text = widget.profile['email'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
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
                  child: widget.profile.containsKey("photoUrl")
                      ? ClipOval(
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              Colors.black
                                  .withOpacity(0.5), // Adjust opacity as needed
                              BlendMode.darken,
                            ),
                            child: Image.network(
                              widget.profile["photoUrl"],
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
                  labelText: 'Name',
                  hintText: 'Enter your Name',
                ),
                controller: _nameController,
                onChanged: (value) {
                  setState(() {
                    _isNameChanged = value.trim() != widget.profile["name"];
                  });
                },
              ),
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
                  final emailRegExp =
                      RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
                  if (!emailRegExp.hasMatch(value!)) {
                    return 'Enter valid Email';
                  }
                  return null;
                }),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter your Email',
                ),
                controller: _emailController,
                onChanged: (value) {
                  setState(() {
                    _isEmailChanged = value.trim() != widget.profile["email"];
                  });
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: _imageFile != null || _isNameChanged || _isEmailChanged
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
