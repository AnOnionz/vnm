import 'package:dio/dio.dart';
import 'package:vnm/core/data_source/remote_datasource.dart';
import 'package:vnm/features/images/data/models/image_upload_model.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utilities/parser.dart';

abstract class ImagesRemoteDataSource extends RemoteDatasource {
  Future<ImageUploadModel?> uploadImageToServer(XFile file,
      {bool withS3 = false}) async {
    final form = {'withS3': withS3};

    final _resp = await dio.post(path: '/images', data: form);

    final imageUploadModel = parseJson<ImageUploadModel>(
        (json: _resp, fromJson: ImageUploadModel.fromMap));

    if (imageUploadModel != null) {
      final formCloudFlare = FormData.fromMap({
        'file': MultipartFile.fromFileSync(file.path,
            filename: file.name,
            contentType: Headers.jsonMimeType
                .change(type: 'image', subtype: file.name.split('.').last))
      });

      await dio.postHttp(
          path: imageUploadModel.uploadUrl, data: formCloudFlare);

      if (imageUploadModel.s3 != null) {
        final formS3 = FormData.fromMap({
          ...imageUploadModel.s3!.fields!,
          'file': MultipartFile.fromFileSync(file.path,
              filename: file.name,
              contentType: Headers.jsonMimeType
                  .change(type: 'image', subtype: file.name.split('.').last)),
          'Content-Type': Headers.jsonMimeType
              .change(type: 'image', subtype: file.name.split('.').last)
              .mimeType
        });

        await dio.putS3(path: imageUploadModel.s3!.url!, data: formS3);
      }
    }
    return imageUploadModel;
  }
}
