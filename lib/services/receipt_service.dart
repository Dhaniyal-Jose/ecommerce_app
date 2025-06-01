import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/product.dart';

class ReceiptService {
  static Future<Uint8List> generateReceipt({
    required List<Product> products,
    required double total,
    required bool isSingleProduct,
  }) async {
    final pdf = pw.Document();
    final date = DateTime.now();
    final transactionId = 'TXN-${date.millisecondsSinceEpoch}';
    final formattedDate = DateFormat('yyyy-MM-dd – HH:mm').format(date);

    // Load logo
    final logoBytes = await rootBundle.load('assets/images/logo.png');
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

    // Generate QR data
    final qrData = 'Transaction ID: $transactionId\nDate: $formattedDate\nTotal: ₹${total.toStringAsFixed(2)}';

    final qrCode = pw.BarcodeWidget(
      data: qrData,
      barcode: pw.Barcode.qrCode(),
      width: 80,
      height: 80,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Image(logoImage, width: 100),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Flutter Cosmetics Receipt',
                      style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 24),
              pw.Text('Transaction ID: $transactionId', style: const pw.TextStyle(fontSize: 12)),
              pw.Text('Date: $formattedDate', style: const pw.TextStyle(fontSize: 12)),
              pw.Divider(),

              pw.SizedBox(height: 12),
              pw.Text('Items:', style:  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),

              pw.Column(
                children: products.map((p) {
                  final quantity = isSingleProduct ? 1 : products.where((x) => x.id == p.id).length;
                  return pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(child: pw.Text(p.name, style: const pw.TextStyle(fontSize: 12))),
                      pw.Text('x $quantity', style: const pw.TextStyle(fontSize: 12)),
                      pw.Text('₹${(p.price * quantity).toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 12)),
                    ],
                  );
                }).toList(),
              ),

              pw.Divider(),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text('Total: ₹${total.toStringAsFixed(2)}',
                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                ),
              ),

              pw.SizedBox(height: 24),
              pw.Text('Scan for receipt details:', style: const pw.TextStyle(fontSize: 12)),
              pw.SizedBox(height: 8),
              qrCode,
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Text('Thank you for shopping with us!',
                  style: const pw.TextStyle(fontSize: 12)),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
