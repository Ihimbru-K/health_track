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

 /// we will want to use the database so we create an instance
  final DatabaseHelper _dbHelper = DatabaseHelper();

  ///api service class simulates the fetching of motivational quotes data and health data
  final ApiService _apiService = ApiService();

 ///an array to store journal items to be created
  List<JournalEntry> _entries = [];

 ///stores number of times the mood is selected
  Map<String, int> _moodCounts = {};
  int _totalEntries = 0;
  String _motivationalMessage = "";
  int _steps = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// fetches data from the database and mockApis
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

  ///computes the most selected mood
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
        centerTitle: true,
        title: Text(
          "Dashboard",
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.white),
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

  /// custom widget to display stats such as frequent mood and total journal entries

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

  /// widget to display the step count fetched from the mock api service
  Widget _buildStepsCounter() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(0, 2),
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

  ///graph of mood trends for each journal
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
            offset: const Offset(0, 2),
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
                borderData: FlBorderData(show: true),
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

  /// piechart showing various proportions of emojis (moods) selected
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

  /// data structure that stores mood emojis
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

  /// data structure that associates a mood (emoji) to a particular color so it can be used in the piechart
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
