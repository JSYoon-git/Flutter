import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(child: _TopPart()),
              Expanded(
                child: Image.asset(
                  'asset/img/middle_image.png',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _TopPart extends StatelessWidget {
  const _TopPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('U&I',
            style: TextStyle(
                color: Colors.white, fontFamily: 'parisienne', fontSize: 80.0)),
        Text(
          '우리 처음 만난 날',
          style: TextStyle(
              color: Colors.white, fontFamily: 'singleday', fontSize: 30.0),
        ),
        Text('2018-09-19',
            style: TextStyle(
                color: Colors.white, fontFamily: 'singleday', fontSize: 20.0)),
        IconButton(
            iconSize: 60.0,
            onPressed: () {},
            icon: Icon(Icons.favorite, color: Colors.red)),
        Text(
          'D+1',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'singleday',
              fontSize: 50.0,
              fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
