import 'package:flutter/material.dart';
import 'package:habit_tracker_offline/components/habit_tile.dart';
import 'package:habit_tracker_offline/components/my_drawer.dart';
import 'package:habit_tracker_offline/database/habit_database.dart';
import 'package:habit_tracker_offline/models/habit.dart';
import 'package:habit_tracker_offline/util/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController myController = TextEditingController();

  @override
  void initState() {
    //read existing habits on app start up
    Provider.of<HabitDatabase>(context, listen: false).fetchHabits();

    super.initState();
  }

  void createNewHabit() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Create habit'),
            content: TextField(
              controller: myController,
              decoration: InputDecoration(hintText: 'Create a new habit'),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  String newHabitName = myController.text;
                  context.read<HabitDatabase>().saveHabit(newHabitName);
                  Navigator.pop(context);
                  myController.clear();
                },
                child: Text('Create'),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  myController.clear();
                },
                child: Text('Cancel'),
              ),
            ],
          ),
    );
  }

  // load habits
  void readAllHabit() {
    context.read<HabitDatabase>().fetchHabits();
  }

  //Check habit on/off
  void checkHabitOnOff(bool? value, Habit habit) {
    //update habit completion status
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompleted(habit.id, value);
    }
  }

  //edit habit box
  void editHabitBox(Habit habit) {
    //Set text controller
    myController.text = habit.name;

    //show dialog
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Edit habit'),
            content: TextField(
              controller: myController,
              decoration: InputDecoration(hintText: 'Edit a habit'),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  String newHabitName = myController.text;
                  context.read<HabitDatabase>().updateHabitName(
                    habit.id,
                    newHabitName,
                  );
                  Navigator.pop(context);
                  myController.clear();
                },
                child: Text('Save'),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  myController.clear();
                },
                child: Text('Cancel'),
              ),
            ],
          ),
    );
  }

  //delete habit box
  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete habit'),
            content: Text('Are you sure you want to delete this habit?'),
            actions: [
              MaterialButton(
                onPressed: () {
                  context.read<HabitDatabase>().deleteHabit(habit.id);
                  Navigator.pop(context);
                },
                child: Text('Delete'),
              ),
              MaterialButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: MyDrawer(),
      body: _buildHabitList(),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () => createNewHabit(),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }

  Widget _buildHabitList() {
    //habit db
    final habitDatabase = context.watch<HabitDatabase>();

    //Current habit
    List<Habit> habits = habitDatabase.currentHabits;

    // return list habits of UI
    return ListView.builder(
      itemCount: habits.length,
      itemBuilder: (context, index) {
        // get each individual habit
        final item = habits[index];

        //check if habit is complete today
        bool isCompleteToday = isHabitCompletedToday(item.completedDays);

        // return habit title UI
        return HabitTile(
          text: item.name,
          isCompleted: isCompleteToday,
          onChanged: (value) {
            checkHabitOnOff(value, item);
          },
          onPressedEdit: (context) => editHabitBox(item),
          onPressedDelete: (context) => deleteHabitBox(item),
        );
      },
    );
  }
}
