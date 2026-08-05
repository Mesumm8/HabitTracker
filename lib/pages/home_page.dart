import 'package:flutter/material.dart';
import 'package:habittracker/components/my_drawer.dart';
import 'package:habittracker/components/my_habit_tile.dart';
import 'package:habittracker/components/my_heat_map.dart';
import 'package:habittracker/database/habit_databse.dart';
import 'package:habittracker/models/habit.dart';
import 'package:habittracker/util/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    //read existing habits on app startup
    Provider.of<HabitDatabse>(context, listen: false).readHabits();

    // implement initState
    super.initState();
  }

  //text controller
  final TextEditingController textController = TextEditingController();

  // create a new habit
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Create a new habit"),
        ),
        actions: [
          //save button
          MaterialButton(
            onPressed: () {
              //get the new habit name
              String newHabitName = textController.text;
              //save to db
              context.read<HabitDatabse>().addHabit(newHabitName);
              //pop box
              Navigator.pop(context);
              //clean controller
              textController.clear();
            },
            child: const Text("Save"),
          ),
          //cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);
              //clear controller
              textController.clear();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  //check habit on & off
  void checkHabitOnOff(bool? value, Habit habit) {
    //complete the habit completition status
    if (value != null) {
      context.read<HabitDatabse>().updateHabitCompletion(habit.id, value);
    }
  }

  //edit habit
  void editHabitBox(Habit habit) {
    //set the controllers text to the habits current name
    textController.text = habit.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(controller: textController),
        actions: [
          //save button
          MaterialButton(
            onPressed: () {
              //update habit name
              String newHabitName = textController.text;
              //save to db
              context.read<HabitDatabse>().updateHabitName(
                habit.id,
                newHabitName,
              );
              //pop box
              Navigator.pop(context);
              //clean controller
              textController.clear();
            },
            child: const Text("Save"),
          ),
          //cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);
              //clear controller
              textController.clear();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  //delete habit
  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Are you sure you want to delete?"),
        actions: [
          //delete button
          MaterialButton(
            onPressed: () {
              //save to db
              context.read<HabitDatabse>().deleteHabit(habit.id);
              //pop box
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
          //cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
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
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          //Heat map
          _buildHeatMap(),
          //HabitList
          _buildHabitList(),
        ],
      ),
    );
  }

  //build heat map
  Widget _buildHeatMap() {
    // habit db
    final habitDatabse = context.watch<HabitDatabse>();
    //current habit
    List<Habit> currentHabits = habitDatabse.currentHabit;
    //return heat map ui
    return FutureBuilder<DateTime?>(
      future: habitDatabse.getFirstLaunchDate(),
      builder: (context, snapshot) {
        // once the data is available -> build heatmap
        if (snapshot.hasData) {
          return MyHeatMap(
            startDate: snapshot.data!,
            datasets: prepHeatMapDataset(currentHabits));
        }
        //handle case where no data is req
        else {
          return Container();
        }
      },
    );
  }

  //build habit list
  Widget _buildHabitList() {
    //habit db
    final habitDatabase = context.watch<HabitDatabse>();
    //current habit
    List<Habit> currentHabits = habitDatabase.currentHabit;

    //return list of habits ui
    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        //get each indiv habit
        final habit = currentHabits[index];
        // check if the habit is completed today
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);
        //return habit title ui
        return MyHabitTile(
          text: habit.name,
          isCompleted: isCompletedToday,
          onChanged: (value) => checkHabitOnOff(value, habit),
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
        );
      },
    );
  }
}
