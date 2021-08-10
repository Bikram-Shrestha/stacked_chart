import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stacked_chart/src/data/data.dart';

///Default color that is used when no color is passed
const barColors = [
  Color.fromARGB(255, 251, 138, 140),
  Color.fromARGB(255, 138, 143, 251),
  Color.fromARGB(200, 191, 214, 200),
];

class StackedChart extends StatelessWidget {
  /// Size of the widget itself. Please consider the
  /// value being passed as it need to hold given [barWidth]
  final Size size;

  /// Default value is 15
  final double barWidth;

  /// Buffer represent the space between the max value and
  /// max scale to represent the bar. Default value is 5
  final double buffer;
  final List<ChartData> data;
  final TextStyle? labelStyle;

  /// Whether to enable shadow behind the barchart to alter
  /// material look or flat glass like look
  final bool enableShadow;

  final bool showLabel;
  const StackedChart({
    Key? key,
    required this.size,
    required this.data,
    this.labelStyle,
    this.buffer = 5,
    this.barWidth = 15,
    this.showLabel = false,
    this.enableShadow = true,
  }) : super(key: key);

  num get maxValue => data.getMaxValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: data
            .map(
              (value) => SizedBox.fromSize(
                size: Size(size.width / data.length, size.height),
                child: Bar(
                  enableShadow: enableShadow,
                  maxValue: maxValue + buffer,
                  size: Size(barWidth, size.height),
                  showLabel: showLabel,
                  data: value,
                  label: value.barLabel,
                  labelStyle: labelStyle ??
                      Theme.of(context).textTheme.caption ??
                      TextStyle(),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class Bar extends StatelessWidget {
  const Bar({
    Key? key,
    required this.size,
    required this.data,
    required this.maxValue,
    required this.labelStyle,
    required this.showLabel,
    required this.enableShadow,
    this.label,
  }) : super(key: key);

  final ChartData data;
  final Size size;
  final bool showLabel;
  final String? label;
  final num maxValue;
  final TextStyle labelStyle;
  final bool enableShadow;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 8,
          child: SizedBox.fromSize(
            size: size,
            child: _BarStack(
              enableShadow: enableShadow,
              data: data,
              size: size,
              maxValue: maxValue,
            ),
          ),
        ),
        if (showLabel)
          SizedBox(
            height: 5,
          ),
        if (showLabel)
          Flexible(
              flex: 2,
              child: Text(
                label ?? '',
                style: labelStyle,
                overflow: TextOverflow.ellipsis,
              ))
      ],
    );
  }
}

class _BarStack extends StatelessWidget {
  const _BarStack({
    Key? key,
    required this.data,
    required this.maxValue,
    required this.size,
    required this.enableShadow,
  }) : super(key: key);

  final num maxValue;

  final Size size;
  final ChartData data;
  final bool enableShadow;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: [
      GestureDetector(
        onTap: data.onPressed,
        child: Container(
          child: _BarWidget(
            barColor: data.barBackGroundColor ?? barColors.last,
            barSize: size,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                offset: Offset(1, 1),
                blurRadius: 4,
                spreadRadius: 1,
                color: Color.fromRGBO(135, 135, 135, enableShadow ? 1 : 0),
              )
            ],
          ),
        ),
      ),
      ...data.labelWithValue.entries
          .map(
            (e) => Tooltip(
              message: '${e.key.label}: ${e.value}',
              child: _BarWidget(
                barColor: e.key.color ??
                    barColors[
                        data.getIndexForGivenKey(e.key) % barColors.length],
                barSize: Size(
                    size.width,
                    (size.height / maxValue) *
                        data.getHeightValueForGivenKey(e.key)),
              ),
            ),
          )
          .toList()
    ]);
  }
}

class _BarWidget extends StatelessWidget {
  const _BarWidget({
    Key? key,
    required this.barColor,
    required this.barSize,
  }) : super(key: key);

  final Color barColor;
  final Size barSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: barSize.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: barColor,
      ),
      width: barSize.width,
    );
  }
}
