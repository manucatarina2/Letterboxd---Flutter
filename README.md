# Letterboxd Clone

A **Flutter** mobile application that mimics the core experience of Letterboxd: discover movies, view a personalized feed, write reviews, and manage a profile. The app integrates with **Supabase** for authentication, data storage, and real‑time CRUD operations.

---

## ✨ Features
- **Feed** – Highlight carousel with trending movies and a list of recent reviews.
- **Discover** – Search for movies, view results in a responsive grid.
- **Profile** – View personal info, watched movies, and logout.
- **Settings** – Accessible from the top‑right corner of Feed, Discover, and Profile screens. Includes a dark‑mode toggle (placeholder) and a logout button.
- **Edit Profile** – (In‑progress) UI to edit username, avatar URL and bio.
- **Authentication flow** – `Signup → Login → Feed` navigation with Supabase.
- **Review likes** – Toggle likes with proper handling of unique‑constraint errors.
- **Database seeding** – Utility to seed sample movies (development mode).

---

## 📱 Screens
| Screen | Description |
| ------ | ----------- |
| **Feed** | Highlights, recent reviews, settings icon. |
| **Discover** | Search bar, movie grid, settings icon. |
| **Profile** | User avatar, bio, list of watched movies, logout. |
| **Settings** | Dark‑mode toggle, logout button. |
| **Signup / Login** | Simple email‑password auth. |

---

## 🛠️ Technical Stack
- **Flutter** (stable channel) – UI framework.
- **Provider** – State management.
- **Supabase Flutter** – Backend‑as‑a‑service (auth, PostgreSQL, storage, RPC).
- **Dart** – Language.
- **Material Design 3** – Visual components.

---

## 🚀 Getting Started
### Prerequisites
- Flutter SDK (>=3.19) – see <https://flutter.dev/docs/get-started/install>
- A Supabase project. Create one at <https://supabase.com> and note the `url` and `anonKey`.
- (Optional) Android Studio / VS Code for IDE support.

### Installation
1. Clone the repository (or copy the project folder).
2. Open a terminal in the project root (`letterboxd_flutter`).
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Configure Supabase credentials in `lib/main.dart` (replace the placeholder URL and anon‑key).

### Running the App
- **Debug** (hot‑reload) on a connected device or emulator:
  ```bash
  flutter run
  ```
- **Release build** for Android:
  ```bash
  flutter build apk --release
  ```
  For iOS, use Xcode's archive workflow.

---

## 📦 Project Structure
```
lib/
├─ models/            # Data classes (Movie, Review, UserProfile)
├─ screens/           # UI pages (Feed, Discover, Profile, Settings, Login, Signup)
├─ services/          # SupabaseService – API wrapper
├─ widgets/           # Reusable UI components (MovieGrid, ReviewCard, ProfileHeader)
├─ main.dart          # App entry point & theme configuration
└─ ...
```

---

## 🧩 Extending the App
- **Theme Provider** – Implement a proper dark‑mode toggle using `ChangeNotifierProvider`.
- **Edit Profile UI** – Replace the placeholder dialog with a functional form that calls `SupabaseService.updateUserProfile`.
- **Movie seeding** – Add a dev‑only command in `main.dart` to call `seedSampleMovies` on first launch.
- **Unit/Widget tests** – Add tests for service methods and UI widgets.

---

## 🙋‍♀️ Contributing
Contributions are welcome! Please open an issue or pull request.

1. Fork the repository.
2. Create a feature branch.
3. Ensure code follows existing style (null‑safety, lint rules).
4. Submit a PR.

---

## 📄 License
This project is licensed under the MIT License.
