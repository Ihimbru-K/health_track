import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'features/dashboard/dashboard_ui.dart';
import 'features/journaling/journaling_ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: (_, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Health Journal App',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    JournalingScreen(),
    DashboardScreen(), // Add the DashboardScreen here
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey.shade600,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Dashboard',
          ),
        ],
      ),
    );
  }
}






















//
//
//
//
//
//
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:health_track/features/dashboard/dashboard_ui.dart';
// import 'package:health_track/features/onboarding/onboarding_ui.dart';
// import 'package:hive/hive.dart';
//
// void main() async{
//   // WidgetsFlutterBinding.ensureInitialized();
//   // await Hive.init(path);
//   //
//   // // Register the adapter for your custom class (JournalEntry in this case).
//   // Hive.registerAdapter(JournalEntryAdapter());
//   //
//   // // Open the box before running the app.
//   // await Hive.openBox<JournalEntry>('journal_entries');
//
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(375, 812),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'Flutter Demo',
//           theme: ThemeData(
//             colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//             useMaterial3: true,
//           ),
//     home: OnboardingScreen(),
//           //home: DashboardScreen()
//
//         );
//       },
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
