import 'package:flutter/material.dart';
import 'package:habit_tracker_offline/models/app_settings.dart';
import 'package:habit_tracker_offline/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  /// SET UP

  static late Isar isar;
  //Initialize database
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      HabitSchema,
      AppSettingsSchema,
    ], directory: dir.path);
  }

  //Save first date of app startup(for heatmap)
  Future<void> saveFirstLaunchDate() async {
    final existingSetting = await isar.appSettings.where().findFirst();
    if (existingSetting == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // Get first date of app startup(for heatmap)
  Future<DateTime?> getFirstLaunchDate() async {
    final existingSetting = await isar.appSettings.where().findFirst();
    return existingSetting?.firstLaunchDate;
  }

  /*
  * CRUD OPERATIONS
  */
  // List all habits
  List<Habit> currentHabits = [];

  // Create - a new habit
  Future<void> saveHabit(String habitName) async {
    //creat a new habit
    final newHabit = Habit()..name = habitName;
    await isar.writeTxn(() => isar.habits.put(newHabit));
    fetchHabits();
  }

  // Read - habit from database
  Future<void> fetchHabits() async {
    final habits = await isar.habits.where().findAll();
    currentHabits.clear();
    currentHabits.addAll(habits);
    notifyListeners();
  }

  // Update - check habit on/off
  Future<void> updateHabitCompleted(int id, bool isCompleted) async {
    final habit = await isar.habits.get(id);
    if (habit != null) {
      await isar.writeTxn(() async {
        // if habit is complete => add current date to the complete days list
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          // today
          final today = DateTime.now();
          // add to the list
          habit.completedDays.add(DateTime(today.year, today.month, today.day));
        }
        //If not complete => remove current date from the list
        else {
          habit.completedDays.removeWhere(
            (date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day,
          );
        }

        // save updated habit to database
        await isar.habits.put(habit);
      });
      // re-fetch habits
      fetchHabits();
    }
  }

  // Update - update habit name
  Future<void> updateHabitName(int id, String newName) async {
    //find habit
    final habit = await isar.habits.get(id);
    if (habit != null) {
      //update habit
      await isar.writeTxn(() async {
        habit.name = newName;
        await isar.habits.put(habit);
      });
      //re-fetch habits
      fetchHabits();
    }
  }

  // Delete - habit from database
  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
    fetchHabits();
  }
}
