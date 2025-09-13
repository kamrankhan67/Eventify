import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ImageStorage {
  Future<void> saveImage(File img, String id) async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String appDocPath = appDocDir.path;
      final String filePath = '$appDocPath/$id.png';

      // ignore: unused_local_variable
      final File savedImage = await img.copy(filePath);
      print("Image saved successfully at: $filePath");
    } catch (e) {
      print("Error saving image: $e");
    }
  }

  Future<File?> uploadImage(String id) async {
    final String fileName = '$id.png';
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String appDocPath = appDocDir.path;
      final String filePath = '$appDocPath/$fileName';
      final File imageFile = File(filePath);

      if (await imageFile.exists()) {
        print("Image found at: $filePath");
        return imageFile;
      } else {
        print("Image file not found for ID: $id");
        return null;
      }
    } catch (e) {
      print("Error retrieving image for ID $id: $e");
      return null;
    }
  }
}