import 'package:bflat_app/screens/sound_check.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 300,
              width: 400,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BandAlongScreen()),
                  );
                },
                child: Card(
                  clipBehavior: Clip.antiAlias, // 카드 모서리에 맞춰 이미지가 잘리도록 설정
                  child: Image.asset(
                    'assets/images/band_along_card.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: SizedBox(
                height: 300,
                width: 400,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    'assets/images/home_along_card.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BandAlongScreen extends StatelessWidget {
  const BandAlongScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Band Along'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 200,
              width: 400,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SoundCheckScreen()),
                  );
                },
                child: Card(
                  clipBehavior: Clip.antiAlias, // 카드 모서리에 맞춰 이미지가 잘리도록 설정
                  child: Stack(
                    children: [
                      Image.asset(
                        'images/band_along_card.png',
                        fit: BoxFit.cover,
                        width: 400,
                        height: 200,
                      ),
                      const Positioned(
                        right: 10, // 우측 여백
                        bottom: 10, // 하단 여백
                        child: Text(
                          'Sound Check',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: SizedBox(
                height: 200,
                width: 400,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Image.asset(
                        'images/home_along_card.png',
                        fit: BoxFit.cover,
                      ),
                      const Positioned(
                        right: 10, // 우측 여백
                        bottom: 10, // 하단 여백
                        child: Text(
                          'Record analysis',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: SizedBox(
                height: 200,
                width: 400,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Image.asset(
                        'images/home_along_card.png',
                        fit: BoxFit.cover,
                      ),
                      const Positioned(
                        right: 10, // 우측 여백
                        bottom: 10, // 하단 여백
                        child: Text(
                          'History',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
