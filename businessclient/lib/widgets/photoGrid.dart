import 'package:flutter/material.dart';

class PhotoGrid extends StatefulWidget {
  final List<dynamic> urls;
  const PhotoGrid({super.key, required this.urls});

  @override
  State<PhotoGrid> createState() => _PhotoGridState();
}

class _PhotoGridState extends State<PhotoGrid> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: GridView.builder(
        itemCount: widget.urls.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
        ),
        itemBuilder: (context, index) {
          return Image.network(
            widget.urls[index],
          );
        },
      ),
    );
  }
}
