import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:injectable/injectable.dart';
import 'package:tv_randshow/core/io/domain/interfaces/manage_files_service.dart';

@LazySingleton(as: IManageFilesService)
class SaveFileService extends IManageFilesService {
  @override
  Future<String> saveFile(String fileName, String json) async {
    return FileSaver.instance.saveFile(
      fileName,
      Uint8List.fromList(json.codeUnits),
      'json',
      mimeType: MimeType.JSON,
    );
  }
}
