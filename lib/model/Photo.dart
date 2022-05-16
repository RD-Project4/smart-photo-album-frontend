import 'package:objectbox/objectbox.dart';
import 'package:smart_album/api/api.dart';

@Entity()
class Photo {
  @Id()
  int id = 0;
  @Index()
  String? entityId; // 本地entity id
  String? cloudId; // 云端id
  String name;
  String?
      thumbnailPath; // 取决于isLocal, 在本地为空（可以从entityId获取thumbnail），否则为云端thumbnail path
  String path; // 取决于isLocal, 在本地为本地路径，否则为云端
  List<String> labels;
  DateTime creationDateTime;
  int width;
  int height;
  String? location;
  List<String> text;
  bool isCloud; // 是否是云端照片，不在本地又不在云端就会从数据库里删除
  bool isLocal; // 是否在本地存在
  bool isFavorite = false;
  bool isDeleted = false; // 在回收站吗

  Photo(
      this.entityId,
      this.name,
      this.path,
      this.labels,
      this.creationDateTime,
      this.width,
      this.height,
      this.location,
      this.text,
      this.isCloud,
      this.isLocal);

  Photo.fromJson(dynamic json)
      : cloudId = json["picId"],
        name = json["picLocalUrl"],
        thumbnailPath = Api.get().getPicThumbUrlByCloudId(json["picId"]),
        path = Api.get().getPicUrlByCloudId(json["picId"]),
        labels = json["custom"]["labels"].split(','),
        creationDateTime = DateTime.fromMillisecondsSinceEpoch(
            json["custom"]["creationDateTime"]),
        width = json["custom"]["width"],
        height = json["custom"]["height"],
        location = json["custom"]["location"],
        text = json["custom"]["text"].split(','),
        isCloud = true,
        isLocal = false,
        isFavorite = json["custom"]["isFavorite"];

  toJson() {
    return {
      "labels": labels.join(','),
      "creationDateTime": creationDateTime.millisecondsSinceEpoch,
      "width": width,
      "height": height,
      "location": location,
      "isFavorite": isFavorite,
      "text": text.join(',')
    };
  }

  Photo.placeholder()
      : id = -1,
        cloudId = "-1",
        name = "",
        thumbnailPath = "https://via.placeholder.com/150",
        path = "",
        labels = [],
        creationDateTime = DateTime.now(),
        width = 0,
        height = 0,
        location = "",
        text = [],
        isCloud = true,
        isLocal = false,
        isFavorite = false;
}
