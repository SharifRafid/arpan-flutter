import 'package:http/http.dart' as http;

class CarouselResponse{
  final String name;
  final int order;
  final String image;

  CarouselResponse({
    required this.name,
    required this.order,
    required this.image,
  });

  factory CarouselResponse.fromJson(Map<String, dynamic> json){
    return CarouselResponse(
        name: json['name'],
        order: json['order_num'],
        image: json['image'],
    );
  }

}