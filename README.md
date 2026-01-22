# FinanceCal 💰

A comprehensive Flutter-based mobile application for advanced financial calculations and analysis. FinanceCal provides multiple calculators and tools to help users manage their finances effectively.

## 📋 Table of Contents
- [Features](#features)
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Usage](#usage)
- [Technology Stack](#technology-stack)
- [Contributing](#contributing)
- [License](#license)

## ✨ Features

FinanceCal offers a rich set of financial calculation tools:

### Available Calculators
- **Simple Calculator** - Basic arithmetic calculations
- **EMI Calculator** - Equated Monthly Installment calculations for loans
- **FD Calculator** - Fixed Deposit returns and interest calculations
- **RD Calculator** - Recurring Deposit calculations
- **PPF Calculator** - Public Provident Fund investment analysis
- **Loan Comparison** - Compare multiple loan options side-by-side
- **History Screen** - Track and view all previous calculations

### Key Features
- 🎨 Clean and intuitive user interface
- 📱 Fully responsive mobile design
- 🔒 Secure local data management
- 🌓 Dark/Light theme support
- 📊 Detailed calculation breakdowns
- 💾 Calculation history tracking
- ⚡ Fast and lightweight performance

## 📁 Project Structure

```
financecal/
├── models/              # Data models and entity classes
├── screens/             # UI screens for different calculators
│   ├── home_screen.dart
│   ├── calculators_screen.dart
│   ├── emi_calculator_screen.dart
│   ├── fd_calculator_screen.dart
│   ├── rd_calculator_screen.dart
│   ├── ppf_calculator_screen.dart
│   ├── compare_loans_screen.dart
│   ├── history_screen.dart
│   └── main_navigation.dart
├── services/            # Business logic and API services
├── utils/               # Utility functions and helpers
├── widgets/             # Reusable custom widgets
├── main.dart            # Application entry point
└── README.md            # This file
```

## 🚀 Installation

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio or Xcode (for emulator/device testing)

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/vivekx11/financecal.git
   cd financecal
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

4. **Build for release**
   ```bash
   # Android
   flutter build apk
   
   # iOS
   flutter build ios
   ```

## 💡 Usage

### Running Calculations

1. Launch the app and select the desired calculator from the home screen
2. Enter the required financial parameters
3. View instant calculation results with detailed breakdowns
4. Save calculations to history for future reference
5. Compare results across multiple calculators

### Navigation

- **Home Screen**: Main entry point with calculator options
- **Individual Calculators**: Dedicated screens for each calculation type
- **History**: View all previous calculations
- **Settings**: Theme and preference management

## 🛠️ Technology Stack

- **Framework**: Flutter 3.x+
- **Language**: Dart
- **State Management**: Provider / Riverpod
- **UI Components**: Material Design 3
- **Local Storage**: Shared Preferences / SQLite
- **Architecture**: MVC/MVVM pattern

## 📦 Dependencies

Key packages used in the project:
- `flutter/material` - Material Design components
- `provider` - State management
- `shared_preferences` - Local data persistence
- `intl` - Internationalization and formatting

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Code Standards
- Follow Dart style guide
- Add meaningful comments to complex logic
- Write unit tests for new features
- Ensure all tests pass before submitting PR

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🔗 Links

- GitHub: [vivekx11/financecal](https://github.com/vivekx11/financecal)
- Issues: [Report Issues](https://github.com/vivekx11/financecal/issues)
- Discussions: [Join Discussion](https://github.com/vivekx11/financecal/discussions)

## 📧 Contact & Support

For questions, suggestions, or bug reports, please open an issue on GitHub.

---

**Made with ❤️ by Vivek Sawji**
