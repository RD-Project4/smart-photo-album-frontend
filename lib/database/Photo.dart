import 'package:objectbox/objectbox.dart';

@Entity()
class Photo {
  @Id()
  int id = 0;
  @Index()
  String entity_id;
  String path;
  List<String> labels;
  DateTime creationDateTime;
  int width;
  int height;
  String? location;
  bool is_cloud = false;
  bool is_favorite = false;

  Photo(this.entity_id, this.path, this.labels, this.creationDateTime,
      this.width, this.height, this.location);
}
