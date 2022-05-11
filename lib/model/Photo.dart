import 'package:objectbox/objectbox.dart';

@Entity()
class Photo {
  @Id()
  int id = 0;
  @Index()
  String? entityId; // 本地entity id
  String? cloudId; // 云端id
  String?
      thumbnailPath; // 取决于isLocal, 在本地为空（可以从entityId获取thumbnail），否则为云端thumbnail path
  String path; // 取决于isLocal, 在本地为本地路径，否则为云端
  List<String> labels;
  DateTime creationDateTime;
  int width;
  int height;
  String? location;
  bool isCloud = false; // 是否是云端照片，不在本地又不在云端就会从数据库里删除
  bool isLocal = false; // 是否在本地存在
  bool isFavorite = false;

  Photo(this.entityId, this.path, this.labels, this.creationDateTime,
      this.width, this.height, this.location);

  Photo.fromJson(dynamic json)
      : cloudId = json["picId"],
        thumbnailPath = "",
        path = "picCloudUrl",
        labels = [],
        creationDateTime = DateTime.now(),
        width = 0,
        height = 0,
        location = "",
        isCloud = true,
        isLocal = false,
        isFavorite = false;
}
