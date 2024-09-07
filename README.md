# Task Management App

## Overview

This Flutter project is a task management app that allows users to create, update, delete, and view their tasks. It also includes a random quote generator that displays a new quote each time the app is opened. Local notifications are integrated to remind users of task deadlines. The project uses Flutter's clean architecture with BLoC state management and shared preferences for local storage.

## Features

- **Task Management**: Create, update, delete, and view tasks.
- **Random Quote Generator**: Display a random quote on app launch.
- **Local Notifications**: Notify users of task deadlines.
- **Local Storage**: Use shared preferences for storing user data.

## Prerequisites

- Flutter SDK
- Dart SDK
- An IDE (e.g., VSCode, Android Studio)

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/Muluken-Zewge/Task-Management-App.git
cd Task-Management-App
```

### 2. Install Dependencies

Run the following command to install the required dependencies:

```bash
flutter pub get
```

### 3. Run the App

To run the app on an emulator or a physical device, use:

```bash
flutter run
```

# Architecture

The project follows the clean architecture principles with the following layers:

- **Presentation Layer**: Contains UI and BLoC state management.
- **Domain Layer**: Contains business logic and use cases.
- **Data Layer**: Handles data sources and repositories.
