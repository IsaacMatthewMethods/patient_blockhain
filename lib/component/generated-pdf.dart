import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:patient_blockhain/component/pdfApi.dart';

import '../screen/user/user-pdf-model.dart';

class PdfInvoicApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();
    final kadpolyLogo = (await rootBundle.load(
      "img/logo1.png",
    )).buffer.asUint8List();

    final barcode = (await rootBundle.load(
      "img/barcode.png",
    )).buffer.asUint8List();

    final sign = (await rootBundle.load("img/sign.png")).buffer.asUint8List();

    pdf.addPage(
      MultiPage(
        build: (context) => [
          //  g = pdf.getGraphics();
          buildTitle(
            invoice,
            Image(MemoryImage(kadpolyLogo), width: 40, height: 40),
            Image(MemoryImage(barcode), width: 100, height: 40),
            Image(MemoryImage(sign), width: 100, height: 100),
          ),
        ],
      ),
    );

    return PdfApi.saveDocument(name: "Donation | Receipt.pdf", pdf: pdf);
  }

  static Widget buildTitle(Invoice invoice, kadpoly, barcode, sign) => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              kadpoly,
              Column(
                children: [
                  Text(
                    "FOOD DONATION",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: PdfColors.green,
                    ),
                  ),
                  Text("Payment Receipt Successful"),
                ],
              ),
              barcode,
            ],
          ),

          // Divider(),
          Divider(),
          Text("Thank you for your generous donation!"),
          Text(
            "We are deeply grateful for your compassion and commitment to making the world a better place. Together, we can achieve amazing things.",
          ),
          Text(
            "\nThank you once again for your valuable donation. \nYou're a true hero in our eyes!",
          ),
          Text("\nWith heartfelt gratitude, \nFOOD DONATION"),
          SizedBox(height: 15.0),
          Align(
            alignment: Alignment.topRight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Receipt No.: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  invoice.passenger.reciept,
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ],
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Donor name : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(invoice.passenger.name, style: TextStyle()),
            ],
          ),
          Divider(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Donation Method: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(invoice.passenger.payment_type, style: TextStyle()),
                ],
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Donor email : ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(invoice.passenger.email, style: TextStyle()),
                ],
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Amount paid (#): ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "NGN ${invoice.passenger.amount}",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Status : ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(invoice.passenger.status, style: TextStyle()),
                ],
              ),
            ],
          ),

          Divider(),
          Row(
            children: [
              Text(
                "Payment Date : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                invoice.passenger.dates,
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ],
          ),
          Divider(),

          SizedBox(height: 45.0),

          Center(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                sign,
                Container(width: 120, height: 1.0, color: PdfColors.black),
                Text(
                  "Kamal yahaya",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                Text(
                  "Donation Chairman",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.0),
        ],
      ),
    ],
  );
}
