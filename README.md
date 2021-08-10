# stacked_chart
With Shadow

<img width="494" alt="Screen Shot 2021-08-10 at 2 27 33 pm" src="https://user-images.githubusercontent.com/30488716/128808291-df9a5c1d-ee19-4360-96e2-51dd213698c6.png">



Without Shadow 

![animation](https://user-images.githubusercontent.com/30488716/127808681-453a915f-1b90-42b9-89e4-24c681fdb534.gif)

A flutter package for creating a stack barchart with easy customization.

## Installation
In the `dependencies:` section of your `pubspec.yaml`, add the following line:

```yaml
stacked_chart:
```

Then `import` it as :

```yaml
import 'package:stacked_chart/stacked_chart.dart';
```

## Usage
```dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stacked_chart/stacked_chart.dart';

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
          )),
        )
        .toList();
    setState(() {
      weeklyStatus = weeklyData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: createRandomWeeklyStatus,
      child: StackedChart(
        data: weeklyStatus,
        size: const Size(300, 150),
        showLabel: true,
      ),
    );
  }
}

class BookingStatus extends ChartData<LabelData, int>
    implements Comparable<BookingStatus> {
  final DateTime dateTime;
  final Map<String, int> bookings;

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

  BookingStatus({required this.dateTime, this.bookings = const {}})
      : super(
            labelWithValue: convertBookingToMapOfLabelDataInt(bookings),
            barLabel: dateTime.day.toString());

  @override
  int compareTo(BookingStatus other) => dateTime.compareTo(other.dateTime);
}
```
