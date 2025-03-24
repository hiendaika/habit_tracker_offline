import 'package:isar/isar.dart';

part 'app_settings.g.dart';

@Collection()
class AppSettings {
  //iD
  Id id = Isar.autoIncrement;
  DateTime? firstLaunchDate;
}
