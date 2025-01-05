import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/themes.dart';
import '../journaling/database_helper.dart';
import '../journaling/journal_entry.dart';
import '../../services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final ApiService _apiService = ApiService();
  List<JournalEntry> _entries = [];
  Map<String, int> _moodCounts = {};
  int _totalEntries = 0;
  String _motivationalMessage = "";
  int _steps = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final message = await _apiService.fetchMotivationalMessage();
    final wearableData = await _apiService.fetchWearableData();
    final entries = await _dbHelper.getEntries();

    setState(() {
      _motivationalMessage = message;
      _steps = wearableData['steps'];
      _entries = entries.map((e) => JournalEntry.fromMap(e)).toList();
      _totalEntries = _entries.length;
      _calculateMoodCounts();
    });
  }

  void _calculateMoodCounts() {
    final counts = <String, int>{};
    for (var entry in _entries) {
      counts[entry.mood] = (counts[entry.mood] ?? 0) + 1;
    }
    setState(() {
      _moodCounts = counts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildKeyStats(),
              SizedBox(height: 16.h),
              _buildStepsCounter(), // Add steps counter here
              SizedBox(height: 20.h),
              _buildMoodTrendsGraph(),
              SizedBox(height: 20.h),
              _buildMoodDistributionChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeyStats() {
    final mostFrequentMood = _moodCounts.entries.isEmpty
        ? "N/A"
        : _moodCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatCard("Total Entries", _totalEntries.toString(), Colors.green),
        _buildStatCard("Frequent Mood", mostFrequentMood, Colors.blue),
        _buildStatCard(
          "Avg/Day",
          (_totalEntries / (_entries.isNotEmpty ? _entries.length : 1))
              .toStringAsFixed(1),
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepsCounter() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.directions_walk, color: Colors.blue.shade600, size: 30),
          SizedBox(width: 12.w),
          Text(
            "Steps Today: $_steps",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodTrendsGraph() {
    final spots = _entries.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), _mapMoodToValue(entry.value.mood));
    }).toList();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mood Trends",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 200.h,
            child: LineChart(
              LineChartData(
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(show: true),
                gridData: FlGridData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodDistributionChart() {
    final data = _moodCounts.entries.map((e) {
      return PieChartSectionData(
        value: e.value.toDouble(),
        title: "${e.value}",
        color: _mapMoodToColor(e.key),
        titleStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mood Distribution",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 200.h,
            child: PieChart(PieChartData(sections: data)),
          ),
        ],
      ),
    );
  }

  double _mapMoodToValue(String mood) {
    switch (mood) {
      case "😊":
        return 4.0;
      case "😌":
        return 3.0;
      case "😁":
        return 5.0;
      case "😢":
        return 2.0;
      case "😡":
        return 1.0;
      default:
        return 0.0;
    }
  }

  Color _mapMoodToColor(String mood) {
    switch (mood) {
      case "😊":
        return Colors.green;
      case "😌":
        return Colors.blue;
      case "😁":
        return Colors.yellow;
      case "😢":
        return Colors.red;
      case "😡":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}


































// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fl_chart/fl_chart.dart';
//
// import '../../core/themes.dart';
// import '../journaling/database_helper.dart';
// import '../journaling/journal_entry.dart';
//
// class DashboardScreen extends StatefulWidget {
//   @override
//   _DashboardScreenState createState() => _DashboardScreenState();
// }
//
// class _DashboardScreenState extends State<DashboardScreen> {
//   final DatabaseHelper _dbHelper = DatabaseHelper();
//   List<JournalEntry> _entries = [];
//   Map<String, int> _moodCounts = {};
//   int _totalEntries = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }
//
//   Future<void> _loadData() async {
//     final entries = await _dbHelper.getEntries();
//     setState(() {
//       _entries = entries.map((e) => JournalEntry.fromMap(e)).toList();
//       _totalEntries = _entries.length;
//       _calculateMoodCounts();
//     });
//   }
//
//   void _calculateMoodCounts() {
//     final counts = <String, int>{};
//     for (var entry in _entries) {
//       counts[entry.mood] = (counts[entry.mood] ?? 0) + 1;
//     }
//     setState(() {
//       _moodCounts = counts;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Dashboard",
//           style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.green.shade700,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.w),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildKeyStats(),
//               SizedBox(height: 20.h),
//               _buildMoodTrendsGraph(),
//               SizedBox(height: 20.h),
//               _buildMoodDistributionChart(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildKeyStats() {
//     final mostFrequentMood = _moodCounts.entries.isEmpty
//         ? "N/A"
//         : _moodCounts.entries
//         .reduce((a, b) => a.value > b.value ? a : b)
//         .key;
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         _buildStatCard("Total Entries", _totalEntries.toString(), Colors.green),
//         _buildStatCard("Frequent Mood", mostFrequentMood, Colors.blue),
//         _buildStatCard(
//           "Avg/Day",
//           (_totalEntries / (_entries.isNotEmpty ? _entries.length : 1))
//               .toStringAsFixed(1),
//           Colors.orange,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatCard(String label, String value, Color color) {
//     return Expanded(
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: 4.w),
//         padding: EdgeInsets.all(12.w),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         child: Column(
//           children: [
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 20.sp,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//             SizedBox(height: 8.h),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMoodTrendsGraph() {
//     final spots = _entries.asMap().entries.map((entry) {
//       return FlSpot(entry.key.toDouble(), _mapMoodToValue(entry.value.mood));
//     }).toList();
//
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade300,
//             offset: Offset(0, 2),
//             blurRadius: 4,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Mood Trends",
//             style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
//           ),
//           SizedBox(height: 16.h),
//           SizedBox(
//             height: 200.h,
//             child: LineChart(
//               LineChartData(
//                 borderData: FlBorderData(show: false),
//                 titlesData: FlTitlesData(show: true),
//                 gridData: FlGridData(show: false),
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: spots,
//                     isCurved: true,
//                     color: Colors.green,
//                     barWidth: 4,
//                     isStrokeCapRound: true,
//                     belowBarData: BarAreaData(show: false),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMoodDistributionChart() {
//     final data = _moodCounts.entries.map((e) {
//       return PieChartSectionData(
//         value: e.value.toDouble(),
//         title: "${e.value}",
//         color: _mapMoodToColor(e.key),
//         titleStyle: TextStyle(
//           fontSize: 14.sp,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       );
//     }).toList();
//
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade300,
//             offset: Offset(0, 2),
//             blurRadius: 4,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Mood Distribution",
//             style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
//           ),
//           SizedBox(height: 16.h),
//           SizedBox(
//             height: 200.h,
//             child: PieChart(PieChartData(sections: data)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   double _mapMoodToValue(String mood) {
//     switch (mood) {
//       case "😊":
//         return 4.0;
//       case "😌":
//         return 3.0;
//       case "😁":
//         return 5.0;
//       case "😢":
//         return 2.0;
//       case "😡":
//         return 1.0;
//       default:
//         return 0.0;
//     }
//   }
//
//   Color _mapMoodToColor(String mood) {
//     switch (mood) {
//       case "😊":
//         return Colors.green;
//       case "😌":
//         return Colors.blue;
//       case "😁":
//         return Colors.yellow;
//       case "😢":
//         return Colors.red;
//       case "😡":
//         return Colors.orange;
//       default:
//         return Colors.grey;
//     }
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
// // import 'package:flutter/material.dart';
// // import 'package:fl_chart/fl_chart.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// //
// // import '../../services/api_service.dart';
// // import '../journaling/journal_entry.dart';
// //
// // class DashboardScreen extends StatelessWidget {
// //   final List<JournalEntry> journalEntries;
// //   final Map<String, dynamic> wearableData;
// //
// //   DashboardScreen({required this.journalEntries, required this.wearableData});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(
// //           "Dashboard",
// //           style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
// //         ),
// //         backgroundColor: Colors.green.shade700,
// //         centerTitle: true,
// //       ),
// //       body: SingleChildScrollView(
// //         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             _buildSummarySection(),
// //             SizedBox(height: 24.h),
// //             _buildMoodTrendGraph(),
// //             SizedBox(height: 24.h),
// //             _buildStepTrendChart(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildSummarySection() {
// //     final moods = journalEntries.map((entry) => entry.mood).toList();
// //     final mostFrequentMood = _getMostFrequentMood(moods);
// //     final totalSteps = wearableData['steps'] ?? 0;
// //
// //     return Container(
// //       padding: EdgeInsets.all(16.w),
// //       decoration: BoxDecoration(
// //         color: Colors.green.shade50,
// //         borderRadius: BorderRadius.circular(12.r),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.shade300,
// //             offset: Offset(0, 2),
// //             blurRadius: 4,
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             "Summary",
// //             style: TextStyle(
// //               fontSize: 18.sp,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.green.shade800,
// //             ),
// //           ),
// //           SizedBox(height: 12.h),
// //           Text(
// //             "Most Frequent Mood: $mostFrequentMood",
// //             style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade700),
// //           ),
// //           Text(
// //             "Total Steps This Week: $totalSteps",
// //             style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade700),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildMoodTrendGraph() {
// //     final moodTrends = _getMoodTrends(journalEntries);
// //
// //     return Container(
// //       padding: EdgeInsets.all(16.w),
// //       decoration: BoxDecoration(
// //         color: Colors.blue.shade50,
// //         borderRadius: BorderRadius.circular(12.r),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.shade300,
// //             offset: Offset(0, 2),
// //             blurRadius: 4,
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             "Mood Trends",
// //             style: TextStyle(
// //               fontSize: 18.sp,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.blue.shade800,
// //             ),
// //           ),
// //           SizedBox(height: 12.h),
// //           AspectRatio(
// //             aspectRatio: 1.5,
// //             child: LineChart(
// //               LineChartData(
// //                 gridData: FlGridData(show: false),
// //                 titlesData: FlTitlesData(show: true),
// //                 borderData: FlBorderData(show: true),
// //                 minX: 0,
// //                 maxX: moodTrends.length.toDouble(),
// //                 minY: 1,
// //                 maxY: 5,
// //                 lineBarsData: [
// //                   LineChartBarData(
// //                     spots: moodTrends
// //                         .asMap()
// //                         .entries
// //                         .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
// //                         .toList(),
// //                     isCurved: true,
// //                     color: Colors.blue,
// //                     dotData: FlDotData(show: false),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildStepTrendChart() {
// //     final steps = _getWeeklyStepData(wearableData);
// //
// //     return Container(
// //       padding: EdgeInsets.all(16.w),
// //       decoration: BoxDecoration(
// //         color: Colors.orange.shade50,
// //         borderRadius: BorderRadius.circular(12.r),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.shade300,
// //             offset: Offset(0, 2),
// //             blurRadius: 4,
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             "Steps Trends",
// //             style: TextStyle(
// //               fontSize: 18.sp,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.orange.shade800,
// //             ),
// //           ),
// //           SizedBox(height: 12.h),
// //           AspectRatio(
// //             aspectRatio: 1.5,
// //             child: BarChart(
// //               BarChartData(
// //                 gridData: FlGridData(show: false),
// //                 titlesData: FlTitlesData(show: true),
// //                 borderData: FlBorderData(show: true),
// //                 barGroups: steps
// //                     .asMap()
// //                     .entries
// //                     .map(
// //                       (e) => BarChartGroupData(
// //                     x: e.key,
// //                     barRods: [
// //                       BarChartRodData(
// //                         toY: e.value.toDouble(),
// //                         color: Colors.orange,
// //                         width: 12.w,
// //                       ),
// //                     ],
// //                   ),
// //                 )
// //                     .toList(),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   String _getMostFrequentMood(List<String> moods) {
// //     final moodCount = <String, int>{};
// //     for (final mood in moods) {
// //       moodCount[mood] = (moodCount[mood] ?? 0) + 1;
// //     }
// //     return moodCount.entries
// //         .reduce((a, b) => a.value > b.value ? a : b)
// //         .key;
// //   }
// //
// //   List<int> _getMoodTrends(List<JournalEntry> entries) {
// //     return entries.map((entry) => entry.mood.codeUnitAt(0)).toList();
// //   }
// //
// //   List<int> _getWeeklyStepData(Map<String, dynamic> wearableData) {
// //     return List.generate(7, (index) => wearableData['steps'] ?? 0);
// //   }
// // }
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// // // import 'package:flutter/material.dart';
// // // import 'package:fl_chart/fl_chart.dart';
// // // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // //
// // // import '../journaling/database_helper.dart';
// // //
// // //
// // // class DashboardScreen extends StatefulWidget {
// // //   @override
// // //   _DashboardScreenState createState() => _DashboardScreenState();
// // // }
// // //
// // // class _DashboardScreenState extends State<DashboardScreen> {
// // //   final DatabaseHelper _dbHelper = DatabaseHelper();
// // //
// // //   List<FlSpot> _moodTrendData = [];
// // //   Map<String, int> _moodFrequency = {};
// // //   int _totalEntries = 0;
// // //   String _mostCommonMood = "";
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _loadDashboardData();
// // //   }
// // //
// // //   Future<void> _loadDashboardData() async {
// // //     final entries = await _dbHelper.getEntries();
// // //     final List<DateTime> dates = [];
// // //     final Map<String, int> moodCounts = {};
// // //
// // //     entries.forEach((entry) {
// // //       final mood = entry['mood'];
// // //       final date = DateTime.parse(entry['date']);
// // //       dates.add(date);
// // //       moodCounts[mood] = (moodCounts[mood] ?? 0) + 1;
// // //     });
// // //
// // //     setState(() {
// // //       _totalEntries = entries.length;
// // //       _mostCommonMood = moodCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
// // //       _moodFrequency = moodCounts;
// // //
// // //       // Generate line chart data
// // //       final groupedByDate = <String, double>{};
// // //       for (final date in dates) {
// // //         final dateKey = "${date.year}-${date.month}-${date.day}";
// // //         groupedByDate[dateKey] = (groupedByDate[dateKey] ?? 0) + 1;
// // //       }
// // //
// // //       _moodTrendData = groupedByDate.entries
// // //           .map((e) => FlSpot(dates.indexOf(DateTime.parse(e.key)).toDouble(), e.value))
// // //           .toList();
// // //     });
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text(
// // //           "Dashboard",
// // //           style: TextStyle(
// // //             fontSize: 22.sp,
// // //             fontWeight: FontWeight.bold,
// // //           ),
// // //         ),
// // //         backgroundColor: Colors.green.shade700,
// // //       ),
// // //       body: SingleChildScrollView(
// // //         padding: EdgeInsets.all(16.w),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             _buildSummarySection(),
// // //             SizedBox(height: 20.h),
// // //             _buildLineChart(),
// // //             SizedBox(height: 20.h),
// // //             _buildBarChart(),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildSummarySection() {
// // //     return Container(
// // //       padding: EdgeInsets.all(16.w),
// // //       decoration: BoxDecoration(
// // //         color: Colors.green.shade50,
// // //         borderRadius: BorderRadius.circular(12.r),
// // //         boxShadow: [
// // //           BoxShadow(
// // //             color: Colors.grey.shade300,
// // //             offset: Offset(0, 2),
// // //             blurRadius: 4,
// // //           ),
// // //         ],
// // //       ),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Text(
// // //             "Summary",
// // //             style: TextStyle(
// // //               fontSize: 20.sp,
// // //               fontWeight: FontWeight.bold,
// // //               color: Colors.green.shade800,
// // //             ),
// // //           ),
// // //           SizedBox(height: 10.h),
// // //           Text(
// // //             "Total Entries: $_totalEntries",
// // //             style: TextStyle(fontSize: 16.sp),
// // //           ),
// // //           Text(
// // //             "Most Common Mood: $_mostCommonMood",
// // //             style: TextStyle(fontSize: 16.sp),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildLineChart() {
// // //     return Container(
// // //       padding: EdgeInsets.all(16.w),
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //         borderRadius: BorderRadius.circular(12.r),
// // //         boxShadow: [
// // //           BoxShadow(
// // //             color: Colors.grey.shade300,
// // //             offset: Offset(0, 2),
// // //             blurRadius: 4,
// // //           ),
// // //         ],
// // //       ),
// // //       child: Column(
// // //         children: [
// // //           Text(
// // //             "Mood Trends",
// // //             style: TextStyle(
// // //               fontSize: 18.sp,
// // //               fontWeight: FontWeight.bold,
// // //             ),
// // //           ),
// // //           SizedBox(height: 10.h),
// // //           SizedBox(
// // //             height: 200.h,
// // //             child: LineChart(
// // //               LineChartData(
// // //                 gridData: FlGridData(show: true),
// // //                 borderData: FlBorderData(show: true),
// // //                 titlesData: FlTitlesData(show: true),
// // //                 lineBarsData: [
// // //                   LineChartBarData(
// // //                     spots: _moodTrendData,
// // //                     isCurved: true,
// // //                     color: Colors.green,
// // //                     barWidth: 4,
// // //                     isStrokeCapRound: true,
// // //                     belowBarData: BarAreaData(show: true, color: Colors.green.shade100),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildBarChart() {
// // //     final moodData = _moodFrequency.entries.toList();
// // //
// // //     return Container(
// // //       padding: EdgeInsets.all(16.w),
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //         borderRadius: BorderRadius.circular(12.r),
// // //         boxShadow: [
// // //           BoxShadow(
// // //             color: Colors.grey.shade300,
// // //             offset: Offset(0, 2),
// // //             blurRadius: 4,
// // //           ),
// // //         ],
// // //       ),
// // //       child: Column(
// // //         children: [
// // //           Text(
// // //             "Mood Frequencies",
// // //             style: TextStyle(
// // //               fontSize: 18.sp,
// // //               fontWeight: FontWeight.bold,
// // //             ),
// // //           ),
// // //           SizedBox(height: 10.h),
// // //           SizedBox(
// // //             height: 200.h,
// // //             child: BarChart(
// // //               BarChartData(
// // //                 gridData: FlGridData(show: false),
// // //                 titlesData: FlTitlesData(show: true),
// // //                 borderData: FlBorderData(show: false),
// // //                 barGroups: moodData.map((e) {
// // //                   return BarChartGroupData(
// // //                     x: moodData.indexOf(e),
// // //                     barRods: [
// // //                       BarChartRodData(
// // //                         fromY: e.value.toDouble(),
// // //                         color: Colors.blue.shade600, toY: 0.0,
// // //                       ),
// // //                     ],
// // //                   );
// // //                 }).toList(),
// // //               ),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
