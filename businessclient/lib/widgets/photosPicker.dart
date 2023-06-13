import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:businessclient/services/profile_service.dart';

class PhotosPicker extends StatefulWidget {
  final VoidCallback onPostClicked;
  const PhotosPicker({super.key, required this.onPostClicked});

  @override
  State<PhotosPicker> createState() => _PhotosPickerState();
}

class _PhotosPickerState extends State<PhotosPicker> {
  List<XFile> _imageFiles = [];

  Future<void> _pickImages() async {
    try {
      final pickedFiles = await ImagePicker().pickMultiImage();
      setState(() {
        _imageFiles = pickedFiles;
      });
      print(_imageFiles);
    } catch (e) {
      Fluttertoast.showToast(msg: "Image picker error $e");
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
    });
  }

  Widget _buildImagePreview(XFile file, int index) {
    return Stack(
      children: [
        Image.file(
          File(file.path),
          fit: BoxFit.cover,
          width: 100,
          height: 100,
        ),
        Positioned(
          top: 0,
          right: 0,
          child: InkWell(
            onTap: () {
              _removeImage(index);
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
    );
  }

  Widget _buildImageGrid() {
    if (_imageFiles.isEmpty) {
      return Container();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: _imageFiles.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (BuildContext context, int index) {
          return _buildImagePreview(_imageFiles[index], index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: _pickImages,
          icon: Icon(
            Icons.add,
            size: 24.0,
            color: Color.fromARGB(190, 61, 135, 118),
          ),
          label: Text(
            'Add photos',
            style: TextStyle(
              color: Color.fromARGB(190, 61, 135, 118),
            ),
          ),
        ),
        if (_imageFiles.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageGrid(),
              TextButton(
                onPressed: () async {
                  final res = await postImages(_imageFiles);
                  _imageFiles.clear();
                  widget.onPostClicked.call();
                },
                child: Text(
                  "Post",
                  style: TextStyle(
                    color: Color.fromARGB(190, 61, 135, 118),
                  ),
                ),
              )
            ],
          ),
      ],
    );
  }
}
