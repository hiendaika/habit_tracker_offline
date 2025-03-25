// given a habit list of completion today
// is the habit completed today
bool isHabitCompletedToday(List<DateTime> completeDays) {
  final today = DateTime.now();
  return completeDays.any(
    (date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day,
  );
}
