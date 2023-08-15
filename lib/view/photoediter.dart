// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../provider/auth.dart';

class PhotoEditorPage extends StatefulWidget {
  const PhotoEditorPage({super.key});

  @override
  PhotoEditorPageState createState() => PhotoEditorPageState();
}

class PhotoEditorPageState extends State<PhotoEditorPage> {
  File? _image;
  Uint8List? _editedImageBytes;

  Future _getImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        _editedImageBytes = _image?.readAsBytesSync();
      });
    }
  }

  Future<void> _editImage() async {
    final permissionStatus = await Permission.storage.request();
    if (permissionStatus.isGranted) {
      if (_image != null) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageEditor(
              image: _editedImageBytes,
            ),
          ),
        );

        if (result != null && result is Uint8List) {
          setState(() {
            _editedImageBytes = result;
          });

          final tempDir = await getTemporaryDirectory();
          final tempFile = File('${tempDir.path}/${DateTime.now()}.jpg');
          await tempFile.writeAsBytes(result);

          final success = await GallerySaver.saveImage(tempFile.path);
          if (success!) {
            debugPrint('Image saved to gallery');
          } else {
            debugPrint('Failed to save image to gallery');
          }
        } else {
          debugPrint('Permission not granted to save images.');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<Auth>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Editor'),
        actions: [
          TextButton(
              onPressed: () {
                auth.singOutUser();
              },
              child: const Text("SignOut"))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _editedImageBytes == null
                ? const Text('No image selected.')
                : Image.memory(_editedImageBytes!, height: 200),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getImage,
              child: const Text('Select Image'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _editImage,
              child: const Text('Edit Image'),
            ),
          ],
        ),
      ),
    );
  }
}
