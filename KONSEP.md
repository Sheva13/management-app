# 💰 FinansialKu — Aplikasi Manajemen Keuangan Pribadi

> Aplikasi desktop & mobile untuk mengontrol penuh keuangan pribadi.
> Aplikasi ini untuk penggunaan pribadiku, dimana aku bisa menginput yang aku belanjakan dan barang yang aku beli bisa aku masukkan per kategori.
> Dibangun dengan **Flutter + Drift + Riverpod**, berjalan lokal tanpa server.

---

## 📋 Daftar Isi

1. [Tentang Proyek](#tentang-proyek)
2. [Tech Stack & Fungsi](#tech-stack--fungsi)
3. [Desain UI/UX](#desain-uiux)
4. [Struktur File & Folder](#struktur-file--folder)
5. [Fitur Aplikasi](#fitur-aplikasi)
6. [Larangan Keras](#larangan-keras)
7. [Yang Dibolehkan & Tidak Dibolehkan](#yang-dibolehkan--tidak-dibolehkan)
8. [Pengembangan Kedepannya](#pengembangan-kedepannya)
9. [Cara Memulai](#cara-memulai)
10. [Aturan Kode](#aturan-kode)
11. [Catatan Penting](#catatan-penting)

---

## Tentang Proyek

**Nama Aplikasi:** FinansialKu

**Versi:** 0.0.0 (belum dirilis)

**Tujuan:** Aplikasi pribadi untuk mengontrol penuh keuangan, mencatat setiap transaksi pengeluaran/pemasukan dengan catatan, melacak total uang berdasarkan jenis (E-Money & Cash), dan melihat log pergerakan uang.

**Sifat Aplikasi:**
- Pribadi (hanya untuk satu pengguna)
- Offline-first (semua data tersimpan lokal)
- Tidak memerlukan koneksi internet
- Tidak ada akun/login/autentikasi
- Data harus selamat saat aplikasi di-update atau di-install ulang

---

## Tech Stack & Fungsi

| Tech | Fungsi | Alasan Pemilihan |
|------|--------|-------------------|
| **Flutter** | Framework UI cross-platform | Satu codebase untuk mobile, web, dan desktop. UI modern, performa tinggi, hot reload untuk development cepat |
| **Dart** | Bahasa pemrograman | Bahasa utama Flutter, typing kuat, null-safety, performa kompilasi native |
| **Drift** | Database SQLite (type-safe) | ORM untuk SQLite dengan Dart types, auto-migration, query compile-time safety. Data tersimpan di direktori privat aplikasi (survive reinstall) |
| **SQLite** | Database lokal | Standar industri untuk penyimpanan lokal. Efisien, andal, sudah teruji |
| **Riverpod** | State management | Modern, compile-time safety, mudah di-scale, tidak bergantung pada BuildContext. Cocok untuk aplikasi yang terus bertambah fitur |
| **Material 3** | Design system UI | Desain modern dari Google, customizable, dark mode built-in, konsisten |
| **Hive** | Key-value storage opsional | Untuk menyimpan pengaturan/app settings yang tidak butuh relasi kompleks |
| **intl** | Format tanggal & mata uang | Format Rupiah, tanggal Indonesia, dll |
| **fl_chart** | Visualisasi data | Grafik pie, bar, line untuk laporan keuangan visual |
| **path_provider** | Akses direktori sistem | Menentukan lokasi penyimpanan data |
| **uuid** | Generate ID unik | Setiap transaksi punya ID unik yang tidak bentrok |
| **flutter_animate** | Animasi transisi | Efek animasi halus & modern tanpa boilerplate |
| **glassmorphism** | Efek glassy UI | Efek transparan & blur untuk sidebar & kartu |

---

## Desain UI/UX

### 🎨 Design System — UI

#### Palet Warna Utama

```
┌─────────────────────────────────────────────────────────────┐
│  WARNA UTAMA: PUTIH                                         │
│  Background aplikasi: #FFFFFF (white)                       │
│  Background sidebar: Transparan dengan efek glass           │
├─────────────────────────────────────────────────────────────┤
│  GRADIENT UTAMA: HIJAU → MERAH                              │
│  Hijau (positif/income): #4CAF50 → #2E7D32                 │
│  Merah (negatif/expense): #F44336 → #C62828                │
│  Gradient header: linear-gradient(135deg, #4CAF50, #F44336) │
├─────────────────────────────────────────────────────────────┤
│  WARNA SUPPORTING                                           │
│  Teks utama: #1A1A1A (hitam pekat)                          │
│  Teks sekunder: #6B7280 (abu-abu)                           │
│  Divider/border: #E5E7EB (abu terang)                       │
│  Shadow: rgba(0, 0, 0, 0.08)                               │
│  Success: #4CAF50                                           │
│  Warning: #FF9800                                           │
│  Error: #F44336                                             │
└─────────────────────────────────────────────────────────────┘
```

#### Tampilan Sidebar — Glassy & Floating

```
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│   ╔══════════╗                                                 │
│   ║          ║  ← Sidebar melayang (floating)                  │
│   ║   🏠     ║  ← Hanya ikon, TIDAK ada teks                  │
│   ║          ║  ← Efek glassy (transparan + blur)              │
│   ║   💰     ║  ← Background: putih semi-transparan            │
│   ║          ║     dengan backdrop blur                         │
│   ║   📊     ║  ← Border tipis: rgba(255,255,255,0.2)         │
│   ║          ║  ← Shadow lembut di sekeliling                  │
│   ║   📁     ║  ← Border radius: 20px (rounded)                │
│   ║          ║  ← Lebar: 60-70px                               │
│   ║   ⚙️     ║  ← Posisi: kiri tengah (vertically centered)    │
│   ║          ║                                                 │
│   ╚══════════╝                                                 │
│                                                                │
│   ┌──────────────────────────────────────────────────────────┐ │
│   │                                                          │ │
│   │              KONTEN UTAMA (area konten)                  │ │
│   │                                                          │ │
│   └──────────────────────────────────────────────────────────┘ │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

**Spesifikasi Sidebar:**
| Elemen | Spesifikasi |
|--------|-------------|
| Posisi | Kiri tengah (vertically centered) |
| Lebar | 60-70px |
| Tinggi | Mengikuti jumlah ikon (auto) |
| Background | `Colors.white.withOpacity(0.85)` |
| Backdrop filter | `ImageFilter.blur(sigmaX: 15, sigmaY: 15)` |
| Border | `Border.all(color: Colors.white.withOpacity(0.2))` |
| Border radius | `BorderRadius.circular(20)` |
| Shadow | `BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: Offset(0, 8))` |
| Ikon size | 24px |
| Ikon padding | 16px semua sisi |
| Ikon spacing | 8px antar ikon |
| Ikon aktif | Warna gradient (hijau→merah) |
| Ikon tidak aktif | Abu-abu (#6B7280) |
| Efek hover | Scale 1.1 + shadow lebih besar |
| Efek tap | Scale 0.95 (feedback) |
| Animasi | Transisi 200ms ease-out |

**Ikon Sidebar:**
| Ikon | Fungsi | Tooltip |
|------|--------|---------|
| 🏠 | Home/Dashboard | "Beranda" |
| 💰 | Transaksi | "Catat Uang" |
| 📊 | Laporan | "Lihat Laporan" |
| 📁 | Kategori | "Atur Kategori" |
| 💳 | Jenis Uang | "Atur Uang" |
| 📋 | Log Keuangan | "Lihat Log" |
| ⚙️ | Pengaturan | "Pengaturan" |

#### Komponen UI Utama

**1. Balance Card (Kartu Saldo)**
```
┌──────────────────────────────────────────┐
│  ╔══════════════════════════════════╗     │
│  ║  GRADIENT BACKGROUND            ║     │
│  ║  (Hijau → Merah, 135deg)        ║     │
│  ║                                  ║     │
│  ║  Total Saldo                     ║     │
│  ║  ═══════════                     ║     │
│  ║  Rp 2.500.000                   ║     │
│  ║                                  ║     │
│  ║  ┌─────────┐  ┌─────────┐       ║     │
│  ║  │ Pemasukan│  │Pengeluaran│     ║     │
│  ║  │ Rp 5.000 │  │ Rp 2.500│      ║     │
│  ║  │ (hijau)  │  │ (merah) │      ║     │
│  ║  └─────────┘  └─────────┘       ║     │
│  ╚══════════════════════════════════╝     │
│                                          │
│  Background: Gradient                    │
│  Teks: Putih (#FFFFFF)                   │
│  Shadow: Besar, menyebar                 │
│  Border radius: 24px                     │
└──────────────────────────────────────────┘
```

**2. Money Type Card (Kartu Jenis Uang) — Rotasi Otomatis**
```
┌──────────────────────────────────────────┐
│  ╔══════════════════════════════════╗     │
│  ║  GRADIENT BACKGROUND            ║     │
│  ║  (Hijau → Merah, 135deg)        ║     │
│  ║                                  ║     │
│  ║  [Tampilan bergantian]           ║     │
│  ║                                  ║     │
│  ║  ▸ E-Money                       ║     │
│  ║  ═══════════                     ║     │
│  ║  Rp 1.800.000                   ║     │
│  ║                                  ║     │
│  ║  ┌──────┐ ┌──────┐ ┌──────┐    ║     │
│  ║  │ Dana │ │ OVO  │ │ BCA  │    ║     │
│  ║  │ 500K │ │ 300K │ │ 1.0M │    ║     │
│  ║  └──────┘ └──────┘ └──────┘    ║     │
│  ║                                  ║     │
│  ║  [atau]                          ║     │
│  ║                                  ║     │
│  ║  ▸ Cash                          ║     │
│  ║  ═══════════                     ║     │
│  ║  Rp 700.000                     ║     │
│  ║                                  ║     │
│  ╚══════════════════════════════════╝     │
│                                          │
│  Rotasi otomatis: 5 detik per tampilan   │
│  Indikator: ● ○ ○ (3 titik di bawah)    │
│  Transisi: Slide horizontal              │
│  Animasi: 300ms ease-out                 │
└──────────────────────────────────────────┘
```

**3. Transaction Item (Item Transaksi)**
```
┌──────────────────────────────────────────┐
│  ┌──────┐                                │
│  │ 🍔   │  Makan Siang                  │
│  │      │  13 Juni 2026                  │
│  └──────┘  ─────────────────────────     │
│            Rp 45.000        [Hapus]      │
│            Catatan: "Makan di warteg"     │
│            Jenis: E-Money (Dana)         │
│                                          │
│  Background: Putih                       │
│  Shadow: Tipis                           │
│  Border radius: 16px                     │
│  Swipe: Kiri = hapus, Kanan = edit       │
└──────────────────────────────────────────┘
```

**4. Transaction Log (Log Keuangan)**
```
┌──────────────────────────────────────────┐
│  📋 Log Keuangan                         │
│  ─────────────────────────────────       │
│                                          │
│  ┌──────────────────────────────────┐    │
│  │ 13 Jun 2026, 14:30              │    │
│  │ Pengeluaran · Dana               │    │
│  │ Rp 45.000                        │    │
│  │ Catatan: Makan siang             │    │
│  │ ───────────────────────────      │    │
│  │ Rp 500.000 → -Rp 45.000         │    │
│  │            → Rp 455.000          │    │
│  └──────────────────────────────────┘    │
│                                          │
│  ┌──────────────────────────────────┐    │
│  │ 13 Jun 2026, 09:15              │    │
│  │ Pemasukan · Cash                 │    │
│  │ Rp 200.000                       │    │
│  │ Catatan: Uang dari ibu           │    │
│  │ ───────────────────────────      │    │
│  │ Rp 500.000 → +Rp 200.000        │    │
│  │            → Rp 700.000          │    │
│  └──────────────────────────────────┘    │
│                                          │
│  Filter: [Tanggal ▼] [Jenis ▼] [Platf] │
│  Export: [CSV] [PDF]                     │
└──────────────────────────────────────────┘
```

**4. Form Input Transaksi**
```
┌──────────────────────────────────────────┐
│                                          │
│  Nominal                                 │
│  ┌──────────────────────────────────┐    │
│  │ Rp                               │    │
│  └──────────────────────────────────┘    │
│  ← Background putih, border abu tipis    │
│  ← Focus: border gradient hijau-merah    │
│                                          │
│  Kategori                                │
│  ┌──────────────────────────────────┐    │
│  │ 🍔 Makanan & Minuman        ▼   │    │
│  └──────────────────────────────────┘    │
│  ← Dropdown dengan ikon & warna          │
│                                          │
│  Jenis Uang *                            │
│  ┌──────────┐  ┌──────────┐             │
│  │ 💳 E-Money│  │ 💵 Cash  │             │
│  └──────────┘  └──────────┘             │
│  ← Toggle button (wajib pilih salah satu)│
│                                          │
│  Platform (jika E-Money)                 │
│  ┌──────────────────────────────────┐    │
│  │ 💰 Dana                      ▼  │    │
│  └──────────────────────────────────┘    │
│  ← Dropdown platform (Dana, OVO, BCA)    │
│  ← Hanya muncul jika pilih E-Money       │
│                                          │
│  Catatan (opsional)                      │
│  ┌──────────────────────────────────┐    │
│  │                                  │    │
│  └──────────────────────────────────┘    │
│  ← Multi-line, tinggi 80px               │
│  ← Placeholder: "Tulis catatan..."       │
│                                          │
│  Tanggal                                 │
│  ┌──────────────────────────────────┐    │
│  │ 📅 13 Juni 2026                  │    │
│  └──────────────────────────────────┘    │
│  ← Default: hari ini                     │
│  ← Bisa diubah via date picker           │
│                                          │
│  ┌──────────────────────────────────┐    │
│  │      SIMPAN TRANSAKSI            │    │
│  │      (Gradient hijau→merah)       │    │
│  └──────────────────────────────────┘    │
│  ← Full width, tinggi 52px               │
│  ← Shadow saat hover                     │
└──────────────────────────────────────────┘
```

---

### 🧠 UX Rules — Aturan Pengalaman Pengguna

#### Prinsip Utama

```
┌─────────────────────────────────────────────────────────────┐
│  PRINSIP UX: "SEKALI LIHAT, SEKALI KLIK, SELESAI"          │
│                                                             │
│  1. SEMUA INFORMASI VISIBLE — Tidak ada yang tersembunyi    │
│  2. MINIMAL KLIK — Maksimal 3 klik untuk mencapai fitur    │
│  3. KONSISTEN — Pola yang sama di semua halaman             │
│  4. FEEDBACK — Setiap aksi ada respons visual               │
│  5. TIDAK ADA KEJUTAN — User selalu tahu apa yang terjadi  │
└─────────────────────────────────────────────────────────────┘
```

#### Aturan Navigasi

| No | Aturan | Penjelasan |
|----|--------|------------|
| 1 | **Sidebar selalu terlihat** | Tidak pernah disembunyikan, tidak perlu swipe untuk membuka |
| 2 | **Ikon aktif jelas** | Ikon yang dipilih punya warna gradient, yang lain abu-abu |
| 3 | **Back button konsisten** | Selalu ada di kiri atas halaman selain home |
| 4 | **Judul halaman** | Selalu ada di atas, tebal, ukuran 20sp |
| 5 | **Breadcrumb tidak perlu** | Karena sidebar sudah jelas posisi user |

#### Aturan Input Data

| No | Aturan | Penjelasan |
|----|--------|------------|
| 1 | **Form minimal field** | Hanya nominal + kategori. Catatan opsional. Tanggal default hari ini |
| 2 | **Nominal otomatis format** | User ketik angka mentah, otomatis format Rp. Contoh: ketik `50000` → tampil `Rp 50.000` |
| 3 | **Kategori bisa dipilih cepat** | Dropdown + search. Tidak perlu scroll panjang |
| 4 | **Konfirmasi sebelum simpan** | Tombol "Simpan" → dialog kecil: "Pastikan data benar?" → OK |
| 5 | **Sukses tanpa redirect** | Setelah simpan, tetap di halaman yang sama dengan toast "Berhasil disimpan!" |
| 6 | **Bisa langsung tambah lagi** | Form otomatis kosong setelah simpan, siap input berikutnya |

#### Aturan Konfirmasi Hapus

```
┌─────────────────────────────────────────────┐
│  ⚠️ Hapus Transaksi?                        │
│                                             │
│  Transaksi "Makan Siang" sebesar Rp 45.000  │
│  akan dihapus permanen.                     │
│                                             │
│  ┌──────────┐  ┌──────────┐                 │
│  │  BATAL    │  │  HAPUS   │                 │
│  │ (abu)     │  │ (merah)  │                 │
│  └──────────┘  └──────────┘                 │
└─────────────────────────────────────────────┘

- Selalu tampilkan detail transaksi yang akan dihapus
- Tombol BATAL di kiri, HAPUS di kanan
- Tombol HAPUS berwarna merah
- Tidak ada undo setelah konfirmasi
```

#### Aturan Feedback & Notifikasi

| Aksi User | Feedback |
|-----------|----------|
| Tap ikon sidebar | Ikon berubah warna + sedikit scale up (200ms) |
| Tap tombol "Simpan" | Loading spinner 500ms → Toast hijau "Tersimpan!" |
| Tap hapus transaksi | Dialog konfirmasi muncul |
| Berhasil hapus | Toast merah "Transaksi dihapus" |
| Error/gagal | Toast merah dengan pesan jelas |
| Data kosong | Ilustrasi "Belum ada transaksi" + tombol "Tambah Sekarang" |
| Sedang load | Skeleton loading (bukan spinner bulat) |
| Scroll daftar | Infinite scroll, tidak ada tombol "Load More" |
| Pull to refresh | Ikon refresh muncul di atas, lepas untuk refresh |

#### Aturan Transisi Halaman

```
┌─────────────────────────────────────────────────────────────┐
│  TRANSISI: Slide dari kanan (300ms, ease-out)                │
│                                                             │
│  Home → Transaksi: Slide kanan ke kiri                      │
│  Transaksi → Detail: Slide kanan ke kiri                    │
│  Kembali: Slide kiri ke kanan                               │
│  Dialog: Fade in + scale dari 0.9 ke 1.0                    │
│  Toast: Slide dari atas + fade out setelah 2 detik          │
└─────────────────────────────────────────────────────────────┘
```

#### Aturan Responsive Layout

| Breakpoint | Layout |
|------------|--------|
| < 600px (Mobile) | Sidebar di kiri, konten penuh |
| 600-900px (Tablet) | Sidebar di kiri, konten dengan padding |
| > 900px (Desktop) | Sidebar di kiri, konten max-width 800px, center |

---

## Struktur File & Folder

```
finansial_ku/
├── lib/
│   ├── main.dart                    # Entry point aplikasi, inisialisasi database & provider
│   ├── app.dart                     # Konfigurasi MaterialApp, theme, routing
│   │
│   ├── core/                        # ═══ LAYER CORE (fundamental) ═══
│   │   ├── constants/
│   │   │   ├── app_colors.dart      # Palet warna: putih, gradient hijau-merah, abu
│   │   │   ├── app_text_styles.dart # Tipografi & gaya teks
│   │   │   ├── app_sizes.dart       # Dimensi, padding, margin
│   │   │   └── app_strings.dart     # String statis (judul, label, pesan error)
│   │   │
│   │   ├── enums/
│   │   │   ├── transaction_type.dart    # Enum: pemasukan, pengeluaran
│   │   │   └── category_type.dart       # Enum: kategori belanja (makanan, transport, dll)
│   │   │
│   │   ├── utils/
│   │   │   ├── currency_formatter.dart  # Format angka ke Rupiah (Rp 50.000)
│   │   │   ├── date_formatter.dart      # Format tanggal ke format Indonesia
│   │   │   └── id_generator.dart        # Generate UUID untuk setiap transaksi
│   │   │
│   │   └── theme/
│   │       ├── app_theme.dart           # Theme utama: putih + gradient
│   │       └── color_schemes.dart       # Skema warna Material 3
│   │
│   ├── database/                    # ═══ LAYER DATABASE (Drift) ═══
│   │   ├── app_database.dart        # Kelas utama database, koneksi & inisialisasi
│   │   ├── app_database.g.dart      # File generated oleh Drift (JANGAN EDIT MANUAL)
│   │   ├── tables/
│   │   │   ├── transactions_table.dart  # Tabel transaksi (id, jumlah, kategori, tanggal, catatan, jenis_uang, platform)
│   │   │   ├── categories_table.dart    # Tabel kategori belanja
│   │   │   ├── money_types_table.dart   # Tabel jenis uang (E-Money, Cash)
│   │   │   ├── platforms_table.dart     # Tabel platform (Dana, OVO, BCA, dll)
│   │   │   └── transaction_logs_table.dart # Tabel log perubahan uang
│   │   ├── daos/
│   │   │   ├── transaction_dao.dart     # Data Access Object untuk transaksi
│   │   │   ├── category_dao.dart        # Data Access Object untuk kategori
│   │   │   ├── money_type_dao.dart      # Data Access Object untuk jenis uang
│   │   │   ├── platform_dao.dart        # Data Access Object untuk platform
│   │   │   └── log_dao.dart             # Data Access Object untuk log keuangan
│   │   └── migrations/
│   │       └── migration_strategy.dart  # Strategi migrasi database saat update
│   │
│   ├── models/                      # ═══ LAYER MODEL (data structures) ═══
│   │   ├── transaction.dart         # Model Transaksi (id, jumlah, tipe, kategori, tanggal, catatan, jenis_uang, platform)
│   │   ├── category.dart            # Model Kategori (id, nama, ikon, warna)
│   │   ├── money_type.dart          # Model Jenis Uang (id, nama, tipe: emoney/cash)
│   │   ├── platform.dart            # Model Platform (id, nama, ikon, warna, jenis_uang_id)
│   │   ├── transaction_log.dart     # Model Log (id, transaksi_id, saldo_awal, perubahan, saldo_akhir, waktu)
│   │   ├── wallet_summary.dart      # Model Ringkasan (total_uang, total_emoney, total_cash)
│   │   └── monthly_report.dart      # Model Laporan Bulanan
│   │
│   ├── providers/                   # ═══ LAYER PROVIDER (Riverpod) ═══
│   │   ├── database_provider.dart   # Provider untuk instance database
│   │   ├── transaction_provider.dart# Provider untuk state transaksi
│   │   ├── category_provider.dart   # Provider untuk state kategori
│   │   ├── money_type_provider.dart # Provider untuk state jenis uang
│   │   ├── platform_provider.dart   # Provider untuk state platform
│   │   ├── log_provider.dart        # Provider untuk state log keuangan
│   │   ├── wallet_provider.dart     # Provider untuk state dompet/ringkasan
│   │   └── theme_provider.dart      # Provider untuk mode terang/gelap
│   │
│   ├── screens/                     # ═══ LAYER SCREEN (halaman UI) ═══
│   │   ├── home/
│   │   │   ├── home_screen.dart         # Halaman utama: ringkasan saldo + navigasi
│   │   │   └── widgets/
│   │   │       ├── balance_card.dart        # Kartu saldo utama (gradient hijau-merah)
│   │   │       ├── money_type_card.dart     # Kartu jenis uang (E-Money/Cash) dengan rotasi
│   │   │       └── recent_transactions.dart # Daftar transaksi terakhir
│   │   │
│   │   ├── transaction/
│   │   │   ├── transaction_list_screen.dart # Daftar semua transaksi
│   │   │   ├── add_transaction_screen.dart  # Form tambah transaksi baru (pilih jenis uang & platform)
│   │   │   └── transaction_detail_screen.dart # Detail satu transaksi dengan catatan
│   │   │
│   │   ├── category/
│   │   │   ├── category_list_screen.dart    # Daftar semua kategori
│   │   │   └── add_category_screen.dart     # Form tambah kategori baru
│   │   │
│   │   ├── money_type/
│   │   │   ├── money_type_list_screen.dart  # Daftar jenis uang (E-Money & Cash)
│   │   │   └── add_money_type_screen.dart   # Form tambah jenis uang baru
│   │   │
│   │   ├── platform/
│   │   │   ├── platform_list_screen.dart    # Daftar platform (Dana, OVO, BCA, dll)
│   │   │   └── add_platform_screen.dart     # Form tambah platform baru
│   │   │
│   │   ├── log/
│   │   │   └── transaction_log_screen.dart  # Log keuangan (riwayat perubahan saldo)
│   │   │
│   │   ├── report/
│   │   │   ├── report_screen.dart           # Laporan keuangan (grafik & statistik)
│   │   │   └── widgets/
│   │   │       ├── pie_chart_widget.dart    # Grafik pie untuk distribusi kategori
│   │   │       └── bar_chart_widget.dart    # Grafik bar untuk tren pengeluaran
│   │   │
│   │   └── settings/
│   │       └── settings_screen.dart         # Pengaturan aplikasi
│   │
│   └── widgets/                     # ═══ WIDGET REUSABLE (komponen umum) ═══
│       ├── glassy_sidebar.dart      # Sidebar glassy floating (ikon saja)
│       ├── gradient_button.dart     # Tombol dengan gradient hijau-merah
│       ├── custom_text_field.dart   # Input field kustom
│       ├── toast_notification.dart  # Toast notifikasi sukses/error
│       ├── empty_state.dart         # Tampilan saat data kosong
│       ├── loading_skeleton.dart    # Skeleton loading (bukan spinner)
│       ├── confirmation_dialog.dart # Dialog konfirmasi (hapus, dll)
│       ├── money_type_selector.dart # Pemilih jenis uang (E-Money/Cash)
│       ├── platform_selector.dart   # Pemilih platform (Dana, OVO, BCA, dll)
│       └── note_input.dart          # Input catatan transaksi
│
├── test/                            # ═══ TESTING ═══
│   ├── unit/
│   │   ├── currency_formatter_test.dart
│   │   └── transaction_test.dart
│   ├── widget/
│   │   └── balance_card_test.dart
│   └── integration/
│       └── transaction_flow_test.dart
│
├── assets/                          # ═══ ASET APLIKASI ═══
│   ├── images/                      # Gambar (logo, ilustrasi)
│   ├── icons/                       # Ikon kustom
│   └── fonts/                       # Font kustom (opsional)
│
├── pubspec.yaml                     # Konfigurasi proyek & dependencies
├── analysis_options.yaml            # Aturan linting Dart
├── .gitignore                       # File/folder yang diabaikan Git
└── README.md                        # Dokumentasi ini
```

### Penjelasan Setiap Folder

| Folder | Fungsi |
|--------|--------|
| `lib/core/` | Fondasi aplikasi. Konstanta warna (putih, gradient hijau-merah), tema, utilitas, enum. Tidak ada logika bisnis |
| `lib/database/` | Semua yang berhubungan dengan Drift & SQLite. Tabel, DAO, migrasi. Satu-satunya tempat akses database |
| `lib/models/` | Struktur data murni. Tidak ada logika UI, tidak ada logika bisnis. Hanya representasi data |
| `lib/providers/` | Pengelolaan state seluruh aplikasi. Menghubungkan database ke UI melalui Riverpod |
| `lib/screens/` | Setiap halaman aplikasi. Folder per fitur (home, transaction, category, report, settings) |
| `lib/widgets/` | Komponen UI reusable: glassy sidebar, gradient button, toast, skeleton loading |
| `test/` | Unit test, widget test, integration test |
| `assets/` | File statis: gambar, ikon, font |

---

## Fitur Aplikasi

### 🟢 Fitur Utama (V1.0)

#### 1. Ringkasan Keuangan (Dashboard)
- Menampilkan **total uang saat ini** (saldo bersih)
- Menampilkan **total uang yang pernah dikumpulkan** (akumulasi pemasukan)
- Menampilkan **total pengeluaran** sepanjang waktu
- Kartu saldo modern dengan animasi
- **Rotasi otomatis** setiap 5 detik antara tampilan E-Money dan Cash
- Menampilkan **total E-Money** dan **total Cash** secara terpisah

#### 2. Pencatatan Transaksi
- **Input pengeluaran**: nominal, kategori, catatan (opsional), tanggal, jenis uang (E-Money/Cash)
- **Input pemasukan**: nominal, catatan (opsional), tanggal, jenis uang (E-Money/Cash)
- **Catatan transaksi**: Bisa memberikan catatan untuk setiap transaksi (baik pengeluaran maupun pemasukan)
- Setiap transaksi otomatis mendapat ID unik & timestamp
- Bisa mengedit transaksi yang sudah ada
- Bisa menghapus transaksi dengan konfirmasi
- **Log transaksi**: Setiap perubahan uang tercatat di log ( nominal awal, perubahan, nominal akhir, jenis uang, waktu)

#### 3. Sistem Kategori
- Kategori default: Makanan & Minuman, Transportasi, Belanja, Hiburan, Tagihan, Kesehatan, Pendidikan, Lainnya
- Bisa **menambah kategori baru** (nama, ikon, warna)
- Bisa **mengedit kategori** yang sudah ada
- Bisa **menghapus kategori** (dengan penanganan transaksi terkait)

#### 4. Laporan & Statistik
- **Grafik pie**: Distribusi pengeluaran per kategori
- **Grafik bar**: Tren pengeluaran per bulan
- **Ringkasan bulanan**: Total pemasukan vs pengeluaran per bulan
- Filter berdasarkan rentang tanggal

#### 5. Riwayat Transaksi
- Daftar semua transaksi (dapat diurutkan: terbaru/terlama)
- Pencarian transaksi berdasarkan catatan
- Filter berdasarkan kategori & rentang tanggal
- Detail transripsi (tap untuk lihat)

#### 6. Pengaturan
- Mode terang / gelap
- Format mata uang (default: Rupiah)
- Backup & restore data (ekspor/import database)

#### 7. Sidebar Glassy
- Sidebar floating di kiri dengan efek glass (blur + transparan)
- Hanya menampilkan ikon (bukan teks atau burger menu)
- Ikon aktif berwarna gradient hijau-merah
- Ikon tidak aktif berwarna abu-abu
- Animasi halus saat tap (scale + shadow)
- Responsive: tetap terlihat di mobile, tablet, dan desktop

#### 8. Sistem Uang (E-Money & Cash)
- **Dua jenis uang**: E-Money (digital) dan Cash (fisik)
- **E-Money** terdiri dari beberapa platform:
  - Bank: BCA, Mandiri, BRI, BNI, dll
  - E-Wallet: Dana, OVO, GoPay, ShopeePay, dll
  - Lainnya: Kartu kredit, Tabungan, dll
- **Cash** adalah uang fisik yang dipegang
- Setiap transaksi wajib memilih jenis uang (E-Money atau Cash)
- Jika E-Money, wajib memilih platform sumber dana

#### 9. Dashboard Rotasi E-Money & Cash
- Dashboard menampilkan **tampilan bergantian** setiap 5 detik
- Urutan: Total Saldo → E-Money → Cash → Total Saldo (loop)
- Animasi transisi halus antar tampilan
- Indikator titik menunjukkan posisi saat ini
- **Total E-Money**: Jumlah seluruh saldo di semua platform E-Money
- **Total Cash**: Jumlah seluruh uang fisik

#### 10. Log Keuangan
- **Log transaksi**: Mencatat setiap kali uang masuk/keluar
- Format log:
  ```
  [Tanggal & Waktu] [Jenis: Pemasukan/Pengeluaran] [Platform] [Nominal] [Catatan]
  [Saldo Awal] → [Perubahan] → [Saldo Akhir]
  ```
- Contoh log:
  ```
  [13 Jun 2026, 14:30] [Pengeluaran] [Dana] [-Rp 45.000] [Makan siang]
  [Rp 500.000] → [-Rp 45.000] → [Rp 455.000]
  ```
- Filter log berdasarkan: tanggal, jenis transaksi, platform, nominal
- Export log ke CSV

---

### 🟡 Fitur Lanjutan (V2.0+)

#### 7. Budget / Anggaran Bulanan
- Atur budget per kategori per bulan
- Notifikasi saat mendekati batas budget
- Indikator visual (progress bar) penggunaan budget

#### 8. Target Tabungan
- Buat target tabungan dengan nama & nominal
- Lacak progress pencapaian target
- Notifikasi saat target tercapai

#### 9. Rekening / Dompet
- Pisahkan uang ke beberapa rekening (Cash, Bank BCA, GoPay, dll)
- Transfer antar rekening
- Riwayat per rekening

#### 10. Ekspor Laporan
- Ekspor ke PDF
- Ekspor ke CSV/Excel
- Bagikan laporan via WhatsApp/Email

---

## Larangan Keras

Berikut adalah hal-hal yang **DILARANG KERAS** dalam proyek ini:

### 🚫 DILARANG Menggunakan Backend/Server
```
TIDAK BOLEH ada koneksi ke API manapun.
TIDAK BOLEH ada Firebase, Supabase, atau layanan cloud apapun.
TIDAK BOLEH ada autentikasi, login, atau registrasi.
Semua data HARUS tersimpan 100% lokal di perangkat.
```

### 🚫 DILARANG Menyimpan Data Sensitif
```
TIDAK BOLEH menyimpan password, PIN, atau data kartu kredit.
TIDAK BOLEK mengirim data ke layanan pihak ketiga.
TIDAK BOLEH menggunakan analytics atau tracking.
```

### 🚫 DILARANG Menggunakan Library Tidak Perlu
```
TIDAK BOLEH menambah dependency tanpa pertimbangan matang.
TIDAK BOLEH pakai library yang sudah bisa dilakukan oleh library yang ada.
TIDAK BOLEH menggunakan library yang sudah tidak dipelihara (unmaintained).
```

### 🚫 DILARANG Mengubah Database Secara Manual
```
TIDAK BOLEH edit file .g.dart (generated file) secara manual.
TIDAK BOLEH menghapus kolom tanpa migrasi yang benar.
TIDAK BOLEH rename tabel tanpa migrasi.
```

### 🚫 DILARANG Merusak Struktur
```
TIDAK BOLEH menaruh logika bisnis di file UI/screens.
TIDAK BOLEH menaruh UI di file provider/database.
TIDAK BOLEH membuat file lebih dari 300 baris (pisahkan ke file terpisah).
TIDAK BOLEH menggunakan nama variabel/fungsi yang ambigu.
```

### 🚫 DILARANG Kode Sampah
```
TIDAK BOLEH ada kode yang tidak terpakai (dead code).
TIDAK BOLEH ada komentar yang menjelaskan "apa" (hanya jelaskan "kenapa").
TIDAK BOLEH ada print() debugging di production code.
TIDAK BOLEH ada TODO tanpa penjelasan dan tanggal.
```

---

## Yang Dibolehkan & Tidak Dibolehkan

### ✅ DIBOLEHKAN

| Aktivitas | Keterangan |
|-----------|------------|
| Menambah fitur baru | Asalkan sesuai arsitektur yang ada |
| Menambah kategori default | Bisa diedit/dihapus oleh user |
| Mengubah tema/warna | Lewat file `core/theme/` dan `core/constants/` |
| Menggunakan animasi | Asalkan tidak mengganggu performa |
| Menambah dependency baru | Setelah diskusi dan pertimbangan |
| Membuat custom widget | Taruh di `lib/widgets/`, harus reusable |
| Menambah unit test | Sangat dianjurkan untuk setiap model & utilitas |
| Refactoring kode | Selama tidak mengubah behavior & tetap passing test |

### ❌ TIDAK DIBOLEHKAN

| Aktivitas | Alasan |
|-----------|--------|
| Menambah koneksi internet | Aplikasi harus 100% offline |
| Menambah autentikasi | Tidak diperlukan untuk aplikasi pribadi |
| Menambah analytics/tracking | Melanggar privasi |
| Mengubah struktur folder | Sudah ditetapkan di awal |
| Menghapus fitur yang sudah ada | Kecuali ada alasan kuat & dokumentasi |
| Menggunakan state management selain Riverpod | Konsistensi teknologi |
| Menggunakan database selain Drift/SQLite | Konsistensi penyimpanan |
| Mengubah generated file | Biarkan Drift yang generate |
| Push kode tanpa test | Minimal unit test untuk logic baru |

---

## Pengembangan Kedepannya

### Fase 1: Fondasi (Minggu 1-2)
- [ ] Setup proyek Flutter
- [ ] Konfigurasi Drift database
- [ ] Buat tabel transaksi & kategori
- [ ] Buat tabel jenis uang (E-Money & Cash)
- [ ] Buat tabel platform (Dana, OVO, BCA, dll)
- [ ] Buat tabel log keuangan
- [ ] Setup Riverpod provider
- [ ] Implementasi CRUD transaksi
- [ ] Implementasi CRUD jenis uang & platform
- [ ] Implementasi logging otomatis

### Fase 2: UI Utama (Minggu 3-4)
- [ ] Implementasi Glassy Sidebar (floating, ikon saja, 7 ikon)
- [ ] Desain halaman home dengan Balance Card gradient
- [ ] Implementasi Money Type Card dengan rotasi otomatis (5 detik)
- [ ] Form tambah/edit transaksi dengan validasi
- [ ] Form pilih jenis uang (E-Money/Cash) & platform
- [ ] Daftar transaksi dengan search & filter
- [ ] Toast notifikasi (sukses/error)
- [ ] Skeleton loading (bukan spinner)
- [ ] Transisi halaman (slide kanan-kiri)

### Fase 3: Log & Laporan (Minggu 5-6)
- [ ] Halaman log keuangan (riwayat perubahan saldo)
- [ ] Filter log berdasarkan tanggal, jenis, platform
- [ ] Export log ke CSV
- [ ] Grafik pie distribusi pengeluaran
- [ ] Grafik bar tren bulanan
- [ ] Ringkasan laporan bulanan
- [ ] Filter rentang tanggal

### Fase 4: Fitur Lanjutan (Minggu 7-8)
- [ ] Backup & restore database
- [ ] Mode terang/gelap
- [ ] Budget per kategori
- [ ] Target tabungan
- [ ] Manajemen platform (CRUD)

### Fase 5: Polish & Rilis (Minggu 9-10)
- [ ] Animasi transisi
- [ ] Edge cases handling
- [ ] Performance optimization
- [ ] User testing
- [ ] Rilis v1.0

### Masa Depan (V2.0+)
- Multi-rekening / dompet
- Ekspor PDF/CSV
- Widget home screen (Android)
- Notifikasi budget
- Kalkulator bunga simpanan
- Pendapatan berulang (subscriptions)
- Pencarian lanjutan dengan filter kompleks

---

## Cara Memulai

### Prasyarat
- Flutter SDK >= 3.x
- Dart SDK >= 3.x
- VS Code atau Android Studio
- Emulator atau device fisik

### Instalasi

```bash
# 1. Clone repository
git clone https://github.com/username/finansial_ku.git

# 2. Masuk ke direktori
cd finansial_ku

# 3. Install dependencies
flutter pub get

# 4. Generate file Drift
dart run build_runner build --delete-conflicting-outputs

# 5. Jalankan aplikasi
flutter run
```

### Development

```bash
# Generate ulang saat ada perubahan Drift
dart run build_runner watch --delete-conflicting-outputs

# Jalankan test
flutter test

# Build release
flutter build apk --release
flutter build ios --release
```

---

## Aturan Kode

### Penamaan
| Elemen | Format | Contoh |
|--------|--------|--------|
| File | `snake_case.dart` | `transaction_dao.dart` |
| Kelas | `PascalCase` | `TransactionDao` |
| Fungsi | `camelCase` | `getAllTransactions()` |
| Variabel | `camelCase` | `totalBalance` |
| Konstanta | `camelCase` | `defaultCategories` |
| Enum | `PascalCase` | `TransactionType` |
| Tabel | `PascalCase` + `Table` | `TransactionsTable` |

### Komentar
- **Boleh**: Komentar yang menjelaskan **kenapa** sesuatu dilakukan
- **Tidak boleh**: Komentar yang menjelaskan **apa** kode lakukan (gunakan nama fungsi yang jelas)
- **Tidak boleh**: Komentar yang sudah usang/tidak relevan

### Format Rupiah
```dart
// ✅ BENAR
Rp 50.000
Rp 1.250.000
Rp 100.000

// ❌ SALAH
Rp50000
Rp 50000
50.000 Rp
Rp.50.000
```

---

## Komponen UI Kunci

### Glassy Sidebar — Implementasi

```dart
// Contoh struktur GlassySidebar
GlassySidebar(
  children: [
    SidebarIcon(
      icon: Icons.home_rounded,
      isActive: currentIndex == 0,
      onTap: () => navigateTo(0),
    ),
    SidebarIcon(
      icon: Icons.account_balance_wallet_rounded,
      isActive: currentIndex == 1,
      onTap: () => navigateTo(1),
    ),
    SidebarIcon(
      icon: Icons.bar_chart_rounded,
      isActive: currentIndex == 2,
      onTap: () => navigateTo(2),
    ),
    SidebarIcon(
      icon: Icons.category_rounded,
      isActive: currentIndex == 3,
      onTap: () => navigateTo(3),
    ),
    SidebarIcon(
      icon: Icons.credit_card_rounded,
      isActive: currentIndex == 4,
      onTap: () => navigateTo(4),
    ),
    SidebarIcon(
      icon: Icons.receipt_long_rounded,
      isActive: currentIndex == 5,
      onTap: () => navigateTo(5),
    ),
    SidebarIcon(
      icon: Icons.settings_rounded,
      isActive: currentIndex == 6,
      onTap: () => navigateTo(6),
    ),
  ],
)
```

### Gradient Button — Implementasi

```dart
// Contoh GradientButton
GradientButton(
  text: 'Simpan Transaksi',
  gradient: LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFFF44336)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  onPressed: () => saveTransaction(),
)
```

### Toast Notification — Implementasi

```dart
// Contoh penggunaan Toast
Toast.success('Transaksi berhasil disimpan!');
Toast.error('Gagal menghapus transaksi');
Toast.info('Data sedang dimuat...');
```

### Aturan Warna Ikon Sidebar

```dart
// Definisi warna sidebar
class SidebarColors {
  static const activeIcon = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFFF44336)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const inactiveIcon = Color(0xFF6B7280);
  static const background = Colors.white.withOpacity(0.85);
  static const border = Colors.white.withOpacity(0.2);
  static const shadow = Colors.black.withOpacity(0.08);
}
```

---

## Catatan Penting

1. **Data adalah segalanya** — Kehilangan data keuangan sangat merugikan. Pastikan migrasi database selalu diuji dengan baik.

2. **Backup adalah wajib** — Fitur backup & restore harus diimplementasikan sesegera mungkin di Fase 4.

3. **Performa** — Aplikasi harus tetap responsif meskipun data transaksi sudah ribuan. Gunakan pagination jika perlu.

4. **Privasi** — Aplikasi ini TIDAK boleh mengirim data kemana-mana. Tidak ada network call, tidak ada telemetry.

5. **Migrasi database** — Saat menambah kolom/tabel baru, selalu buat migration strategy yang benar. Data lama tidak boleh hilang.

6. **Testing** — Minimal ada test untuk:
   - Semua fungsi di `utils/`
   - Semua query di `daos/`
   - Model conversion
   - Widget penting (balance card, form transaksi, sidebar)

7. **Backup file generated** — File `.g.dart` diabaikan oleh `.gitignore`. Jalankan `dart run build_runner build` setelah clone.

8. **Konsistensi UI** — Selalu gunakan:
   - Warna putih untuk background
   - Gradient hijau-merah untuk elemen positif/aktif
   - Efek glass untuk sidebar
   - Tidak ada teks di sidebar, hanya ikon
   - Transisi slide untuk navigasi
   - Toast untuk feedback
   - Skeleton loading saat data dimuat

9. **UX Rules** — Patuhi aturan "SEKALI LIHAT, SEKALI KLIK, SELESAI":
   - Maksimal 3 klik untuk mencapai fitur apapun
   - Form input minimal: nominal + kategori + jenis uang + tanggal (otomatis hari ini)
   - Konfirmasi sebelum aksi destruktif (hapus)
   - Feedback selalu ada (toast, animasi, transisi)
   - Tidak ada kejutan: user selalu tahu apa yang terjadi

10. **Sistem Uang** — Patuhi aturan:
    - Setiap transaksi WAJIB memilih jenis uang (E-Money atau Cash)
    - Jika E-Money, WAJIB memilih platform sumber dana
    - Setiap perubahan uang OTOMATIS tercatat di log
    - Log berisi: nominal awal, perubahan, nominal akhir, waktu
    - Dashboard harus menampilkan rotasi E-Money & Cash setiap 5 detik

11. **Log Keuangan** — Setiap transaksi harus menghasilkan log:
    ```
    [Tanggal & Waktu] [Jenis: Pemasukan/Pengeluaran] [Platform] [Nominal] [Catatan]
    [Saldo Awal] → [Perubahan] → [Saldo Akhir]
    ```
    - Log tidak boleh dihapus (append only)
    - Log harus bisa di-export ke CSV
    - Log harus bisa difilter berdasarkan tanggal, jenis, platform

---

<div align="center">

**FinansialKu** — Kontrol penuh keuangan pribadimu.

*Dibuat dengan ❤️ untuk penggunaan pribadi.*

</div>
