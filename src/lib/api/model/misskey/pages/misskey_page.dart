import 'package:kaiteki/api/model/misskey/pages/components/misskey_page_component.dart';

class MisskeyPage {
  String id;
  //dynamic createdAt;
  //dynamic updatedAt;
  String userId;
  //dynamic user;
  Iterable<MisskeyPageComponent> content;
  List<dynamic> variables;
  String title;
  String name;
  //dynamic summary;
  bool hideTitleWhenPinned;
  bool alignCenter;
  String font;
  String script;
  String eyeCatchingImageId;
  //dynamic eyeCatchingImage;
  //List<AttachedFile> attachedFiles;
  int likedCount;
  bool isLiked;

  MisskeyPage.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    //createdAt = json["createdAt"];
    //updatedAt = json["updatedAt"];
    userId = json["userId"];
    //user = json["user"];
    content = json["content"].map<MisskeyPageComponent>((j) => MisskeyPageComponent.fromJson(j));
    variables = json["variables"];
    title = json["title"];
    name = json["name"];
    //summary = json["summary"];
    hideTitleWhenPinned = json["hideTitleWhenPinned"];
    alignCenter = json["alignCenter"];
    font = json["font"];
    script = json["script"];
    eyeCatchingImageId = json["eyeCatchingImageId"];
    //eyeCatchingImage = json["eyeCatchingImage"];
    //attachedFiles = json["attachedFiles"];
    likedCount = json["likedCount"];
    isLiked = json["isLiked"];
  }
}