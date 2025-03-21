part of 'widgets.dart';

class YourDevice extends StatelessWidget {
  const YourDevice({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Device',
            style: subtitleTextStyle,
          ),
          spacerHeight(8),
          Row(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
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
                              '25°C',
                              style: captionTextStyle,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              spacerWidth(10),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
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
                        'assets/icons/humidity.png',
                        width: 60,
                        height: 60,
                      ),
                      spacerWidth(10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Humidity',
                              style: subtitleTextStyle,
                            ),
                            Text(
                              '25%',
                              style: captionTextStyle,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          FlutterCarousel.builder(
            itemCount: 5,
            options: FlutterCarouselOptions(
              height: 120,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              // reverse: false,
              // autoPlay: true,
              // autoPlayInterval: const Duration(seconds: 3),
              // autoPlayAnimationDuration:
              //     const Duration(milliseconds: 800),
              // autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              // showIndicator: true,
              // floatingIndicator: true,
              // slideIndicator: CircularSlideIndicator(
              //     slideIndicatorOptions: const SlideIndicatorOptions()),
              // indicatorMargin: 10,
              scrollDirection: Axis.vertical,
            ),
            itemBuilder: (BuildContext context, int index, int realIndex) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16, top: 5),
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Paracetamol',
                            style: subtitleTextStyle,
                          ),
                          Text(
                            '20 Tablets',
                            style: captionTextStyle,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
