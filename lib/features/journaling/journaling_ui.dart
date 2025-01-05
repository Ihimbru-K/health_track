

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../services/api_service.dart';
import 'database_helper.dart';
import 'journal_entry.dart';

class JournalingScreen extends StatefulWidget {
  @override
  _JournalingScreenState createState() => _JournalingScreenState();
}

class _JournalingScreenState extends State<JournalingScreen> {
  final TextEditingController _textController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final ApiService _apiService = ApiService();

  String _motivationalMessage = "";
  int _steps = 0;
  String _selectedMood = "😊";
  List<JournalEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _fetchEntries();
    _loadData();
  }

  Future<void> _loadData() async {
    final message = await _apiService.fetchMotivationalMessage();
    final wearableData = await _apiService.fetchWearableData();

    setState(() {
      _motivationalMessage = message;
      _steps = wearableData['steps'];
    });
  }

  Future<void> _fetchEntries() async {
    final entries = await _dbHelper.getEntries();
    setState(() {
      _entries = entries.map((e) => JournalEntry.fromMap(e)).toList();
    });
  }

  Future<void> _saveEntry() async {
    final entry = JournalEntry(
      text: _textController.text,
      mood: _selectedMood,
      date: DateTime.now(),
    );
    await _dbHelper.insertEntry(entry.toMap());
    _textController.clear();
    _fetchEntries();
  }

  Future<void> _deleteEntry(int id) async {
    await _dbHelper.deleteEntry(id);
    _fetchEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Health Journal",
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade700,
        elevation: 4,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMotivationalMessage(),
              SizedBox(height: 16.h),
              _buildStepsCounter(),
              SizedBox(height: 24.h),
              _buildJournalInput(),
              SizedBox(height: 24.h),
              _buildMoodSelectorAndSaveButton(),
              SizedBox(height: 24.h),
              _buildJournalEntriesList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMotivationalMessage() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
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
          Icon(Icons.lightbulb, color: Colors.amber.shade600, size: 30),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              _motivationalMessage,
              style: TextStyle(
                fontSize: 16.sp,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
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

  Widget _buildJournalInput() {
    return Container(
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
      child: TextField(
        controller: _textController,
        maxLines: 5,
        style: TextStyle(fontSize: 16.sp),
        decoration: InputDecoration(
          hintText: "Write your journal entry...",
          hintStyle: TextStyle(color: Colors.grey.shade500),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16.w),
        ),
      ),
    );
  }

  Widget _buildMoodSelectorAndSaveButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownButton<String>(
          value: _selectedMood,
          items: ["😊", "😢", "😡", "😌", "😁"]
              .map(
                (emoji) => DropdownMenuItem(
              value: emoji,
              child: Text(emoji, style: TextStyle(fontSize: 30.sp)),
            ),
          )
              .toList(),
          onChanged: (value) => setState(() {
            _selectedMood = value!;
          }),
        ),
        ElevatedButton(
          onPressed: _saveEntry,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          ),
          child: Text(
            "Save Entry",
            style: TextStyle(fontSize: 16.sp, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildJournalEntriesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _entries.length,
      itemBuilder: (context, index) {
        final entry = _entries[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 3,
          margin: EdgeInsets.symmetric(vertical: 10.h),
          color: Colors.green.shade50,
          child: ListTile(
            contentPadding: EdgeInsets.all(16.w),
            title: Text(
              entry.text,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.green.shade800,
              ),
            ),
            subtitle: Text(
              "${entry.mood} - ${entry.date.toLocal().toIso8601String()}",
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red.shade600),
              onPressed: () => _deleteEntry(entry.id!),
            ),
          ),
        );
      },
    );
  }
}
