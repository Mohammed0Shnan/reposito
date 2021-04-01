import 'package:flutter_boilerplate/module_upload/manager/upload_manager/upload_manager.dart';
import 'package:flutter_boilerplate/module_upload/response/imgbb/imgbb_response.dart';
import 'package:inject/inject.dart';
@provide
class ImageUploadService {
  final UploadManager manager;

  ImageUploadService(this.manager);

  Future<String> uploadImage(String filePath) async {
    ImgBBResponse response = await manager.upload(filePath);
    if (response == null) {
      return null;
    } else {
      return response.url;
    }
  }
}
