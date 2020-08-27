class PleromaCard {
  Map<String, String> opengraph;

  PleromaCard.fromJson(Map<String, dynamic> json) {
    opengraph = json["opengraph"].cast<String, String>();
  }
}