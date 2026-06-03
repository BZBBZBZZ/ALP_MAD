# ALP_MAD

ALP_MAD adalah aplikasi iOS (SwiftUI) dengan dukungan WatchOS untuk tracking aktivitas yang digamifikasi (boss battle, buffs, streaks, dsb.). README ini menjelaskan cara menyiapkan proyek agar bisa dijalankan di Xcode.

## Ringkasan
- Platform: iOS (SwiftUI) + WatchOS
- Arsitektur: MVVM

## Persyaratan
- macOS dengan Xcode terbaru (rekomendasi Xcode 15+)
- Apple Developer account untuk menjalankan di perangkat fisik
- Jika menggunakan Firebase: file `GoogleService-Info.plist` (disediakan di repo root jika terpakai)

## Langkah cepat (clone → buka → jalankan)

1. Clone repository:

```bash
git clone <repo-url>
cd ALP_MAD
```

2. Periksa file `GoogleService-Info.plist` di folder root. Jika proyekmu terhubung ke Firebase, pastikan file tersebut cocok dengan bundle identifier di Xcode.

3. Buka project di Xcode:

- Buka workspace / project yang sesuai. Contoh: buka file `ALP_MAD.xcodeproj` atau workspace jika ada.

```text
Open "ALP_MAD.xcodeproj" di Xcode (atau buka workspace bila tersedia)
```

4. Resolve Swift Packages (jika ada):

Xcode → File → Packages → Resolve Package Versions

5. Pilih target dan device/simulator, lalu tekan `⌘R` untuk menjalankan.

## Konfigurasi Signing & Capabilities
- Buka target `ALP_MAD` → tab *Signing & Capabilities*.
- Pilih *Team* (Apple ID) untuk automatic signing atau atur provisioning profile yang sesuai.
- Tambahkan capability yang diperlukan (mis. Background Modes, HealthKit) jika kode menggunakan fitur tersebut.

## Menjalankan di Simulator vs Device
- Simulator: pilih simulator (mis. iPhone 14) → Run.
- Perangkat fisik: sambungkan iPhone → pastikan provisioning & signing benar → Run.

## WatchOS
- Terdapat target Watch App di project. Untuk menjalankan watch app gunakan paired device (Simulator Pairing atau perangkat fisik).

## Firebase / GoogleService-Info.plist
- Jika app memakai Firebase, file konfigurasi `GoogleService-Info.plist` harus berada di root proyek atau target resource.
- Jika belum ada, buat project di Firebase Console, unduh `GoogleService-Info.plist`, lalu masukkan ke root proyek.

## Struktur Utama Repo
- App entry: [ALP_MAD/ALP_MADApp.swift](ALP_MAD/ALP_MADApp.swift)
- Views: [ALP_MAD/Views](ALP_MAD/Views)
- ViewModels: [ALP_MAD/ViewModels](ALP_MAD/ViewModels)
- Services: [ALP_MAD/Services](ALP_MAD/Services)
- Models: [ALP_MAD/Models](ALP_MAD/Models)
- Utilities & Components: [ALP_MAD/Utilities](ALP_MAD/Utilities) dan [ALP_MAD/Components](ALP_MAD/Components)

## Troubleshooting
- Build error (signing): pastikan *Team* dipilih dan provisioning profile valid.
- Missing `GoogleService-Info.plist`: tambahkan file dari Firebase Console.
- Package resolution error: File → Packages → Resolve Package Versions, atau bersihkan Derived Data (Xcode → Settings → Locations → Derived Data → Delete).
- Crash terkait WatchConnectivity: jalankan paired Watch simulator/device atau sementara nonaktifkan kode WatchConnectivity untuk debug.

## Testing
- Jika ada unit tests, jalankan scheme test di Xcode.
