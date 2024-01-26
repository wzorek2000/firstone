import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class AddEntryLogic {
  static final CollectionReference entries =
      FirebaseFirestore.instance.collection('entries');

  static int emojiToMoodValue(String? emoji) {
    switch (emoji) {
      case '🥰':
        return 5;
      case '☺️':
        return 4;
      case '🙂':
        return 3;
      case '😔':
        return 2;
      case '😞':
        return 1;
      default:
        return 0;
    }
  }

  static Future<void> addNewEntry({
    required GlobalKey<FormState> formKey,
    required BuildContext context,
    required TextEditingController titleController,
    required TextEditingController contentController,
    required String? selectedEmoji,
    XFile? imageFile,
  }) async {
    if (formKey.currentState!.validate()) {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await _uploadImageToStorage(imageFile);
      }
      if (userId == null) {
        const snackBar = SnackBar(content: Text('Nie jesteś zalogowany.'));
        imageUrl = await _uploadImageToStorage(imageFile);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }

      int moodValue = emojiToMoodValue(selectedEmoji);
      Map<String, dynamic> newEntry = {
        'userId': userId,
        'title': titleController.text,
        'content': contentController.text,
        'emoji': selectedEmoji,
        'mood': moodValue,
        'date': FieldValue.serverTimestamp(),
        'imageUrl': imageUrl,
      };

      try {
        await entries.add(newEntry);
        print('Nowy wpis dodany do bazy danych Firestore');
        titleController.clear();
        contentController.clear();
        Navigator.of(context).pop();
      } catch (e) {
        final snackBar =
            SnackBar(content: Text('Problem podczas dodawania wpisu: $e'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  static Future<File?> _compressImage(XFile xFile) async {
    try {
      Uint8List imageData = await xFile.readAsBytes();
      img.Image? image = img.decodeImage(imageData);

      img.Image resized = img.copyResize(image!, width: 800);
      List<int> compressedImageData = img.encodeJpg(resized, quality: 85);

      String tempPath = (await getTemporaryDirectory()).path;
      File tempFile = File('$tempPath/compressed_image.jpg');
      tempFile.writeAsBytesSync(compressedImageData);

      return tempFile;
    } catch (e) {
      print('Błąd podczas kompresji obrazu: $e');
      return null;
    }
  }

  static Future<String?> _uploadImageToStorage(XFile? imageFile) async {
    if (imageFile == null) {
      return null;
    }

    File? compressedFile = await _compressImage(imageFile);
    if (compressedFile == null) return null;

    String fileName =
        'img/${DateTime.now().millisecondsSinceEpoch}_${compressedFile.uri.pathSegments.last}';
    try {
      await FirebaseStorage.instance.ref(fileName).putFile(compressedFile);
      return await FirebaseStorage.instance.ref(fileName).getDownloadURL();
    } catch (e) {
      print('Błąd podczas przesyłania obrazu: $e');
      return null;
    }
  }
}
