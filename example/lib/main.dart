import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stacked_chart/stacked_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stacked Chart'),
      ),
      body: Center(
        child: WeeklyChartDemo(),
      ),
    );
  }
}

enum WeekDay { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

class WeeklyChartDemo extends StatefulWidget {
  const WeeklyChartDemo({Key? key}) : super(key: key);

  @override
  _WeeklyChartDemoState createState() => _WeeklyChartDemoState();
}

class _WeeklyChartDemoState extends State<WeeklyChartDemo> {
  final rng = Random();
  List<BookingStatus> weeklyStatus = [];

  @override
  void initState() {
    createRandomWeeklyStatus();
    super.initState();
  }

  void createRandomWeeklyStatus() {
    weeklyStatus.clear();
    final List<BookingStatus> weeklyData = [];
    WeekDay.values
        .map(
          (day) => weeklyData.add(BookingStatus(
              dateTime: DateTime.now().add(
                Duration(days: day.index),
              ),
              bookings: {
                'Unfilled booking': rng.nextInt(20),
                'Filled booking': rng.nextInt(20),
              },
              onPressed: createRandomWeeklyStatus)),
        )
        .toList();
    setState(() {
      weeklyStatus = weeklyData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StackedChart(
      data: weeklyStatus,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      size: const Size(300, 150),
      showLabel: true,
      enableShadow: true,
    );
  }
}

class BookingStatus extends ChartData<LabelData, int>
    implements Comparable<BookingStatus> {
  final DateTime dateTime;
  final Map<String, int> bookings;
  final VoidCallback? onPressed;

  static Map<LabelData, int> convertBookingToMapOfLabelDataInt(
      Map<String, int> bookings) {
    final Map<LabelData, int> convertedData = {};
    bookings.entries
        .map((e) => convertedData.addAll({LabelData(e.key): e.value}))
        .toList();
    return convertedData;
  }

  int get totalBookingCount =>
      bookings.values.reduce((total, value) => total = total + value);

  BookingStatus(
      {required this.dateTime, this.bookings = const {}, this.onPressed})
      : super(
          labelWithValue: convertBookingToMapOfLabelDataInt(bookings),
          barLabel: dateTime.day.toString(),
          onPressed: onPressed,
        );

  @override
  int compareTo(BookingStatus other) => dateTime.compareTo(other.dateTime);
}
