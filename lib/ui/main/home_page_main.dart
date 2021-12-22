import 'package:arpan_app_new/data/models/carousel_response.dart';
import 'package:arpan_app_new/data/models/home_response.dart';
import 'package:arpan_app_new/services/network/home_api.dart';
import 'package:arpan_app_new/services/utils/show_toast.dart';
import 'package:arpan_app_new/ui/resources/theme_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePageMain extends StatelessWidget {
  const HomePageMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _HomePageMain();
  }
}

class _HomePageMain extends StatefulWidget {
  const _HomePageMain({Key? key}) : super(key: key);

  @override
  _HomePageMainState createState() => _HomePageMainState();
}

class _HomePageMainState extends State<_HomePageMain> {

  late HomeResponse _homeResponse;
  var enableCarouselSlider = false;
  late List<Widget> imageSliders;

  void setHomeResponse(HomeResponse? homeResponse){
    if(homeResponse != null){
      setState(() {
        this._homeResponse = homeResponse;
        if(_homeResponse.carouselResponse.isNotEmpty){
          imageSliders = getImageSliders(homeResponse.carouselResponse);
          enableCarouselSlider = true;
        }
      });
    }else{
      showToast("কোন ডেটা পাওয়া যায়নি!");
    }
  }

  @override
  void initState() {
    super.initState();
    HomeApi().getHomeResponse(callBack: setHomeResponse);
  }


  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColors.white,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: MainColors.blue,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(1, 1)
                ),
              ],
            ),
            child: Row(
              children: [
                _iconButton(
                  onClickAction: (){
                    showToast("message");
                  },
                  iconData: Icons.menu,
                ),
                Expanded(
                    child: Center(
                      child: Padding(
                        child: Text(
                          "অর্পণ",
                          style: TextStyle(
                              color: MainColors.white,
                              fontSize: 16
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(
                            0, 10, 0, 0
                        ),
                      ),
                    )
                ),
                _iconButton(
                    onClickAction: (){
                      FirebaseAuth.instance.signOut();
                      Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false);
                    },
                    iconData: Icons.shopping_cart
                ),
              ],
            ),
          ),
      enableCarouselSlider ?
      CarouselSlider(
        items: imageSliders,
        carouselController: _controller,
        options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 2.0,
            height: 120,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      ): Container(),
          enableCarouselSlider ?
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imageSliders.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 7.0,
                  height: 7.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : MainColors.blue)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ) : Container(),
        ],
      ),
    );
  }
}

List<Widget> getImageSliders(List<CarouselResponse> carouselResponse){
  return carouselResponse
      .map((item) => Padding(
    padding: EdgeInsets.only(top: 10),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.network(
        item.image,
        fit: BoxFit.fill,
        height: 130.0,
        width: 1000.0,
      ),
    ),
  ),
      ).toList();
}

Widget _carouselItem(CarouselResponse carouselResponse){
  return Container();
}

Widget _iconButton({required Function onClickAction,
  required IconData iconData}){
  return Padding(
    padding: EdgeInsets.only(left: 10, right: 10,
        bottom: 10, top: 10),
    child: SizedBox(
      height: 32,
      width: 32,
      child: IconButton(
          color: MainColors.white,
          onPressed: ()=>onClickAction(),
          icon: Icon(iconData)
      ),
    ),
  );
}