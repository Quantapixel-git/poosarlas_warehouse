import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Getimagewidget extends StatefulWidget {
  const Getimagewidget({super.key});

  @override
  State<Getimagewidget> createState() => _GetimagewidgetState();
}

class _GetimagewidgetState extends State<Getimagewidget> {
  final ImagePicker _picker = ImagePicker();
  File? SelectedImage;
  TextEditingController productnamecontroller = new TextEditingController();

  Future getImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      SelectedImage = File(image.path);
      setState(() {});
    } else {
      // Handle the case where no image is selected
      ('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SelectedImage == null
        ? GestureDetector(
            onTap: () {
              getImage();
            },
            child: Container(
              height: 155,
              width: 155,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: const Color.fromARGB(255, 131, 131, 131),
                      width: 5)),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Icon(
                    Icons.camera_alt_outlined,
                    color: const Color.fromARGB(255, 106, 106, 106),
                    size: 80,
                  ),
                  Text(
                    'Click to Add Image',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey),
                  ),
                ],
              ),
            ),
          )
        : Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(20),
            child: GestureDetector(
              onTap: () {
                SelectedImage = null;
                getImage();
              },
              child: Container(
                height: 155,
                width: 155,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: const Color.fromARGB(255, 131, 131, 131),
                        width: 5)),
                child: Image.file(
                  SelectedImage!,
                  fit: BoxFit.cover,
                ),
              ),
            ));
  }
}
