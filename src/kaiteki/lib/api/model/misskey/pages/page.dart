import 'package:kaiteki/api/model/misskey/user.dart';
import 'package:kaiteki/api/model/misskey/pages/components/component.dart';

class MisskeyPage {
  String id;
  //dynamic createdAt;
  //dynamic updatedAt;
  String userId;
  MisskeyUser user;
  Iterable<MisskeyPageComponent> content;
  Iterable<MisskeyPageComponent> variables;
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

    if (json["user"] != null)
      user = MisskeyUser.fromJson(json["user"]);

    content = json["content"]
      .map<MisskeyPageComponent>((j) => MisskeyPageComponent.fromJson(j));

    if (json["variables"] != null) {
      var mapped =  json["variables"]
          .map<MisskeyPageComponent>((j) => MisskeyPageComponent.fromJson(j));
          variables = mapped;
    }

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