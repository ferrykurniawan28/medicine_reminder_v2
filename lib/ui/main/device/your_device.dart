// ignore_for_file: public_member_api_docs, sort_constructors_first
part of '../main.dart';

class YourDevice extends StatelessWidget {
  final Device device;
  const YourDevice({
    super.key,
    required this.device,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FlutterCarousel.builder(
          itemCount: 5,
          options: FlutterCarouselOptions(
            height: 150,
            viewportFraction: 1,
            initialPage: 0,
            // reverse: false,
            // autoPlay: true,
            // autoPlayInterval: const Duration(seconds: 3),
            // autoPlayAnimationDuration:
            //     const Duration(milliseconds: 800),
            // autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            showIndicator: true,
            // floatingIndicator: true,
            slideIndicator: CircularSlideIndicator(
                slideIndicatorOptions: const SlideIndicatorOptions(
              currentIndicatorColor: kPrimaryColor,
              indicatorBackgroundColor: Colors.grey,
              indicatorRadius: 4,
              haloPadding: EdgeInsets.symmetric(horizontal: 5),
            )),
            indicatorMargin: 1,
            scrollDirection: Axis.horizontal,
          ),
          itemBuilder: (BuildContext context, int index, int realIndex) {
            // List<ContainerModel> containers = device.containers;
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                // gradient: LinearGradient(
                //   colors: [
                //     softBlueColor,
                //     softBlueColor.lighten(0.1),
                //   ],
                // ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  defaultShadow,
                ],
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/pils.png',
                    width: 60,
                    height: 60,
                  ),
                  spacerWidth(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Container ${device.containers[index].containerId + 1}',
                        style: subtitleTextStyle,
                      ),
                      Text(
                        device.containers[index].medicineName ?? 'Add Medicine',
                        style: captionTextStyle,
                      )
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Stock', style: subtitleTextStyle),
                      Text(
                        device.containers[index].quantity.toString(),
                        style: captionTextStyle,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        spacerHeight(8),
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2 - 16,
              // width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                // gradient: LinearGradient(
                //   colors: [
                //     softBlueColor,
                //     softBlueColor.lighten(0.1),
                //   ],
                // ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  defaultShadow,
                ],
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/celsius.png',
                    width: 60,
                    height: 60,
                  ),
                  spacerWidth(10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Temp',
                          style: subtitleTextStyle,
                        ),
                        Text(
                          '${device.temperature} °C',
                          style: captionTextStyle,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Expanded(
            //   child: Container(
            //     width: double.infinity,
            //     padding: const EdgeInsets.all(16),
            //     margin: const EdgeInsets.all(8),
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       // gradient: LinearGradient(
            //       //   colors: [
            //       //     softBlueColor,
            //       //     softBlueColor.lighten(0.1),
            //       //   ],
            //       // ),
            //       borderRadius: BorderRadius.circular(16),
            //       boxShadow: [
            //         defaultShadow,
            //       ],
            //     ),
            //     child: Row(
            //       children: [
            //         Image.asset(
            //           'assets/icons/humidity.png',
            //           width: 60,
            //           height: 60,
            //         ),
            //         spacerWidth(10),
            //         Expanded(
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 'Humidity',
            //                 style: subtitleTextStyle,
            //               ),
            //               Text(
            //                 '${device.humidity}%',
            //                 style: captionTextStyle,
            //               )
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}
