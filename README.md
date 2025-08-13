# Market - E-commerce Flutter App

Bu layihə Flutter ilə yaradılmış tam funksional e-commerce mobil tətbiqidir. Material Design istifadə edərək, Provider state management ilə hazırlanmışdır.

## Xüsusiyyətlər

### 🏠 Ana Səhifə (HomePage)
- Məhsulların grid görünüşündə siyahısı
- Axtarış funksiyası
- Kateqoriya filtri
- Məhsul kartları ilə əsas məlumatlar

### 📱 Məhsul Detalları (ProductDetailPage)
- Məhsul haqqında ətraflı məlumat
- Böyük şəkil görünüşü
- Qiymət və reytinq məlumatları
- Səbətə əlavə etmə funksiyası
- Miqdar tənzimləmə

### 🛒 Səbət (CartPage)
- Səbətdəki məhsulların siyahısı
- Miqdar dəyişdirmə
- Məhsul silmə
- Ümumi məbləğ hesablaması
- Səbəti təmizləmə

### 💳 Ödəniş (CheckoutPage)
- Sifariş xülasəsi
- Müştəri məlumatları formu
- Ödəniş üsulu seçimi
- Sifariş təsdiqləmə

### 👤 Profil (ProfilePage)
- İstifadəçi girişi
- Profil məlumatları redaktəsi
- Səbət məlumatları
- Çıxış funksiyası

## Texniki Xüsusiyyətlər

### State Management
- **Provider** istifadə edilərək state management
- CartProvider - səbət məlumatları
- ProductProvider - məhsul məlumatları
- UserProvider - istifadəçi məlumatları

### Data Models
- `Product` - məhsul məlumatları
- `CartItem` - səbət elementi
- `User` - istifadəçi məlumatları

### Dependencies
```yaml
provider: ^6.1.1          # State management
http: ^1.1.0              # HTTP requests
shared_preferences: ^2.2.2 # Local storage
cached_network_image: ^3.3.0 # Image loading
font_awesome_flutter: ^10.6.0 # Icons
```

## Quraşdırma

1. Layihəni klonlayın:
```bash
git clone <repository-url>
cd market
```

2. Dependencies-ləri yükləyin:
```bash
flutter pub get
```

3. Tətbiqi işə salın:
```bash
flutter run
```

## Test Məlumatları

Tətbiqdə test üçün aşağıdakı məlumatlar mövcuddur:

**Giriş məlumatları:**
- Email: `test@example.com`
- Şifrə: `password`

**Mock Məhsullar:**
- iPhone 15 Pro - ₼2999.99
- Samsung Galaxy S24 - ₼1899.99
- MacBook Pro M3 - ₼2499.99
- və s.

## Layihə Strukturu

```
lib/
├── main.dart                 # Əsas tətbiq faylı
├── models/                   # Data modelləri
│   ├── product.dart
│   ├── cart_item.dart
│   └── user.dart
├── providers/                # State management
│   ├── product_provider.dart
│   ├── cart_provider.dart
│   └── user_provider.dart
├── pages/                    # Səhifələr
│   ├── home_page.dart
│   ├── product_detail_page.dart
│   ├── cart_page.dart
│   ├── checkout_page.dart
│   └── profile_page.dart
└── widgets/                  # Ümumi widget-lər
    ├── product_card.dart
    └── cart_item_card.dart
```

## Xüsusiyyətlər

- ✅ Material Design UI
- ✅ Provider State Management
- ✅ Local Storage (SharedPreferences)
- ✅ Image Caching
- ✅ Responsive Design
- ✅ Form Validation
- ✅ Error Handling
- ✅ Loading States
- ✅ Navigation
- ✅ Bottom Navigation Bar

## Gələcək Təkmilləşdirmələr

- [ ] Backend API inteqrasiyası
- [ ] Push notifications
- [ ] Payment gateway inteqrasiyası
- [ ] Offline mode
- [ ] Multi-language support
- [ ] Dark mode
- [ ] Wishlist funksiyası
- [ ] Order history
- [ ] Product reviews
- [ ] Social media sharing

## Təşəkkür

Bu layihə Flutter və Provider istifadə edərək yaradılmışdır. Material Design prinsiplərinə uyğun olaraq hazırlanmışdır.
