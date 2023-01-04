import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:get/get.dart';
import 'package:pickupjob/ui/auth/sign_up_driver_ui.dart';
import 'package:pickupjob/ui/auth/sign_up_user_ui.dart';
import 'package:pickupjob/ui/ui.dart';

import 'auth/sign_in_ui.dart';

class mainCarousel extends StatefulWidget {
  const mainCarousel({Key? key}) : super(key: key);

  @override
  State<mainCarousel> createState() => _mainCarouselState();
}

class _mainCarouselState extends State<mainCarousel> {
  CarouselController controller = CarouselController();

  int _current = 0;
  List backGrounds = [
    const Color.fromARGB(255, 0, 10, 22),
    Colors.black54,
    const Color.fromARGB(189, 0, 34, 51),
  ];
  List mainBackGrounds = [
    Colors.black87,
    Colors.black87,
    Colors.black87,
  ];

  List titles = [
    'Get whatever you need picked up and delivered, wherever, whenever',
    "Earn extra money by using your truck or vehicle",
    "Estimate how much amount needed",
  ];

  List sliderImages = [
    const Image(image: AssetImage('assets/images/truck.png')),
    const Image(image: AssetImage('assets/images/pickup-truck.png')),
    const Image(image: AssetImage('assets/images/tow-truck.png')),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width,
        child: CarouselSlider(
          options: CarouselOptions(
              viewportFraction: 1,
              height: MediaQuery.of(context).size.height,
              enableInfiniteScroll: true,
              autoPlayCurve: Curves.linear,
              enlargeCenterPage: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(milliseconds: 1000),
              onPageChanged: (val, _) {
                _current = val;
                setState(() {});
              }),
          items: [0, 1, 2].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  decoration: BoxDecoration(color: mainBackGrounds[i]),
                  padding: const EdgeInsets.all(10),
                  child: Container(
                      padding: const EdgeInsets.all(30),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                              MediaQuery.of(context).size.width < 380
                                  ? 10
                                  : 50)),
                          color: backGrounds[i]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          sliderImages[i],
                          Center(
                            child: Text(
                              titles[i],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            ),
                          ),
                          if (i == 0)
                            ElevatedButton.icon(
                              // <-- ElevatedButton
                              onPressed: () {
                                Get.offAll(SignUpUserUI());
                              },
                              icon: Icon(
                                Icons.forward,
                                size: 24.0,
                              ),
                              label: Text('Create an Account'),
                            ),
                          if (i == 1)
                            ElevatedButton.icon(
                              // <-- ElevatedButton
                              onPressed: () {
                                Get.offAll(SignUpDriverUI());
                              },
                              icon: Icon(
                                Icons.forward,
                                size: 24.0,
                              ),
                              label: Text('Sign up as a driver'),
                            ),
                          if (i == 2)
                            ElevatedButton.icon(
                              // <-- ElevatedButton
                              onPressed: () {
                                Get.offAll(Estimation());
                              },
                              icon: Icon(
                                Icons.forward,
                                size: 24.0,
                              ),
                              label: Text('Estimate total cost'),
                            ),
                        ],
                      )),
                );
              },
            );
          }).toList(),
        ),
      ),
      Positioned(
          width: MediaQuery.of(context).size.width,
          bottom: 50,
          child: Center(
            child: CarouselIndicator(
              count: titles.length,
              index: _current,
            ),
          )),
      Positioned(
          width: MediaQuery.of(context).size.width,
          bottom: 40,
          right: 40,
          child: InkWell(
            child: const Text('Skip',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                )),
            onTap: () {
              print('textValue');

              Get.offAll(SignInUI());
            },
          )),
    ]));
  }
}
