import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart';
import 'package:patient_blockhain/component/Invoice.dart';
import 'package:patient_blockhain/component/pdfApi.dart';

class PdfInvoicApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    final imageUrl = (await rootBundle.load(
      "img/logo.webp",
    )).buffer.asUint8List();

    pdf.addPage(MultiPage(build: (context) => [Image(MemoryImage(imageUrl))]));

    return PdfApi.saveDocument(name: "E-Ticket | Receipt.pdf", pdf: pdf);
  }
}
