class Share {
  String shareId;
  List<String> sharePhotoList;
  List<String> userIdList;

  Share(this.shareId, this.sharePhotoList, this.userIdList);

  Share.fromJson(dynamic json)
      : shareId = json["shareId"],
        sharePhotoList = json["shareContentId"].split(","),
        userIdList = json["shareObject"].split(",");
}
