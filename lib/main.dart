







import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_track/features/onboarding/onboarding_ui.dart';
import 'package:hive/hive.dart';

void main() async{
  // WidgetsFlutterBinding.ensureInitialized();
  // await Hive.init(path);
  //
  // // Register the adapter for your custom class (JournalEntry in this case).
  // Hive.registerAdapter(JournalEntryAdapter());
  //
  // // Open the box before running the app.
  // await Hive.openBox<JournalEntry>('journal_entries');


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: OnboardingScreen(),
        );
      },
    );
  }
}















