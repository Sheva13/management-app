#  FinansialKu

**Aplikasi manajemen keuangan pribadi offline untuk Android.**

---

##  Fitur Utama

###  Dashboard
- **Sidebar navigasi** dengan desain glassmorphism yang elegan
- **Ringkasan keuangan real-time** — total pemasukan, pengeluaran, dan saldo
- **Back button** → halaman lain kembali ke dashboard, double-tap untuk keluar aplikasi

###  Transaksi
- Catat **pemasukan** dan **pengeluaran** harian
- Pemasukan **tidak wajib pakai kategori** — lebih fleksibel
- Filter & cari transaksi dengan mudah
- Tampilkan berdasarkan tanggal, platform, atau money type

###  Kategori & Platform
- **Kategori** untuk mengelompokkan pengeluaran (makanan, transportasi, dll)
- **Platform** — sumber dana (tunai, rekening bank, e-wallet)
- **Money Type** — jenis mata uang/penyimpanan

###  Anggaran (Budget)
- Tetapkan **budget per kategori** per bulan
- **Pelacakan real-time** — budget otomatis update saat transaksi ditambahkan
- **Notifikasi otomatis** saat budget terlampaui
- **Auto-rollforward** budget ke bulan baru secara otomatis di tanggal 1
- **Budget History** — lihat riwayat budget bulan sebelumnya
- **Budget Category Detail** — detail transaksi per kategori dengan search & sort

###  Database Lokal
- Menggunakan **Drift** (SQLite) sebagai database offline
- **Full database backup & restore** — ekspor/impor database ke file `.sqlite`
- **Otomatis backup** terjadwal (harian, mingguan, atau bulanan)
- **Auto-restore** — otomatis mendeteksi backup saat aplikasi dibuka kembali
- Cadangan tersimpan di folder **Downloads/FinansialKu/** yang mudah diakses

###  Statistik
- **Grafik pengeluaran** berdasarkan kategori
- **Tren keuangan** bulanan
- Lihat pola keuangan dari waktu ke waktu

---

##  Tech Stack

| Teknologi | Keterangan |
|-----------|------------|
| **Flutter** | UI Framework |
| **Drift** | SQLite ORM (type-safe, reactive) |
| **Riverpod** | State management |
| **Freezed** | Immutable data models |
| **Hive** | Key-value storage untuk settings |
| **Workmanager** | Background task scheduling |
| **Google Fonts** | Custom typography (Outfit + Inter) |
| **Fl Chart** | Grafik interaktif |

---

##  Screenshots

> Screenshot akan ditambahkan setelah testing di device

---

##  Getting Started

### Prerequisites
- Flutter SDK >= 3.x
- Android SDK (compileSdk 36)
- JDK 17

### Install

```bash
# Clone repository
git clone https://github.com/Sheva13/management-app.git
cd management-app

# Install dependencies
flutter pub get

# Generate code (Drift + Freezed)
dart run build_runner build --delete-conflicting-outputs

# Run on device/emulator
flutter run
```

### Build APK

```bash
flutter build apk --release
```

APK akan tersedia di `build/app/outputs/flutter-apk/app-release.apk`

---

##  Struktur Proyek

```
lib/
├── main.dart                          # Entry point
├── app.dart                           # Root widget & theme
├── core/
│   ├── constants/
│   │   ├── app_colors.dart            # Warna aplikasi
│   │   ├── app_text_styles.dart       # Typography
│   │   └── app_sizes.dart             # Dimensi & spacing
│   ├── services/
│   │   ├── backup_service.dart        # Backup/restore database
│   │   ├── backup_worker.dart         # Scheduled backup tasks
│   │   └── budget_worker.dart         # Auto-rollforward budget
│   └── utils/
│       └── currency_utils.dart        # Format rupiah
├── database/
│   ├── app_database.dart              # Drift database config
│   ├── tables/
│   │   ├── transactions_table.dart    # Transaksi (nullable categoryId)
│   │   ├── budgets_table.dart         # Budget per kategori
│   │   ├── categories_table.dart      # Kategori pengeluaran
│   │   ├── money_types_table.dart     # Jenis uang
│   │   └── platforms_table.dart       # Platform transaksi
│   └── daos/                          # Data Access Objects
│       ├── transaction_dao.dart
│       ├── budget_dao.dart
│       ├── category_dao.dart
│       ├── money_type_dao.dart
│       └── platform_dao.dart
├── models/                            # Freezed data classes
│   ├── transaction.dart
│   ├── budget.dart
│   ├── budget_with_category.dart
│   ├── category.dart
│   └── ...
├── providers/                         # Riverpod providers
│   ├── database_provider.dart
│   ├── budget_provider.dart
│   ├── transaction_provider.dart
│   ├── category_provider.dart
│   └── backup_provider.dart
├── screens/
│   ├── home/
│   │   └── home_screen.dart           # Dashboard utama
│   ├── transaction/
│   │   ├── transaction_screen.dart    # Daftar transaksi
│   │   └── add_transaction_screen.dart
│   ├── budget/
│   │   ├── budget_screen.dart         # Anggaran bulanan
│   │   ├── budget_history_screen.dart # Riwayat budget
│   │   └── budget_category_detail_screen.dart
│   ├── statistic/
│   │   └── statistic_screen.dart
│   └── settings/
│       └── widgets/
│           ├── backup_settings_section.dart
│           └── restore_confirm_dialog.dart
└── widgets/
    ├── glassy_sidebar.dart            # Sidebar glassmorphism
    ├── budget_progress_card.dart      # Card budget real-time
    └── ...
```

---

##  Konfigurasi

### Backup & Restore
- **Lokasi backup:** `Downloads/FinansialKu/`
- **Format file:** `.sqlite` (SQLite database)
- **Maks cadangan:** 6 file terbaru
- **Auto-backup:** Setiap hari / minggu / bulan (atur di Settings)
- **Restore:** Buka file `.sqlite` dari file manager manapun

### Budget Auto-Rollforward
- Otomatis menyalin budget dari bulan sebelumnya saat memasuki bulan baru (tanggal 1)
- Budget per kategori tetap sama kecuali diubah manual

---

##  Database Schema (v7)

| Tabel | Keterangan |
|-------|------------|
| `transactions` | Transaksi keuangan (categoryId nullable untuk pemasukan) |
| `categories` | Kategori pengeluaran |
| `money_types` | Jenis penyimpanan uang |
| `platforms` | Platform transaksi |
| `budgets` | Budget per kategori per bulan |
| `transaction_logs` | Log perubahan transaksi |

---

##  Contributing

1. Fork repository
2. Buat branch fitur (`git checkout -b fitur/nama-fitur`)
3. Commit (`git commit -m 'Tambah fitur xyz'`)
4. Push (`git push origin fitur/nama-fitur`)
5. Buka Pull Request

---

##  License

Proyek pribadi — tidak untuk distribusi publik.

---

