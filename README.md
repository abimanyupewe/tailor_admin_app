# Tailor Admin App

Aplikasi administrasi berbasis Flutter yang komprehensif, dirancang untuk penjahit agar dapat mengelola operasional bisnis mereka secara efisien. Aplikasi ini memfasilitasi pengelolaan pesanan, katalog layanan, pengaturan lokasi toko, pameran portofolio, dan pengelolaan profil.

## Fitur

- **Manajemen Pesanan**: Melihat dan mengelola pesanan pelanggan, termasuk pembaruan status dan informasi detail pesanan.
- **Manajemen Layanan**: Menambah, mengedit, dan menghapus layanan jahit dengan detail harga dan durasi.
- **Portofolio**: Menampilkan contoh hasil karya dengan unggahan gambar dan deskripsi.
- **Lokasi Toko**: Mengelola alamat toko dan koordinat geolokasi (Latitude/Longitude) dengan integrasi peta.
- **Manajemen Profil**: Memperbarui informasi pribadi dan toko, termasuk avatar dan foto sampul.
- **Dashboard**: Ringkasan statistik bisnis, termasuk pendapatan, pesanan tertunda, dan aktivitas terbaru.
- **Autentikasi**: Sistem login aman untuk administrator.

## Struktur Proyek

Proyek ini mengikuti pola arsitektur bersih (clean architecture) menggunakan GetX untuk manajemen state.

```
lib/
├── bindings/       # Binding injeksi dependensi
├── constants/      # Konstanta aplikasi (warna, string)
├── controllers/    # Logika bisnis dan manajemen state
├── data/           # Layer data (layanan API, model)
├── models/         # Model data dan serialisasi JSON
├── routes/         # Konfigurasi routing aplikasi
├── screens/        # Layar UI dan Halaman
│   ├── auth/       # Layar Login dan Autentikasi
│   ├── dashboard/  # Dashboard dan layar Ringkasan
│   ├── location/   # Manajemen lokasi toko
│   ├── orders/     # Daftar dan detail pesanan
│   ├── portfolio/  # Manajemen portofolio
│   ├── profile/    # Profil pengguna dan pengaturan
│   ├── services/   # Manajemen katalog layanan
│   └── splash/     # Layar pembuka (splash screen)
├── widgets/        # Komponen UI yang dapat digunakan kembali
└── main.dart       # Titik masuk aplikasi
```

## Pengaturan dan Instalasi

### Prasyarat

- Flutter SDK (versi stabil terbaru disarankan)
- Dart SDK
- Android Studio / Xcode (untuk pengembangan seluler)

### Dependensi

Proyek ini bergantung pada paket-paket utama berikut:

- **get**: Manajemen state, injeksi dependensi, dan manajemen rute.
- **http**: Untuk melakukan permintaan API.
- **shared_preferences**: Untuk penyimpanan data lokal (persistensi sesi).
- **google_fonts**: Tipografi kustom (Plus Jakarta Sans).
- **iconsax**: Paket ikon modern.
- **flutter_map** & **latlong2**: Untuk fungsionalitas peta.
- **geolocator**: Untuk mengambil lokasi perangkat.
- **image_picker**: Untuk memilih gambar dari galeri/kamera.
- **url_launcher**: Untuk membuka URL eksternal (panggilan telepon, peta).
- **intl**: Untuk pemformatan tanggal dan angka.

### Menjalankan Aplikasi

1.  **Clone repositori**
2.  **Instal dependensi**:
    ```bash
    flutter pub get
    ```
3.  **Jalankan aplikasi**:
    ```bash
    flutter run
    ```

## Konfigurasi

- **Variabel Lingkungan**: Konfigurasikan URL dasar API Anda di `.env` (jika ada) atau `api_service.dart`.
- **Ikon Aplikasi**: Ikon peluncur dapat dibuat ulang menggunakan perintah:
    ```bash
    dart run flutter_launcher_icons
    ```

## Pengembangan

Proyek ini menggunakan `flutter_lints` untuk analisis kode. Pastikan kode Anda mematuhi aturan linting sebelum melakukan commit.

## Lisensi

Pribadi / Proprietary
