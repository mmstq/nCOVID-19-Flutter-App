class ImageModel {
  String imageUrl;
  int width;
  int height;

  ImageModel({this.imageUrl, this.width, this.height});

  ImageModel.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image_url'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image_url'] = this.imageUrl;
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }
}
