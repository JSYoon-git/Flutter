import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? timer;
  PageController controller = PageController(
    initialPage: 0,
  );
  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      int currentPage = controller.page!.toInt();
      int nextPage = currentPage + 1;

      if (nextPage > 5) {
        nextPage = 0;
      }

      controller.animateToPage(nextPage,
          duration: const Duration(milliseconds: 400), curve: Curves.linear);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      body: PageView(
        controller: controller,
        children: [1, 2, 3, 4, 5, 6]
            .map(
              (e) => Image.asset(
                'asset/img/image$e.jpg',
                fit: BoxFit.cover,
              ),
            )
            .toList(),
      ),
    );
  }
}
