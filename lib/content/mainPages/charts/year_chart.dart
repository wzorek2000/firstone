import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class YearChart extends StatelessWidget {
  const YearChart({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String uid = user?.uid ?? '';

    Stream<QuerySnapshot> userEntriesStream = FirebaseFirestore.instance
        .collection('entries')
        .where('userId', isEqualTo: uid)
        .orderBy('date', descending: true)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: userEntriesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        var moodDataByMonth =
            _aggregateMoodDataByMonth(snapshot.data?.docs ?? []);

        var chartSeries = _createChartSeries(moodDataByMonth);

        return AspectRatio(
          key: const ValueKey('chart'),
          aspectRatio: 1.7,
          child: charts.BarChart(
            chartSeries,
            animate: true,
            domainAxis: const charts.OrdinalAxisSpec(),
            primaryMeasureAxis: const charts.NumericAxisSpec(
              tickProviderSpec: charts.BasicNumericTickProviderSpec(
                dataIsInWholeNumbers: true,
                desiredTickCount: 6,
              ),
            ),
            barRendererDecorator: charts.BarLabelDecorator<String>(
              insideLabelStyleSpec: const charts.TextStyleSpec(
                fontSize: 20,
              ),
              labelPadding: 5,
              labelPosition: charts.BarLabelPosition.inside,
            ),
          ),
        );
      },
    );
  }

  Map<String, double> _aggregateMoodDataByMonth(
      List<QueryDocumentSnapshot> snapshots) {
    Map<String, List<double>> moodData = {};
    final DateFormat formatter = DateFormat('yyyy-MM');
    final DateTime now = DateTime.now();
    final DateTime sixMonthsAgo = DateTime(now.year, now.month - 5, now.day);

    for (var doc in snapshots) {
      var data = doc.data() as Map<String, dynamic>;
      var date = (data['date'] as Timestamp).toDate();
      if (date.isAfter(sixMonthsAgo) || date.isAtSameMomentAs(sixMonthsAgo)) {
        var mood = (data['mood'] as num).toDouble();
        var month = formatter.format(date);

        moodData.putIfAbsent(month, () => []).add(mood);
      }
    }

    Map<String, double> moodDataByMonth = {};
    moodData.forEach((month, moods) {
      double averageMood = moods.reduce((a, b) => a + b) / moods.length;
      moodDataByMonth[month] = averageMood;
    });

    return moodDataByMonth;
  }

  List<charts.Series<MonthMoodData, String>> _createChartSeries(
      Map<String, double> moodDataByMonth) {
    List<MonthMoodData> data = moodDataByMonth.entries.map((e) {
      return MonthMoodData(e.key, e.value);
    }).toList();

    data.sort((a, b) => a.month.compareTo(b.month));

    return [
      charts.Series<MonthMoodData, String>(
        id: 'Moods',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (MonthMoodData moodData, _) => moodData.month,
        measureFn: (MonthMoodData moodData, _) => moodData.mood,
        data: data,
        labelAccessorFn: (MonthMoodData moodData, _) {
          return moodEmoji(moodData.mood);
        },
      )
    ];
  }

  String moodEmoji(double moodValue) {
    int mood = moodValue.round();
    switch (mood) {
      case 1:
        return '😞';
      case 2:
        return '😔';
      case 3:
        return '🙂';
      case 4:
        return '☺️';
      case 5:
        return '🥰';
      default:
        return '';
    }
  }
}

class MonthMoodData {
  final String month;
  final double mood;

  MonthMoodData(this.month, this.mood);
}
