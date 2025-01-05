# Health Track

Health Track is a comprehensive Flutter-based mobile application designed to assist users in monitoring their daily health metrics and emotional well-being. The app offers features such as mood journaling, activity tracking, and insightful dashboards to provide a holistic view of the user's health journey.

## Features

- **Onboarding Experience**: A onboarding process introduces users to the app's functionalities, ensuring a smooth start with motivational msg animated on the last onboarding ui.

- **Animations**: Engaging animations enhance user interaction, making the app experience delightful and intuitive.

- **Mood Journaling**: Users can log their daily moods with accompanying notes, facilitating emotional self-awareness.

- **Dashboard**: A centralized hub displaying key health statistics, mood trends, and activity summaries in the form of cards, graphs and piecharts.

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- [Android Studio](https://developer.android.com/studio) or [Xcode](https://developer.apple.com/xcode/)

### Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/Ihimbru-K/health_track.git
   cd health_track
Install dependencies:

   
    flutter pub get
Run the application:


    flutter run



# App Overview

## Onboarding

Upon launching Health Track for the first time, users are greeted with an interactive onboarding experience that highlights the app's core features and benefits.
![image](https://github.com/user-attachments/assets/2a60488e-8353-4dc6-b767-72a7df9a9671)


Description: The onboarding screens guiding users through the app's functionalities.

## Animations

The app incorporates smooth animations to enhance user engagement and provide a fluid navigation experience.

![image](https://github.com/user-attachments/assets/7e6fba07-e5ba-4493-b2bf-c1fc9bc04cb5)


animation

![image](https://github.com/user-attachments/assets/487fcbdc-d943-4f1f-84c1-9e5430c77a3f)



Description: Example of in-app animations enhancing user interaction.

## Mood Journaling

Users can record their daily moods by selecting from a range of emoticons and adding personal notes, promoting regular self-reflection.
![image](https://github.com/user-attachments/assets/e70ae15f-2a23-4f49-8900-54c2aec1dcb8)
![image](https://github.com/user-attachments/assets/00138e1f-d208-4a4a-ba19-22dd6709cda3)



##fetched journal items from sqlite database
![image](https://github.com/user-attachments/assets/a26174dc-9516-4a58-aa35-15f984265ae6)





Description: The mood journaling interface where users log their emotions and thoughts.

## Dashboard

The dashboard provides a comprehensive overview of the user's health data, including mood trends, activity levels, and personalized insights.

![dashboard](https://github.com/user-attachments/assets/f79c3bd9-d641-4dec-9b30-ed30855d4876)




piechart and graph
![image](https://github.com/user-attachments/assets/396674b8-2332-47ab-a0a4-bbee6f470769)




Description: The main dashboard displaying key health statistics and trends.

## Project Structure

The project is organized as follows:

- **lib/**: Contains the main application code.
- **screens/**: UI screens such as onboarding, journaling, and dashboard.
- **services/**: Services for data management and API interactions.
- **models/**: Data models representing user entries and health metrics.
- **widgets/**: Reusable UI components.
- **assets/**: Contains images, icons, and other static resources.
- **test/**: Unit and widget tests for the application.

## Dependencies.

The application utilizes several Flutter packages:

- **flutter_screenutil**: For responsive UI design.
- **fl_chart**: To render interactive charts and graphs.
- **sqflite**: SQLite plugin for local database storage.
- **http**: For making HTTP requests to fetch data.
- **animations**: To implement smooth and customizable animations.

## Contributing

```dart
 ///creates unique id, inputed text, mood and date data table for storing journal items
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'journal.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE journal_entries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            text TEXT,
            mood TEXT,
            date TEXT
          )
        ''');
      },
      version: 1,
    );
  }
```

We welcome contributions! To get started:

1. Fork the repository.
2. Create a new branch: `git checkout -b feature-branch-name`.
3. Make your changes and commit them: `git commit -m 'Add new feature'`.
4. Push to the branch: `git push origin feature-branch-name`.
5. Submit a pull request detailing your changes.


