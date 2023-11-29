import 'dart:ui';

/// Contain Map of type K and V value and optional onPressed function
/// that can be used to call when the individual bar of barchart is
/// pressed, you can pass [barLabel] and [barBackGroundColor] to customize bar
class ChartData<K extends LabelData, V extends num> {
  const ChartData({
    required this.labelWithValue,
    required this.barLabel,
    this.barBackGroundColor,
    this.onPressed,
  });

  /// Color that will fill the bar
  final Color? barBackGroundColor;

  /// Label for the bar
  final String barLabel;

  final Map<K, V> labelWithValue;
  final VoidCallback? onPressed;

  /// Calculate the maximum value that is present in the value of type V
  V get maxSize => labelWithValue.isNotEmpty
      ? labelWithValue.values.reduce((total, value) => _combine(total, value))
      : 0 as V;

  /// Return sum of value with subsuquent value key. This is important to
  /// draw a bar in a stack as the subsequent value is smaller than the
  /// previous one creating stack of bars
  V getHeightValueForGivenKey(K key) {
    final labelWithValueWithOutPreviousValue = Map<K, V>.from(labelWithValue);
    for (final mapEntry in labelWithValue.entries) {
      if (mapEntry.key == key) {
        break;
      }
      labelWithValueWithOutPreviousValue.remove(mapEntry.key);
    }
    return labelWithValueWithOutPreviousValue.entries
        .map((e) => e.value)
        .reduce((value, element) => _combine(value, element));
  }

  /// Return the index for the given key for the[labelWithValue]
  int getIndexForGivenKey(K key) {
    int index = 0;
    labelWithValue.entries
        .toList()
        .asMap()
        .entries
        .map((e) => (e.value.key == key) ? (index = e.key) : 0)
        .toList();
    return index;
  }

  V _combine(V value, V element) => value + element as V;
}

/// Contain label and color for the chart
class LabelData {
  LabelData(this.label, [this.color]);

  final Color? color;
  final String label;
}

extension MaxSizeX on List<ChartData> {
  num get maxValue {
    num maxValue = 0;
    forEach((e) => e.maxSize > maxValue ? maxValue = e.maxSize : 0);
    return maxValue;
  }
}
