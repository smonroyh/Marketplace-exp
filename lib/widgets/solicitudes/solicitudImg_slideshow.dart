import 'package:animate_do/animate_do.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class ImgSolicitudSlideshow extends StatelessWidget {

  final imgs = [
    'https://static.vecteezy.com/system/resources/previews/002/465/893/non_2x/ruined-house-cartoon-free-vector.jpg',
    'https://previews.123rf.com/images/brovector/brovector2212/brovector221200725/195670363-broken-vintage-car-vector-illustration-cartoon-drawings-of-damaged-or-abandoned-rusty-old.jpg',
    'https://previews.123rf.com/images/lcosmo/lcosmo1702/lcosmo170200125/71497900-illustration-of-a-person-desperate-student-with-a-damaged-laptop.jpg',
  ];

  ImgSolicitudSlideshow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      width: double.infinity,
      child: Swiper(
        itemCount: imgs.length,
        scale: 0.9,
        pagination: SwiperCustomPagination(builder:(context, config) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text("${config.activeIndex + 1} / ${config.itemCount}", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          );
        },),
        // pagination: SwiperPagination(
        //   margin: const EdgeInsets.only(top: 10),
        //   alignment: Alignment.bottomCenter,
        //   builder: FractionPaginationBuilder(
        //     activeColor: Colors.black,
        //     color: Colors.black,
        //     fontSize: 16,
        //     activeFontSize: 18,
        //     // space: 5,
        //   )
        // ),
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            imgs[index],
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return FadeIn(child: child);
              return DecoratedBox(
                decoration: BoxDecoration(color: Colors.black12),
              );
            },
          );
        },
      ),
    );
  }
}