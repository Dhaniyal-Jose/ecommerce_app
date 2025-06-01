import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/screens/product_list_screen.dart';
import 'scratch_card_screen.dart'; // or use the correct relative path
import 'package:flutter_ecommerce_app/screens/scratch_card_screen.dart';

class OtpLoginScreen extends StatefulWidget {
  const OtpLoginScreen({super.key});

  @override
  State<OtpLoginScreen> createState() => _OtpLoginScreenState();
}

class _OtpLoginScreenState extends State<OtpLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _otpSent = false;
  bool _isVerifying = false;
  int _secondsRemaining = 0;
  String _generatedOtp = '';
  Timer? _timer;

  void _startTimer() {
    _secondsRemaining = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  String _generateRandomOtp() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString(); // 6-digit OTP
  }

  void _sendOtp() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid 10-digit phone number")),
      );
      return;
    }

    _generatedOtp = _generateRandomOtp();

    setState(() {
      _otpSent = true;
    });

    _startTimer();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Fake OTP sent: $_generatedOtp")),
    );
  }

  void _verifyOtp() {
    setState(() {
      _isVerifying = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isVerifying = false;
      });

      if (_otpController.text.trim() == _generatedOtp) {
  // Assuming all OTP logins are "new" for now
  bool isNewUser = true; // You can later store actual user info

  if (isNewUser) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ScratchCardScreen(
          productList: ProductListScreen().products.map((product) => {
            'id': product.id,
            'name': product.name,
            'price': product.price,
            'image': product.image,
            'description': product.description,
          }).toList(),
        ),
      ),
    );
  } else {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => ProductListScreen()),
    );
  }
}
else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid OTP")),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OTP Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!_otpSent) ...[
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _sendOtp,
                child: const Text('Send OTP'),
              ),
            ] else ...[
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Enter OTP'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isVerifying ? null : _verifyOtp,
                child: _isVerifying
                    ? const CircularProgressIndicator()
                    : const Text('Verify OTP'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _secondsRemaining == 0 ? _sendOtp : null,
                child: Text(
                  _secondsRemaining == 0
                      ? 'Resend OTP'
                      : 'Resend OTP in $_secondsRemaining sec',
                ),
              ),
            ],
            // After OTP login success


            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) =>  ProductListScreen()),
                );
              },
              child: const Text('Skip Login'),
            ),
          ],
        ),
      ),
    );
  }
}
