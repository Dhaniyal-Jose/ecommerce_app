import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../services/receipt_service.dart';
import 'reward_screen.dart'; // ✅ Redirect after receipt

class CheckoutScreen extends StatelessWidget {
  final Product? singleProduct;

  const CheckoutScreen({this.singleProduct, super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final isSingleBuy = singleProduct != null;

    final items = isSingleBuy
        ? [singleProduct!]
        : cart.items.map((e) => e.product).toList();

    final total = isSingleBuy
        ? singleProduct!.price
        : cart.totalPrice;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Order Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (ctx, i) {
                  final product = items[i];
                  final quantity = isSingleBuy ? 1 : cart.items[i].quantity;
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text('₹${product.price} x $quantity'),
                    trailing: Text('₹${(product.price * quantity).toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            const Divider(),
            Text(
              'Total: ₹${total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    // 1. Generate PDF
                    final pdfData = await ReceiptService.generateReceipt(
                      products: items,
                      total: total,
                      isSingleProduct: isSingleBuy,
                    );

                    // 2. Preview PDF
                    await Printing.layoutPdf(
                      onLayout: (format) async => pdfData,
                      name: 'receipt_preview.pdf',
                    );

                    // 3. Save PDF to app directory
                    final dir = await getExternalStorageDirectory();
                    if (dir == null) throw Exception("Storage not accessible");

                    final filePath = '${dir.path}/receipt_${DateTime.now().millisecondsSinceEpoch}.pdf';
                    final file = File(filePath);
                    await file.writeAsBytes(pdfData);

                    if (!isSingleBuy) cart.clearCart();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Receipt saved to:\n$filePath')),
                    );

                    // 4. Ask to share
                    final shouldShare = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Share Receipt?'),
                        content: const Text('Would you like to share this receipt now?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
                          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Share')),
                        ],
                      ),
                    );

                    if (shouldShare == true) {
                      await Share.shareXFiles(
                        [XFile(filePath)],
                        text: 'Here is your receipt from Flutter Cosmetics 🧾',
                      );
                    }

                    // 5. Redirect to Reward Screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const RewardScreen()),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                },
                child: const Text('Preview, Save & Share Receipt'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
