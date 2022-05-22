import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final _picker = ImagePicker();
  final _storage = FirebaseStorage.instance;

  Reference getFirebaseStorageRef(String imageName) {
    final String fullPath = '/test/$imageName';
    return _storage.ref().child(fullPath);
  }

  takePhoto({
    Function(double)? onProgress,
    required Function(String) onSucces,
  }) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return;
    final uploadTask = _savePhoto(image.name, image);

    uploadTask.snapshotEvents.listen((taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          if (onProgress != null) onProgress(progress);
          print(progress);
          break;
        case TaskState.paused:
          // ...
          break;
        case TaskState.success:
          print("Photo state: Success");
          final ref = getFirebaseStorageRef(taskSnapshot.ref.name);
          onSucces(await ref.getDownloadURL());
          break;
        case TaskState.canceled:
          // ...
          break;
        case TaskState.error:
          print("Photo state error: ${TaskState.error}");
          break;
      }
    });
  }

  UploadTask _savePhoto(String imageName, XFile image) {
    final imagesRef = getFirebaseStorageRef(imageName);
    return imagesRef.putFile(File(image.path));
  }

  Future<bool> deletePhoto(String url) async {
    final imagesRef = _storage.refFromURL(url);
    try {
      await imagesRef.delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
