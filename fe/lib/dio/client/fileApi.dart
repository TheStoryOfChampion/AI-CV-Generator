import 'package:ai_cv_generator/dio/client/dioClient.dart';
import 'package:ai_cv_generator/models/files/FileModel.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class FileApi extends DioClient {
  static Future<Response?> uploadFile(
    {
      required PlatformFile? file,

    }
  ) async {
    if (file == null) return null;
    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(
        file.bytes as List<int>, filename: file.name,
      )
    });

    try {
      Response response = await DioClient.dio.post(
        'api/User/file', // will be changed
        data: formData,
        onSendProgress: (int sent, int total) {
          print('$sent $total');
        },
      );
      return response;
    } on DioError catch(e) {
      DioClient.handleError(e);
    }
    return null;
  }

  static Future<PlatformFile?> requestFileFile(
    {
      required PlatformFile file,
      required id
    }
  ) async {
    FileModel? file;
    try {
      Response userData = await DioClient.dio.get('${DioClient.base}/users/search/$id');
      file = FileModel.fromJson(userData.data);
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!  no response');
        print('STATUS: ${e.response?.statusCode} //status of dio request failuire');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        print(e.message);
      }
    }
    if (file != null) {
      return PlatformFile(name: file.name , size: file.size,bytes: file.bytes);
    }
    return null;
  }
}