import 'package:bflat_app/screens/select_record_screen.dart';
import 'package:bflat_app/screens/stem_selection.dart';
import 'package:flutter/material.dart';

class UserProfileWidget extends StatelessWidget {
  final String username;

  UserProfileWidget({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200], // 배경 색상
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white, // 아이콘 배경색
              child: Image.asset('assets/images/user_profile.png'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(username),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const username = "username";

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            UserProfileWidget(username: username),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                // 검색 버튼 동작
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 300,
                height: 240,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BandAlongScreen()),
                    );
                  },
                  child: Image.asset(
                    'assets/images/band_along_card.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {},
                child: SizedBox(
                  width: 300,
                  height: 240,
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 300,
                height: 100,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StemSelectionScreen()),
                    );
                  },
                  child: Card(
                    clipBehavior: Clip.antiAlias, // 카드 모서리에 맞춰 이미지가 잘리도록 설정
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/sound_check_card.png',
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
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 300,
                height: 100,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UploadScreen()),
                    );
                  },
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/record_analysis_card.png',
                          fit: BoxFit.cover,
                          width: 400,
                          height: 200,
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
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 300,
                height: 100,
                child: GestureDetector(
                  onTap: () {},
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/history_card.png',
                          fit: BoxFit.cover,
                          width: 400,
                          height: 200,
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
            ),
          ],
        ),
      ),
    );
  }
}
