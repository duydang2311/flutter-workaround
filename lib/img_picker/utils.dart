import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  try {
    final xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if(xFile != null) {
      return File(xFile.path);
    }
    return null;
  } catch(e) {
    return null;
  }
}

// Future<void> getLostData() async {
//   final ImagePicker picker = ImagePicker();
//   final LostDataResponse response = await picker.retrieveLostData();
//   if (response.isEmpty) {
//     return;
//   }
//   final List<XFile>? files = response.files;
//       if(files != null) {
//       return File(files.path);
//     }
//     return null;
// }