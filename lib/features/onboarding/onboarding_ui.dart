

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:health_track/main.dart';
import '../homescreen/homescreen.dart';
import '../journaling/journaling_ui.dart';
import 'onboarding_controller.dart';
//import '../journaling/journaling_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  final OnboardingController _controller = OnboardingController();
  int _currentPage = 0;
  String motivationalMessage = "";

  @override
  void initState() {
    super.initState();
    _fetchMotivationalMessage();
  }

  Future<void> _fetchMotivationalMessage() async {
    final message = await _controller.getMotivationalMessage();
    setState(() {
      motivationalMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              children: [
                _buildPage(
                  title: "Welcome to WellSpace",
                  description: "Start your journey to better mental health.",
                  image: "lib/assets/images/img.png",
                  animationDelay: Duration(milliseconds: 200),
                ),
                _buildPage(
                  title: "Track Your Progress",
                  description: "Visualize your health metrics and journal entries.",
                  image: "lib/assets/images/health.png",
                  animationDelay: const Duration(milliseconds: 400),
                ),
                _buildMotivationalPage(),
              ],
            ),
          ),
          _buildPageIndicator(),
          //_buildStartButton(),
        ],
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String description,
    required String image,
    required Duration animationDelay,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: image,
            child: Image.asset(image, height: 200.h),
          ),
          SizedBox(height: 20.h),
          AnimatedOpacity(
            opacity: 1.0,
            duration: animationDelay,
            child: Text(
              title,
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationalPage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Stay Motivated",
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.h),
          motivationalMessage.isEmpty
              ? const CircularProgressIndicator()
              : AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                motivationalMessage,
                textStyle: TextStyle(fontSize: 18.sp),
                speed: const Duration(milliseconds: 100),
              ),
            ],
            isRepeatingAnimation: false,
          ),
          SizedBox(height: 40.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()

                   // JournalingScreen()




                ),
              );
            },
            child: Text("Start Journaling"),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
            (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: _currentPage == index ? 12.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: _currentPage == index ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ),
    );
  }

  // Widget _buildStartButton() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 20.h),
  //     child: ElevatedButton(
  //       onPressed: _currentPage == 2
  //           ? () {
  //         // Navigator.pushReplacement(
  //         //   context,
  //         //   MaterialPageRoute(builder: (_) => JournalingScreen()),
  //         // );
  //       }
  //           : null,
  //       child: Text("Start Journaling"),
  //     ),
  //   );
  // }
}












































//
// class OnboardingScreen extends StatefulWidget {
//   @override
//   _OnboardingScreenState createState() => _OnboardingScreenState();
// }
//
// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//   String motivationalMessage = "You're doing great! Keep it up!";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Expanded(
//             child: PageView(
//               controller: _pageController,
//               onPageChanged: (index) => setState(() => _currentPage = index),
//               children: [
//                 _buildPage(
//                   title: "Welcome to WellSpace",
//                   description: "Start your journey to better mental health.",
//                   image: "assets/images/journal.png",
//                 ),
//                 _buildPage(
//                   title: "Track Your Progress",
//                   description:
//                   "Visualize your health metrics and journal entries.",
//                   image: "assets/images/metrics.png",
//                 ),
//                 _buildMotivationalPage(),
//               ],
//             ),
//           ),
//           _buildPageIndicator(),
//           _buildStartButton(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPage({required String title, required String description, required String image}) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset(image, height: 200.h),
//           SizedBox(height: 20.h),
//           Text(
//             title,
//             style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 10.h),
//           Text(
//             description,
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 16.sp),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMotivationalPage() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.w),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             "Stay Motivated",
//             style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 20.h),
//           AnimatedTextKit(
//             animatedTexts: [
//               TypewriterAnimatedText(
//                 motivationalMessage,
//                 textStyle: TextStyle(fontSize: 18.sp),
//                 speed: Duration(milliseconds: 100),
//               ),
//             ],
//             isRepeatingAnimation: false,
//           ),
//           SizedBox(height: 40.h),
//           ElevatedButton(
//             onPressed: () {
//               // Navigator.pushReplacement(
//               //   context,
//               //   MaterialPageRoute(builder: (_) => JournalingScreen()),
//               // );
//             },
//             child: Text("Start Journaling"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPageIndicator() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(
//         3,
//             (index) => Container(
//           margin: EdgeInsets.symmetric(horizontal: 4.w),
//           width: _currentPage == index ? 12.w : 8.w,
//           height: 8.h,
//           decoration: BoxDecoration(
//             color: _currentPage == index ? Colors.blue : Colors.grey,
//             borderRadius: BorderRadius.circular(4.r),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStartButton() {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 20.h),
//       child: ElevatedButton(
//         onPressed: _currentPage == 2
//             ? () {
//           // Navigator.pushReplacement(
//           //   context,
//           //   MaterialPageRoute(builder: (_) =>
//           //      // JournalingScreen()
//           //   ),
//           // );
//         }
//             : null,
//         child: Text("Start Journaling"),
//       ),
//     );
//   }
// }
