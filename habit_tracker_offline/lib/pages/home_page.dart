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
    // TODO: implement initState
    super.initState();
    readAllHabit();
  }

  void createNewHabit(BuildContext context) {
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
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      drawer: MyDrawer(),
      body: _buildHabitList(),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () => createNewHabit,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHabitList() {
    //habit db
    final habitDatabase = context.read<HabitDatabase>();

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

        // return habit title
        return HabitTile(
          text: item.name,
          isCompleted: isCompleteToday,
          onChanged: (value) {},
        );
      },
    );
  }
}
