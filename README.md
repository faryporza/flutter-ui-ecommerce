# E-commerce Flutter App

แอปพลิเคชัน E-commerce ที่สร้างด้วย Flutter พร้อมดีไซน์ที่สวยงามและใช้งานง่าย

## ✨ คุณสมบัติ

- 🏠 **หน้าแรก** - แสดงสินค้าแนะนำและหมวดหมู่สินค้า
- 🔍 **ค้นหาสินค้า** - ค้นหาสินค้าด้วยชื่อ หรือหมวดหมู่
- ❤️ **รายการโปรด** - เก็บสินค้าที่ชอบไว้ดูภายหลัง
- 🛒 **ตะกร้าสินค้า** - เพิ่มสินค้าลงตะกร้าและจัดการจำนวน
- 👤 **โปรไฟล์** - ข้อมูลผู้ใช้และการตั้งค่า

## 🎨 ธีม

- **Minimal Design** - ดีไซน์เรียบง่าย สะอาดตา
- **สีธีม** - ใช้โทนสีเทาและขาวที่นุ่มนวล
- **Typography** - ฟอนต์น้ำหนักเบาสำหรับลุคที่ทันสมัย

## 🛠️ เทคโนโลยี

- **Flutter** - Framework หลัก
- **Riverpod** - State Management
- **Go Router** - Navigation
- **Mock JSON** - ข้อมูลจำลองสำหรับการพัฒนา

## 📁 โครงสร้างโปรเจกต์

```
lib/
├── app/                    # การตั้งค่าแอป
│   ├── app.dart           # App widget หลัก
│   └── router.dart        # การจัดการ routing
├── features/              # ฟีเจอร์ต่างๆ
│   ├── auth/             # Authentication
│   ├── cart/             # ตะกร้าสินค้า
│   ├── home/             # หน้าแรก
│   └── product/          # สินค้า
├── model/                # Data models
│   ├── product.dart      # โมเดลสินค้า
│   └── user.dart         # โมเดลผู้ใช้
├── services/             # บริการต่างๆ
│   └── mock_data_service.dart
├── state/                # State management
│   └── mock_providers.dart
├── theme/                # ธีมและสไตล์
│   ├── app_theme.dart    # การตั้งค่าธีม
│   ├── colors.dart       # สีต่างๆ
│   └── text_styles.dart  # สไตล์ข้อความ
└── widgets/              # Widget ที่ใช้ร่วมกัน
    ├── bottom_nav.dart   # Navigation bar
    ├── custom_app_bar.dart
    └── product_card.dart # การ์ดสินค้า
```

## 🚀 วิธีการรันโปรเจกต์

### ข้อกำหนดเบื้องต้น

- Flutter SDK (3.8.0 หรือใหม่กว่า)
- Dart SDK
- Android Studio หรือ VS Code
- Emulator หรืออุปกรณ์จริง

### การติดตั้ง

1. **Clone โปรเจกต์**
   ```bash
   git clone <repository-url>
   cd test
   ```

2. **ติดตั้ง dependencies**
   ```bash
   flutter pub get
   ```

3. **ตรวจสอบ Flutter Doctor**
   ```bash
   flutter doctor
   ```

4. **รันแอป**
   ```bash
   flutter run
   ```

## 📊 ข้อมูลจำลอง (Mock Data)

โปรเจกต์ใช้ข้อมูลจำลองจากไฟล์ JSON ใน `assets/data/`:

- **products.json** - ข้อมูลสินค้า
- **users.json** - ข้อมูลผู้ใช้
- **categories.json** - หมวดหมู่สินค้า

### ตัวอย่างข้อมูลสินค้า
```json
{
  "id": "1",
  "name": "iPhone 15 Pro",
  "price": 999.99,
  "category": "Electronics",
  "rating": 4.8,
  "discountPercentage": 10
}
```

## 🎯 การใช้งาน

### การค้นหาสินค้า
- พิมพ์ชื่อสินค้าในช่องค้นหา
- เลือกหมวดหมู่ที่ต้องการ
- ดูผลการค้นหาแบบ real-time

### การจัดการรายการโปรด
- กดไอคอนหัวใจที่การ์ดสินค้า
- ดูรายการโปรดในแท็บ Favorites
- ลบรายการโปรดได้ทุกเมื่อ

### การจัดการตะกร้า
- เพิ่มสินค้าลงตะกร้า
- ปรับจำนวนสินค้า
- ลบสินค้าออกจากตะกร้า
- ดูยอดรวมแบบ real-time

## 🎨 การปรับแต่งธีม

### สี
แก้ไขไฟล์ `lib/theme/colors.dart`:
```dart
static const Color primary = Color(0xFF2D3748);
static const Color grey100 = Color(0xFFF7FAFC);
```

### ฟอนต์
แก้ไขไฟล์ `lib/theme/text_styles.dart`:
```dart
static const TextStyle titleLarge = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
);
```

## 📱 หน้าจอต่างๆ

1. **Home** - หน้าแรกพร้อมสินค้าแนะนำ
2. **Search** - ค้นหาและกรองสินค้า
3. **Favorites** - รายการสินค้าที่ชอบ
4. **Cart** - ตะกร้าสินค้าและการชำระเงิน
5. **Profile** - ข้อมูลส่วนตัวและการตั้งค่า

## 🔧 การพัฒนาต่อ

### เพิ่มฟีเจอร์ใหม่
1. สร้างโฟลเดอร์ใหม่ใน `lib/features/`
2. เพิ่ม routes ใน `lib/app/router.dart`
3. สร้าง providers ใน `lib/state/`

### เชื่อมต่อ API จริง
1. แทนที่ `MockDataService` ด้วย HTTP calls
2. อัพเดท providers ให้ใช้ API endpoints
3. จัดการ error handling และ loading states

## 🤝 การมีส่วนร่วม

1. Fork โปรเจกต์
2. สร้าง feature branch (`git checkout -b feature/new-feature`)
3. Commit การเปลี่ยนแปลง (`git commit -m 'Add new feature'`)
4. Push ไปยัง branch (`git push origin feature/new-feature`)
5. สร้าง Pull Request

