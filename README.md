
# BudgetLens

An intuitive expense tracker mobile app designed to help users manage and monitor their personal finances. With a user-friendly interface, BudgetLens allows users to easily track their daily expenses, set budgets, and visualize spending trends to maintain financial control and make informed budgeting decisions.

## Introduction

### Overview

**BudgetLens** is an easy-to-use expense tracker app that helps users manage their finances. With a simple interface, it allows users to track daily expenses, set budgets, and visualize spending trends for better financial control and informed decision-making.

### Key Features

- **Expense Management:** Add/edit expenses and set budgets by selecting transaction categories (income/earnings).
- **Expense Overview:** View expenses by categories across week, month, or year.
- **User Accounts:** Register, log in, and manage accounts, including updating profile details and changing passwords.
- **Customization:** Enable dark mode, and set currency and language preferences.
- **Category Management:** Add, edit, and delete expense categories.
- **Analytics:** View analytics for top spending categories.

### Target Audience

- **Freelancers:** Individuals who manage their own finances and need an easy way to track their earnings and expenses.
- **Young professionals:**  People who are starting to manage their finances and need a simple way to track spending.
- **Families:** Users looking to track household expenses and manage shared budgets.
- **Retirees:** Older individuals looking to monitor their fixed income and spending.
- **Budget-conscious consumers:** People looking to save money and manage their personal finances more efficiently.
- **Anyone looking to improve financial literacy:** This app could appeal to anyone wanting to better understand their spending habits.

## Installation & Setup

### System Requirements

- **Flutter Version:** 3.27.2
- **Android Version:** Minimum Android 6.0 (API Level 23)
- **Dependencies**
    * **Flutter packages**
        * **provider:** For state Management
        * **sqflite:** For local storage
        * **firebase_auth:** For user authentication
        * **cloud_firestore:** For cloud database management
        * **fl_chart:** For charts integration
        * **flutter_localizations:** For supporting multiple languages
        * **intl:** For date, time, and number formatting
        * **flag:** For flag icons or country-related functionalities
        * **intl_utils:** For automatic generation of localization files

### Installation Instructions

1. Clone the Repository:
- Open your terminal/command prompt and run
  ```
  git clone https://github.com/mariellecarnecer99/budget-lens.git
  ```

2. Install Dependencies:
- Navigate to the project directory:
  ```
  cd expense_tracker
  ```

- Install the required dependencies
  ```
  flutter pub get
  ```

3. Run the App:
- Connect a physical device or start an emulator
- Run the app with the following command:
  ```
  flutter run
  ```

This will launch the app on your connected device or emulator.


### Configuration: Firebase Setup

To connect your app to Firebase, follow these steps:

1. **Create a Firebase Project:**
- Go to the [Firebase Console](https://console.firebase.google.com/)
- Click on Add Project, and follow the prompts to create a new project.
2. **Add Firebase to Your Android App:**
- In the Firebase console, select your project and click on Add App.
- Choose Android and follow the instructions
3. **Configure Firebase in your Flutter App:**
- Go to [Firebase documentation](https://firebase.google.com/docs/flutter/setup?platform=android) and follow the instructions
4. **Enable Firebase Authentication:**
- In the Firebase console, go to Authentication and enable the sign-in methods you plan to use (e.g., Email/Password, Google, etc.).
5. **Enable Firebase Firestore:**
- In the Firebase console, go to Firestore Database and click on Create Database.
- Set the security rules (you can start with test mode for development).
6. **Sync Firebase Services:**
- After completing these steps, run:
  ```
  flutter clean
  ```
  ```
  flutter pub get
  ```
Your app is now connected to Firebase and ready for use.

## App Architecture

### Tech Stack

The BudgetLens app is built using the following technologies:

- **Flutter:** A UI toolkit for building natively compiled applications for mobile from a single codebase. Flutter is used for creating the user interface and handling app logic.
- **Dart:** The programming language used to write the app’s logic. Dart is fast, easy to learn, and integrates seamlessly with Flutter.
- **Firebase:** Used for backend services, including:
    - **Firebase Authentication:** For user registration and login management.
    - **Cloud Firestore:** For storing and managing user data.
- **Provider:** For state management, ensuring efficient handling of app state and data across different screens.
- **SQLite:** For local storage to persist data when offline and storing and managing user data such as expenses, categories, and budgets.
- **intl & intl_utils:** For handling internationalization and localization of the app (e.g., date, currency, and language preferences).
- **flag:** A package for displaying country flags within the app, useful for supporting multiple currencies or regions.
- **fl_chart:** A library for displaying interactive and customizable charts, used to visualize user spending trends and analytics.
