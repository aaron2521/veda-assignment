import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? _image;
  final _picker = ImagePicker();

  Future<void> addImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> uploadImage(File? image) async {
    Uri uri = Uri.parse("https://codelime.in/api/remind-app-token");
    var request = http.MultipartRequest('POST', uri);
    request.files.add(http.MultipartFile(
        'image',
        File(image!.path).readAsBytes().asStream(),
        File(image.path).lengthSync(),
        filename: image.path.split("/").last));
    var response = await request.send();
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Image Uploaded"),
        duration: Duration(seconds: 2),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something wrong"),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              _image == null
                  ? Text("No Image Selected")
                  : Container(
                      height: 200,
                      width: 200,
                      child: Image.file(_image!),
                    ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  addImage();
                },
                child: Text("Upload"),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_image == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Please add image"),
                      duration: Duration(seconds: 2),
                    ));
                  } else {
                    uploadImage(_image);
                  }
                },
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
