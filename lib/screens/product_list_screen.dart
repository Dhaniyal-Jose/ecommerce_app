import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../widgets/product_tile.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'otp_login_screen.dart'; // for redirect after logout


class ProductListScreen extends StatelessWidget {
   
  final List<Product> products = [
    Product(
      id: '1',
      name: 'Wireless Bluetooth Earbuds',
      price: 499.0,
      image: 'assets/images/1.jpg',
      description:
          'Enjoy crisp, clear sound and wireless freedom with Bluetooth 5.3 earbuds. Comes with a compact charging case offering up to 50 hours of battery life. Great for calls, workouts, and commuting.',
    ),
    Product(
      id: '2',
      name: 'Smartwatch',
      price: 299.0,
      image: 'assets/images/2.jpg',
      description:
          'Track your fitness, monitor heart rate, and receive app notifications on your wrist. This smartwatch supports multiple sport modes and syncs seamlessly with Android and iOS devices.',
    ),
    Product(
      id: '3',
      name: 'Portable Bluetooth Speaker',
      price: 799.0,
      image: 'assets/images/3.jpeg',
      description:
          'Small but powerful, this speaker offers loud, high-quality audio and deep bass. Features include Bluetooth 5.0, 10-hour battery, and water resistance—ideal for outdoor gatherings or travel.',
    ),
    Product(
      id: '4',
      name: ' Wireless Charging Pad',
      price: 349.0,
      image: 'assets/images/4.jpeg',
      description:
          'Effortlessly charge your smartphone or wireless earbuds without plugging in cables. Sleek, lightweight, and supports fast-charging for compatible devices. Perfect for home or office use.',
    ),
    Product(
      id: '5',
      name: ' USB-C Hub Adapter',
      price: 259.0,
      image: 'assets/images/5.jpg',
      description:
          'Expand your laptop’s ports instantly. Features HDMI output, USB 3.0 ports, SD card reader, and USB-C power input for multitasking on the go.',
    ),
    Product(
      id: '6',
      name: 'Smart Home Security Camera',
      price: 399.0,
      image: 'assets/images/6.jpeg',
      description:
          'Protect your home with real-time motion alerts, HD video streaming, and two-way audio. Night vision and remote viewing supported via mobile app.',
    ),
    Product(
      id: '7',
      name: 'Noise-Canceling Headphones',
      price: 279.0,
      image: 'assets/images/7.jpeg',
      description:
          'Block out distractions and enjoy immersive sound with these over-ear headphones. Features include active noise cancellation, 40-hour battery, and comfortable ear cushions.',
    ),
    Product(
      id: '8',
      name: '4K Action Camera',
      price: 199.0,
      image: 'assets/images/8.jpeg',
      description:
          'Capture high-resolution video and photos on the go. Waterproof up to 30 meters with a rugged design and multiple mounting accessories.',
    ),
    Product(
      id: '9',
      name: 'Mini Projector',
      price: 349.0,
      image: 'assets/images/9.jpg',
      description:
          'Transform any room into a home theater. Projects up to 150" display, supports HDMI/USB/AV input, and compatible with smartphones, laptops, and gaming consoles.',
    ),
    Product(
      id: '10',
      name: 'Fitness Tracker Band',
      price: 599.0,
      image: 'assets/images/10.jpeg',
      description:
          'Lightweight fitness band with heart rate monitor, step counter, sleep analysis, and call/message notifications. Waterproof and USB rechargeable. Ideal for daily fitness tracking and health monitoring.',
    ),
    Product(
      id: '11',
      name: 'Power Bank (10,000 mAh)',
      price: 499.0,
      image: 'assets/images/11.jpg',
      description:
          'Reliable portable charger with dual USB output. Slim profile fits easily in a bag or pocket—ideal for travel or daily backup power.',
    ),
    Product(
      id: '12',
      name: 'Wireless Keyboard and Mouse Combo',
      price: 129.0,
      image: 'assets/images/12.jpg',
      description:
          'Stylish, full-sized keyboard and ergonomic mouse set with 2.4GHz wireless connection. Silent keys and adjustable DPI mouse for productivity.',
    ),
    Product(
      id: '13',
      name: 'Laptop Cooling Pad',
      price: 699.0,
      image: 'assets/images/13.jpg',
      description:
          'Keep your laptop cool with this USB-powered stand featuring multiple fans and adjustable height for ergonomic typing and gaming. Ideal for long work sessions or gaming marathons.',
    ),
    Product(
      id: '14',
      name: 'Smart Light Bulb',
      price: 259.0,
      image: 'assets/images/14.jpg',
      description:
          'Control light color, brightness, and schedule via app or voice assistant. Supports millions of colors and white temperature adjustment.',
    ),
    Product(
      id: '15',
      name: ' Digital Drawing Tablet',
      price: 349.0,
      image: 'assets/images/15.jpg',
      description:
          'Perfect for artists and designers. Comes with a pressure-sensitive pen and customizable buttons. Works with Windows and macOS. Ideal for digital art, sketching, and photo editing.',
    ),
    Product(
      id: '16',
      name: 'Webcam 1080p',
      price: 199.0,
      image: 'assets/images/16.jpeg',
      description:
          'Upgrade your video conferencing with this high-definition webcam featuring a wide-angle lens and noise-reducing mic.',
    ),
    Product(
      id: '17',
      name: 'VR Headset for Smartphone',
      price: 299.0,
      image: 'assets/images/17.jpg',
      description:
          'Turn your phone into a virtual reality device. Enjoy immersive games and 3D videos with adjustable lenses and head strap.',
    ),
    Product(
      id: '18',
      name: 'Car Dash Camera',
      price: 899.0,
      image: 'assets/images/18.jpg',
      description:
          'Automatically records your drives in full HD. Includes loop recording, night vision, and G-sensor for collision detection.',
    ),
    Product(
      id: '19',
      name: 'Smart Plug',
      price: 249.0,
      image: 'assets/images/19.jpg',
      description:
          'Control appliances remotely, set timers, and monitor usage with this voice-compatible smart plug. Works with Alexa & Google Assistant.',
    ),
    Product(
      id: '20',
      name: 'Streaming Microphone (USB)',
      price: 349.0,
      image: 'assets/images/20.jpg',
      description:
          'Professional-quality mic with plug-and-play USB connection. Includes pop filter, adjustable stand, and cardioid pattern for clear sound.',
    ),
  ];

   ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Electronic Devices'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const OtpLoginScreen()),
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
              if (cart.items.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cart.totalItems.toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) =>
            ProductTile(product: products[index]),
      ),
    );
  }
}