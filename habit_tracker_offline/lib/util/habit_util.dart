// given a habit list of completion today
// is the habit completed today
import 'package:habit_tracker_offline/models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completeDays) {
  final today = DateTime.now();
  return completeDays.any(
    (date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day,
  );
}

//Prepare heat map dataset
Map<DateTime, int> prepHeatMapDataset(List<Habit> habits) {
  Map<DateTime, int> datasets = {};
  for (var habit in habits) {
    for (var date in habit.completedDays) {
      // normalize date to avoid time mismatch
      final normalizedDate = DateTime(date.year, date.month, date.day);

      // if the date already exists in the dataset
      if (datasets.containsKey(normalizedDate)) {
        datasets[normalizedDate] = datasets[normalizedDate]! + 1;
      } else {
        // else initialize with a count of 1
        datasets[normalizedDate] = 1;
      }
    }
  }
  return datasets;
}
