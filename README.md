<div align="center">

<img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
<img src="https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
<img src="https://img.shields.io/badge/BLoC-State%20Management-purple?style=for-the-badge" />
<img src="https://img.shields.io/badge/Clean-Architecture-green?style=for-the-badge" />
<img src="https://img.shields.io/badge/Backend-.NET%20REST%20API-512BD4?style=for-the-badge&logo=dotnet&logoColor=white" />

<br/><br/>

# 🫀 Nabd — نبض

### A Smart Healthcare Mobile App Built with Flutter

*Book appointments · Manage medical records · AI-powered health analysis*

<br/>

</div>

---

## 📱 Screenshots

| Home Screen | My Appointments | Book Appointment | Patient Profile |
|:-----------:|:---------------:|:----------------:|:---------------:|
| ![Home](https://github.com/ahmed24E/nabd/raw/master/screenshots/home%20page.jpg) | ![Appointments](https://github.com/ahmed24E/nabd/raw/master/screenshots/appointments.webp) | ![Book](https://github.com/ahmed24E/nabd/raw/master/screenshots/book%20appointment.webp) | ![Profile](https://github.com/ahmed24E/nabd/raw/master/screenshots/profile.webp) |

| Doctor Search | Medical Records | AI Health Assistant |
|:-------------:|:---------------:|:-------------------:|
| ![Search](https://github.com/ahmed24E/nabd/raw/master/screenshots/search.webp) | ![Records](https://github.com/ahmed24E/nabd/raw/master/screenshots/medical%20records.webp) | ![AI Chat](https://github.com/ahmed24E/nabd/raw/master/screenshots/ai%20assistant.webp) |

---

## ✨ Features

- 🏠 **Home Dashboard** — Personalized greeting, upcoming appointments preview, and quick-access cards
- 📅 **Appointment Booking** — Browse available time slots (AM/PM), pick a slot, add notes, and confirm instantly
- 👨‍⚕️ **Doctor Search** — Real-time search across 100+ doctors by name or specialty
- 🏥 **Hospital Clinics** — Browse clinics and their available doctors
- 📋 **My Appointments** — View upcoming and past appointments with status badges (Scheduled / Cancelled)
- 🗂️ **Medical Records** — Access and manage personal health records offline-first
- 👤 **Patient Profile** — Full personal & contact details with secure logout
- 🤖 **AI Chat** — Medicine analysis and skin analysis via multipart image uploads with structured JSON responses

---

## 🏗️ Architecture

Nabd follows **Clean Architecture** with a strict separation of concerns:

```
lib/
├── core/                        # Shared utilities, theme, network, DI
│   ├── di/                      # Dependency injection (GetIt)
│   ├── network/                 # Dio client, interceptors, connectivity
│   ├── error/                   # Failures & exceptions
│   └── utils/
│
├── features/
│   ├── home/
│   ├── appointments/
│   ├── book_appointment/
│   ├── doctors/
│   ├── medical_records/
│   ├── profile/
│   └── ai_chat/                 # Medicine & skin analysis
│
data/
└── domain/
```

Each feature contains:
```
feature/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── bloc/                    # Events → BLoC → States
    ├── pages/
    └── widgets/
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **UI Framework** | Flutter (Dart) |
| **State Management** | flutter_bloc ^9.1.1 |
| **Architecture** | Clean Architecture |
| **HTTP Client** | Dio ^5.9.2 (with multipart support) |
| **Local Storage** | Hive ^2.2.3 + hive_flutter |
| **Preferences** | shared_preferences ^2.5.4 |
| **Navigation** | Custom bottom nav (circle_nav_bar) |
| **Functional** | dartz ^0.10.1 (Either / Option) |
| **Image Handling** | image_picker ^1.2.2 |
| **File Opening** | open_filex ^4.7.0 |
| **Connectivity** | internet_connection_checker_plus |
| **Date/Time** | intl ^0.20.2 |
| **SVG** | flutter_svg ^2.2.4 |
| **Backend** | C# .NET REST API |
| **Font** | Manrope |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `^3.10.4`
- Dart SDK `^3.x`
- Android Studio / VS Code
- A running instance of the Nabd .NET backend

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/ahmed24E/nabd.git
cd nabd

# 2. Install dependencies
flutter pub get

# 3. Run code generation (for Hive adapters)
dart run build_runner build --delete-conflicting-outputs

# 4. Configure the base URL
# Open lib/core/network/api_constants.dart
# Set your backend base URL (already ends with /api)

# 5. Run the app
flutter run
```

---

## ⚙️ Configuration

In `lib/core/network/api_constants.dart`, set your backend URL:

```dart
class ApiConstants {
  static const String baseUrl = 'https://your-backend.com/api';
  // Endpoint constants do NOT repeat the /api prefix
  static const String doctors = '/doctors';
  static const String appointments = '/appointments';
  // ...
}
```

---

## 📦 Key Packages

```yaml
dependencies:
  flutter_bloc: ^9.1.1       # BLoC state management
  dio: ^5.9.2                # HTTP & multipart image uploads
  hive: ^2.2.3               # Offline-first local storage
  dartz: ^0.10.1             # Functional programming (Either)
  image_picker: ^1.2.2       # Camera / gallery access
  circle_nav_bar: ^2.1.0     # Custom bottom navigation
  internet_connection_checker_plus: ^2.9.1+2  # Connectivity
```

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'feat: add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

---

## 📄 License

This project is for educational and portfolio purposes.

---

<div align="center">

Made with ❤️ using Flutter

**[ahmed24E](https://github.com/ahmed24E)**

</div>
