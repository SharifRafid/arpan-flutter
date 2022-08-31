class DefaultResponse {
  String? message;
  bool? error;

  DefaultResponse({this.message, this.error});

  DefaultResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (message != null) {
      data['message'] = message;
    }
    if (error != null) {
      data['error'] = error;
    }
    return data;
  }
}