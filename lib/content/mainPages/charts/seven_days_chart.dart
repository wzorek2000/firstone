import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class SevenDaysChart extends StatefulWidget {
  const SevenDaysChart({super.key});

  @override
  _SevenDaysChartState createState() => _SevenDaysChartState();
}

class _SevenDaysChartState extends State<SevenDaysChart> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<MoodEntry> moodEntries = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? currentUserId = user?.uid;

    if (currentUserId == null) {
      return;
    }

    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime sevenDaysAgo = startOfDay.subtract(const Duration(days: 7));

    final QuerySnapshot result = await _firestore
        .collection('entries')
        .where('userId', isEqualTo: currentUserId)
        .where('date', isGreaterThanOrEqualTo: sevenDaysAgo)
        .orderBy('date', descending: true)
        .get();

    Map<DateTime, List<MoodEntry>> entriesGroupedByDate = {};

    for (var document in result.docs) {
      MoodEntry entry = MoodEntry.fromDocumentSnapshot(document);
      DateTime dateWithoutTime =
          DateTime(entry.date.year, entry.date.month, entry.date.day);
      if (!entriesGroupedByDate.containsKey(dateWithoutTime)) {
        entriesGroupedByDate[dateWithoutTime] = [];
      }
      entriesGroupedByDate[dateWithoutTime]!.add(entry);
    }

    List<MoodEntry> averageMoodEntries = [];
    entriesGroupedByDate.forEach((date, entries) {
      int sumMoods = entries.fold(
          0, (previousValue, element) => previousValue + element.mood);
      int entriesCount = entries.length;
      int averageMood = (sumMoods / entriesCount).ceil();
      averageMoodEntries.add(MoodEntry(date: date, mood: averageMood));
    });

    averageMoodEntries.sort((a, b) => a.date.compareTo(b.date));
    setState(() {
      moodEntries = averageMoodEntries;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isNotEmpty = moodEntries.isNotEmpty;
    return Column(
      children: <Widget>[
        if (isNotEmpty) _buildChartLegend(),
        if (isNotEmpty) const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SizedBox(
            height: 300,
            child: isNotEmpty
                ? LineChart(
                    LineChartData(
                      gridData: const FlGridData(
                        show: false,
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true, // Enable displaying Y-axis titles
                            reservedSize:
                                40, // Reserve space for the legend on the left side
                            interval: 1, // The interval for each title
                            getTitlesWidget: (value, meta) {
                              // Only display the title for whole number values
                              return Text(value.toInt().toString());
                            },
                          ),
                        ),
                        bottomTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: const Border(
                          bottom: BorderSide(
                            color: Color(0xff37434d),
                            width: 1,
                          ),
                          left: BorderSide(
                            color: Color(0xff37434d),
                            width: 1,
                          ),
                          top: BorderSide(color: Colors.transparent),
                          right: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      minX: moodEntries.first.date.millisecondsSinceEpoch
                          .toDouble(),
                      maxX: moodEntries.last.date.millisecondsSinceEpoch
                          .toDouble(),
                      minY: 0,
                      maxY: 5,
                      lineBarsData: [
                        LineChartBarData(
                          spots: moodEntries
                              .map((e) => FlSpot(
                                    e.date.millisecondsSinceEpoch.toDouble(),
                                    e.mood.toDouble(),
                                  ))
                              .toList(),
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 5,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.blue.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
    );
  }

  Widget _buildChartLegend() {
    DateTime startDate = moodEntries.first.date;
    DateTime endDate = moodEntries.last.date;
    String formattedStartDate = DateFormat('dd-MM-yyyy').format(startDate);
    String formattedEndDate = DateFormat('dd-MM-yyyy').format(endDate);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'Dane z tygodnia od $formattedStartDate do $formattedEndDate',
          style: const TextStyle(),
        ),
      ),
    );
  }
}

class MoodEntry {
  final DateTime date;
  final int mood;

  MoodEntry({required this.date, required this.mood});

  factory MoodEntry.fromDocumentSnapshot(DocumentSnapshot doc) {
    Timestamp timestamp = doc.get('date') as Timestamp;
    DateTime date = timestamp.toDate();

    return MoodEntry(
      date: date,
      mood: doc.get('mood') as int,
    );
  }
}
