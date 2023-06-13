import 'package:flutter/material.dart';

class ImageGallery extends StatefulWidget {
  final List<dynamic> imageUrls;
  const ImageGallery({super.key, required this.imageUrls});

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Set a fixed height for the horizontal gallery
      child: Builder(
        builder: (BuildContext context) {
          if (widget.imageUrls.isEmpty) {
            return Center(
              child: Text('No photos to show'),
            );
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              final imageUrl = widget.imageUrls[index];
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.network(
                  imageUrl,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
