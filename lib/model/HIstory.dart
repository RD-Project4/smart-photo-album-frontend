import 'package:objectbox/objectbox.dart';

@Entity()
class History {
  @Id()
  int id = 0;
  @Index()
  String name;

  History(this.name);
}
