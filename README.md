# BFU – Finance & Market Tracker

A Flutter mobile application for tracking stocks and cryptocurrency markets in real time. BFU provides a clean, modern interface for exploring assets, managing favourites, reading financial news, and managing your account.

---

## Features

- 📈 **Market Dashboard** – Overview of your watchlist and key market movers
- 🔍 **Explore Markets** – Browse and search stocks & crypto with category filters and sort options
- ⭐ **Favourites** – Bookmark assets for quick access
- 📰 **News Feed** – Latest financial news relevant to your portfolio
- 👤 **User Profile** – Account management and settings
- 🔐 **Authentication** – Secure sign-up, login, and password reset via Supabase Auth

---

## Tech Stack

| Layer        | Technology                        |
|--------------|-----------------------------------|
| Framework    | Flutter (Dart SDK `^3.9.2`)       |
| Backend/Auth | Supabase (`supabase_flutter`)     |
| HTTP Client  | `dio` · `http`                    |
| Market Data  | Alpha Vantage API (stocks & crypto) |
| Forms        | `flutter_form_builder` · `form_builder_validators` |

---

## Project Structure

```
lib/
├── main.dart                  # App entry point, session check & routing
├── pages/
│   ├── dashboard.dart         # Main home/dashboard screen
│   ├── explorepage.dart       # Market explorer (stocks + crypto)
│   ├── newspage.dart          # Financial news feed
│   ├── profilepage.dart       # User profile & settings
│   ├── loginpage.dart         # Login screen
│   ├── signuppage.dart        # Registration screen
│   ├── forgot_password_page.dart  # Password reset flow
│   └── homepage.dart          # Landing/splash page
├── services/
│   ├── supabase_apis.dart     # Auth helpers (sign up, login, reset, sign out)
│   ├── stock_apis.dart        # Alpha Vantage price fetching with mock fallback
│   ├── stock_data_loader.dart # Loads symbol list from local JSON
│   └── news_apis.dart         # News data fetching
└── widget/
    ├── button_widget.dart     # Reusable button component
    └── text_widget.dart       # Reusable text component

assets/
├── stocks.json                # Local symbol list (stocks + crypto)
└── symbols/                   # Per-asset icon images
```

---

## Getting Started

### Prerequisites

- Flutter SDK installed ([flutter.dev](https://flutter.dev/docs/get-started/install))
- Dart SDK `^3.9.2`
- A Supabase project (the app is pre-configured — see `main.dart`)

### Run the app

```bash
flutter pub get
flutter run
```

> The app uses **immersive sticky** system UI mode and checks for an existing Supabase session on launch to decide whether to show the dashboard or the login screen.

---

## Market Data

Stock and crypto prices are fetched from the **Alpha Vantage API**.  
The free tier supports **5 calls/min** and **500 calls/day**. By default the app uses realistic **mock prices with ±2% variation** to avoid hitting rate limits. To enable live prices, see the commented-out block in `lib/services/stock_apis.dart → fetchAllPricesParallel()`.

---

## Authentication

Auth is handled by Supabase with the following flows:

- **Sign up** – Email + password with optional username
- **Sign in** – Email + password
- **Password reset** – Sends a reset link to the user's email
- **Sign out** – Clears the local Supabase session

All auth errors (network failures, invalid credentials, unconfirmed email, etc.) are mapped to user-friendly messages.

---

## Useful Links

- [Flutter Documentation](https://docs.flutter.dev/)
- [Supabase Flutter Docs](https://supabase.com/docs/reference/dart/introduction)
- [Alpha Vantage API](https://www.alphavantage.co/documentation/)
