import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vnm/core/permission/permisson_manager.dart';
import 'package:vnm/core/utilities/overlay.dart';
import 'package:vnm/features/camera/camera_module.dart';
import 'package:vnm/features/general/domain/entities/general_entity.dart';
import 'package:vnm/features/setting/domain/entities/setting_app.dart';
import 'package:vnm/features/statistic/domain/entities/employee_entity.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';

import '/core/mixins/common.dart';
import '../../database/database.dart';
import '../location/location_service.dart';
import '../network_time/network_time_service.dart';
import 'painter/watermark_painter.dart';

const imageWidth = 1080;
const imageHeight = 1920;

final class MediaService {
  ImagePicker _picker = ImagePicker();

  final settings = Database.instance.getObject<SettingApp>();

  Future<PermissionStatus?> requestPhotosPermission(
      {PermissionManager? permissionManager}) async {
    final _permissionManager =
        permissionManager ?? Modular.get<PermissionManager>();
    PermissionStatus? permision;
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        permision =
            await _permissionManager.requestPermission(Permission.storage);
      } else {
        permision =
            await _permissionManager.requestPermission(Permission.photos);
      }
    } else {
      permision = await _permissionManager.requestPermission(Permission.photos);
    }
    return permision;
  }

  Future<PermissionStatus?> requestCameraPermission(
      {PermissionManager? permissionManager}) async {
    final _permissionManager =
        permissionManager ?? Modular.get<PermissionManager>();
    PermissionStatus? permision;
    permision = await _permissionManager.requestPermission(Permission.camera);
    return permision;
  }

  Future<XFile?> pickImage({ImageSource source = ImageSource.camera}) async {
    try {
      final XFile? pickedFile;
      if (source == ImageSource.camera && (settings?.useCameraZ ?? false)) {
        pickedFile = await Modular.to.pushNamed(CameraModule.route);
      } else {
        final permissionManager = Modular.get<PermissionManager>();
        if (source == ImageSource.gallery) {
          final permission = await requestPhotosPermission(
              permissionManager: permissionManager);

          if (permission == PermissionStatus.denied ||
              permission == PermissionStatus.permanentlyDenied) {
            OverlayManager.showServiceDialog(
                message: 'Thay đổi quyền truy cập hình ảnh và thử lại',
                solution: () => permissionManager.openAppSettings(),
                title: 'Không thể truy cập thư viện ảnh');
            return null;
          }
        } else {
          final permission = await requestCameraPermission(
              permissionManager: permissionManager);

          if (permission == PermissionStatus.denied ||
              permission == PermissionStatus.permanentlyDenied) {
            OverlayManager.showServiceDialog(
                message: 'Thay đổi quyền truy cập camera và thử lại',
                solution: () => permissionManager.openAppSettings(),
                title: 'Không thể truy cập máy ảnh');
            return null;
          }
        }
        pickedFile = await _picker.pickImage(
          source: source,
          maxHeight: 1920,
          maxWidth: 1920,
          imageQuality: 100,
        );
      }

      if (pickedFile == null) {
        return null;
      }
      final compressedImage = await compressImage(pickedFile);

      return compressedImage;
    } catch (e) {
      return null;
    }
  }

  Future<XFile?> pickMedia(
    double? maxWidth,
    double? maxHeight,
    int? quality,
  ) async {
    try {
      final XFile? pickedFile = await _picker.pickMedia(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: quality,
      );
      return pickedFile;
    } catch (e) {
      Fx.log(e.toString());
      return null;
    }
  }

  Future<XFile?> pickVideo(Duration? maxDuration,
      {ImageSource source = ImageSource.gallery,
      CameraDevice cameraDevice = CameraDevice.rear}) async {
    try {
      final XFile? pickedFile = await _picker.pickVideo(
          source: source,
          maxDuration: maxDuration,
          preferredCameraDevice: cameraDevice);
      return pickedFile;
    } catch (e) {
      Fx.log(e.toString());
      return null;
    }
  }

  Future<List<XFile>> pickMultipleFile(
      double? maxWidth, double? maxHeight, int? quality,
      {bool isMedia = false}) async {
    try {
      final List<XFile> pickedFileList = isMedia
          ? await _picker.pickMultipleMedia(
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              imageQuality: quality,
            )
          : await _picker.pickMultiImage(
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              imageQuality: quality,
            );
      return pickedFileList;
    } catch (e) {
      Fx.log(e.toString());
      return <XFile>[];
    }
  }

  Future<XFile?> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return null;
    }
    if (response.file != null) {
      return response.file!;
    } else {
      return null;
    }
  }

  Future<bool> faceDetector(XFile image) async {
    InputImage inputImage;

    if (Platform.isIOS) {
      final File? iosImageProcessed = await bakeImageOrientation(image);
      Fx.log(iosImageProcessed);
      if (iosImageProcessed == null) {
        return false;
      }
      inputImage = InputImage.fromFilePath(iosImageProcessed.path);
    } else {
      inputImage = InputImage.fromFilePath(image.path);
    }
    final FaceDetector _faceDetector = FaceDetector(
      options: FaceDetectorOptions(minFaceSize: 0.2),
    );
    final faces = await _faceDetector.processImage(inputImage);
    await _faceDetector.close();

    return faces.isNotEmpty;
  }

  Future<File?> bakeImageOrientation(XFile pickedFile) async {
    if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final filename = DateTime.now().millisecondsSinceEpoch.toString();

      final img.Image? capturedImage =
          img.decodeImage(await File(pickedFile.path).readAsBytes());

      if (capturedImage == null) {
        return null;
      }

      final img.Image orientedImage = img.bakeOrientation(capturedImage);

      final imageToBeProcessed = await File('$path/$filename')
          .writeAsBytes(img.encodeJpg(orientedImage));

      return imageToBeProcessed;
    }
    return null;
  }

  Future<XFile?> addWatermark(XFile image) async {
    final fWatermark = DateFormat('dd/MM/yyyy HH:mm:ss');
    final _locationService = Modular.get<LocationService>();
    final _networkTime = Modular.get<NetworkTimeService>();
    final address = await _locationService.placeString();
    final _userInfo = Database.instance.getObject<EmployeeEntity>()?.user;
    final _outletInfo = Database.instance.getObject<GeneralEntity>()?.outlet;
    String employeeStr = '';

    if (address == null) {
      return null;
    }
    if (_outletInfo != null && _userInfo != null) {
      employeeStr = '\n${_outletInfo.name}\n${_userInfo.name}';
    }

    final ntpTime = await _networkTime.ntpDateTime();
    final time = fWatermark.format(ntpTime);

    final imgBytes = await image.readAsBytes();
    final lastIndex = image.path.lastIndexOf(RegExp(r'.png|.jp'));
    final decoded = await decodeImageFromList(imgBytes);
    final painterDesc = WatermarkPainter(
        '${time}${address}${employeeStr}', 64, decoded.width,
        color: Colors.white);

    final imageDataDesc = await painterDesc.toImageData();

    final x = -24;
    final y = 32;

    try {
      if (lastIndex == image.path.lastIndexOf(RegExp(r'.png'))) {
        final newImage = img.compositeImage(img.decodePng(imgBytes)!,
            img.decodePng(imageDataDesc!.buffer.asUint8List())!,
            dstX: x,
            dstY: y,
            dstW: painterDesc.pictureW.toInt(),
            dstH: painterDesc.pictureH.toInt());
        final file = File(image.path);
        file.deleteSync();
        file.writeAsBytesSync(img.encodePng(newImage));
        return XFile.fromData(file.readAsBytesSync(), path: file.path);
      }

      final newImage = img.compositeImage(img.decodeImage(imgBytes)!,
          img.decodeImage(imageDataDesc!.buffer.asUint8List())!,
          dstX: x,
          dstY: y,
          dstW: painterDesc.pictureW.toInt(),
          dstH: painterDesc.pictureH.toInt());
      final file = File(image.path);
      file.deleteSync();
      file.writeAsBytesSync(img.encodeJpg(newImage));

      return XFile.fromData(file.readAsBytesSync(), path: file.path);
    } catch (e) {
      return null;
    }
  }

  Future<XFile?> compressImage(XFile file) async {
    final filePath = file.path;
    final lastIndex = filePath.lastIndexOf(RegExp(r'.png|.jp'));
    final splitted = filePath.substring(0, lastIndex);
    final outPath = '${splitted}_out${filePath.substring(lastIndex)}';

    XFile? compressedImage;

    if (lastIndex == filePath.lastIndexOf(RegExp(r'.png'))) {
      compressedImage = await FlutterImageCompress.compressAndGetFile(
          filePath, outPath,
          minWidth: imageWidth,
          minHeight: imageHeight,
          quality: 90,
          format: CompressFormat.png);

      return compressedImage;
    } else {
      compressedImage = await FlutterImageCompress.compressAndGetFile(
        filePath,
        outPath,
        quality: 90,
        minHeight: imageHeight,
        minWidth: imageWidth,
      );
      return compressedImage;
    }
  }

  Future<void> saveGallery(XFile file) async {
    final permission = await requestPhotosPermission();
    if (permission == PermissionStatus.denied ||
        permission == PermissionStatus.permanentlyDenied) {
      return;
    }
    final filePath = file.path;
    final lastIndex = filePath.lastIndexOf(RegExp(r'.png|.jp'));
    final splitted = filePath.substring(0, lastIndex);
    final outPath = '${splitted}_rsz${filePath.substring(lastIndex)}';

    final fileData = await file.readAsBytes();
    await SaverGallery.saveImage(
      fileData,
      name: outPath,
      androidExistNotSave: true,
    );
    // result.isSuccess
  }

  Future<XFile> resize(XFile file) async {
    final filePath = file.path;
    final lastIndex = filePath.lastIndexOf(RegExp(r'.png|.jp'));
    final splitted = filePath.substring(0, lastIndex);
    final outPath = '${splitted}_rsz${filePath.substring(lastIndex)}';
    final cmd = img.Command()
      // Decode the image file at the given path
      ..decodeImageFile(file.path)
      // Resize the image to a width of 64 pixels and a height that maintains the aspect ratio of the original.
      ..copyResize(
        width: 720,
        height: 1280,
        maintainAspect: true,
      )
      // Write the image to a PNG file (determined by the suffix of the file path).
      ..writeToFile(outPath);
    // On platforms that support Isolates, execute the image commands asynchronously on an isolate thread.
    // Otherwise, the commands will be executed synchronously.
    await cmd.executeThread();

    return XFile.fromData(File(outPath).readAsBytesSync(), path: outPath);
  }
}
