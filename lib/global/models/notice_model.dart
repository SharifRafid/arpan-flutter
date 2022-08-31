class Notice {
  String? id;
  bool? enabled;
  String? textTitle;
  String? textDescription;
  bool? timeBased;
  int? startTime;
  int? endTime;
  String? backgroundColorHex;
  String? textColorHex;
  int? order;
  String? startTimeString;
  String? endTimeString;

  Notice(
      {this.id,
      this.enabled,
      this.textTitle,
      this.textDescription,
      this.timeBased,
      this.startTime,
      this.endTime,
      this.backgroundColorHex,
      this.textColorHex,
      this.order,
      this.startTimeString,
      this.endTimeString});

  Notice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    enabled = json['enabled'];
    textTitle = json['textTitle'];
    textDescription = json['textDescription'];
    timeBased = json['timeBased'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    backgroundColorHex = json['backgroundColorHex'];
    textColorHex = json['textColorHex'];
    order = json['order'];
    startTimeString = json['startTimeString'];
    endTimeString = json['endTimeString'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['enabled'] = enabled;
    data['textTitle'] = textTitle;
    data['textDescription'] = textDescription;
    data['timeBased'] = timeBased;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['backgroundColorHex'] = backgroundColorHex;
    data['textColorHex'] = textColorHex;
    data['order'] = order;
    data['startTimeString'] = startTimeString;
    data['endTimeString'] = endTimeString;
    return data;
  }
}
