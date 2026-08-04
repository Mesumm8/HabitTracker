import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:habittracker/models/app_settings.dart';
import 'package:habittracker/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabse extends ChangeNotifier {
  static late Isar isar;

  /* 
    Setup
  */
  // Intialize database
  static Future<void> initialize() async {
    final dir = await getApplicationCacheDirectory();
    isar = await Isar.open([
      HabitSchema,
      AppSettingsSchema,
    ], directory: dir.path);
  }

  //save first date of app startup for heatmap
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  //get first date of app startup for heatmap
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  /* 
    CRUD operations
  */
  // list of habits
  final List<Habit> currentHabit = [];
  //Create
  Future<void> addHabit(String habitName) async {
    // create a new habbit
    final newHabit = Habit()..name = habitName;
    //save to db
    await isar.writeTxn(() => isar.habits.put(newHabit));
    //re read from db
    readHabits();
  }

  //read
  Future<void> readHabits() async {
    //fetch all habits from db
    List<Habit> fetchedHabits = await isar.habits.where().findAll();
    //give to current habits
    currentHabit.clear();
    currentHabit.addAll(fetchedHabits);
    //update UI
    notifyListeners();
  }

  //update
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    //find the specific habit
    final habit = await isar.habits.get(id);
    //update completion status
    if (habit != null) {
      await isar.writeTxn(() async {
        // if habit is completed add current date
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          //today
          final today = DateTime.now();
          //add the current date if its not already in the list
          habit.completedDays.add(DateTime(today.year, today.month, today.day));
        }
        // if not then no remove current date from list
        else {
          // remove current date if habit not complete
          habit.completedDays.removeWhere(
            (date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day,
          );
        }
        //save the updated habits back to db
        await isar.habits.put(habit);
      });
    }
    // re read from db
    readHabits();
  }

  //update - edit habit name
  Future<void> updateHabitName(int id, String newName) async {
    // find the specific habit
    final habit = await isar.habits.get(id);
    //update habit name
    if (habit != null) {
      //update name
      await isar.writeTxn(() async {
        habit.name = newName;
        //save updated habit back to db
        await isar.habits.put(habit);
      });
    }
    // re read from db
    readHabits();
  }

  // delete
  Future<void> deleteHabit(int id) async {
    //perform the del
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });

    //reread from db
    readHabits();
  }
}
