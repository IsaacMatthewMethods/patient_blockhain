import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:open_file/open_file.dart';

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
   await getApplicationDocumentsDirectory();
    // final file = OpenFile.open('${dir.path}/$name');

    final path = (await getExternalStorageDirectory())!.path;
    final file = File('$path/$name');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/$name');

    return file;
  }
}
