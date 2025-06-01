# flutter_ecommerce_fixed

This is a complete Flutter-based e-commerce mobile application designed as part of a machine test. The app includes user login via OTP, a product catalog, shopping cart functionality, scratch card rewards for new users, PDF receipt generation, and clean UI transitions powered by Flutter animations.

Features

✅ OTP Login 
✅ Product Catalog 
✅ Cart Functionality with Add/Remove & Total Price Calculation
✅ Checkout with PDF Invoice Generation
✅ Scratch Card Reward for First-time Users
✅ Responsive UI 

## 🛠️ Tech Stack

- **Framework:** Flutter (Dart)
- **OTP:** Fake/random OTP generator
- **PDF Generation:** `pdf` and `printing` packages
- **State Management:** `Provider`
- **Local Storage:** `path_provider`, `permission_handler`

---

## 📁 Project Structure

```
lib/
├── main.dart
├── models/
│   └── product_model.dart
├── screens/
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── home_screen.dart
│   ├── product_details.dart
│   ├── cart_screen.dart
│   ├── checkout_screen.dart
│   └── scratch_card_screen.dart
├── widgets/
│   ├── product_tile.dart
│   ├── scratch_card_widget.dart
│   └── cart_item.dart
├── services/
│   ├── auth_service.dart
│   ├── fake_otp_service.dart
│   └── pdf_generator.dart
```

---

## 🧪 How to Run

### Prerequisites
- Flutter SDK installed
- Android/iOS Emulator or device

### Steps

1. **Clone or extract project**  
   ```bash
   git clone <https://github.com/Anitta24/ecommerce_app>
   cd ecommerce_app
   ```

2. **Install dependencies**  
   ```bash
   flutter pub get
   ```

3. **Run app**  
   ```bash
   flutter run
   ```

---

## 📝 Note

- The OTP authentication is simulated using a fake random OTP. There is no backend or Firebase integration.
- Scratch card appears only once after registration and will not reappear on relaunch.
- PDF receipt is stored locally with a timestamped filename.

---

## 📄 License

This app was developed for educational and demonstration purposes only as part of a technical assessment.

---

## 👨‍💻 Author

Submitted for: **WHITE MATRIX Solutions**, Infopark, Thrissur  


