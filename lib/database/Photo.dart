import 'package:objectbox/objectbox.dart';
import 'package:photo_manager/photo_manager.dart';

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
  bool is_cloud = false;
  bool is_favorite = false;

  Photo(this.entity_id, this.path, this.labels, this.creationDateTime,
      this.width, this.height);
}
