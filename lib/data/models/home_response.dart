
import 'package:arpan_app_new/data/models/carousel_response.dart';

class HomeResponse{
  final List<CarouselResponse> carouselResponse;

  HomeResponse({
    required this.carouselResponse,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json){
    var carousel = json['carousel'] as List<dynamic>;
    return HomeResponse(
        carouselResponse: carousel.map((e) => CarouselResponse.fromJson(e)).toList(),
    );
  }

}