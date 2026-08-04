import 'package:isar/isar.dart';

//run cmd to generate file: dart run builder_runner
part 'habit.g.dart';

@Collection()
class Habit {
  //habbit id
  Id id = Isar.autoIncrement;
  //habit name
  late String name;
  //completed days
  List<DateTime> completedDays = [
    // DateTime (year,month,day),
    // DateTime (2024,1,10),
  ];
}
