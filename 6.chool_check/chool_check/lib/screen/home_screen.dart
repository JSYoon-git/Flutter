import 'dart:async';
import 'dart:js_util';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // latitude = 위도, longitude = 경도
  static final LatLng companyLatLng = LatLng(35.1687676, 126.9362036);
  static final CameraPosition initialPosition =
      CameraPosition(target: companyLatLng, zoom: 15);
  static final double okDistance = 100;
  static final Circle withInDistanceCircle = Circle(
    circleId: CircleId('withInDistanceCircle'),
    center: companyLatLng,
    fillColor: Colors.blue.withOpacity(0.5),
    radius: okDistance,
    strokeColor: Colors.blue,
    strokeWidth: 1,
  );
  static final Circle notWithInDistanceCircle = Circle(
    circleId: CircleId('notWithInDistanceCircle'),
    center: companyLatLng,
    fillColor: Colors.red.withOpacity(0.5),
    radius: okDistance,
    strokeColor: Colors.red,
    strokeWidth: 1,
  );
  static final Circle checkDoneCircle = Circle(
    circleId: CircleId('checkDoneCircle'),
    center: companyLatLng,
    fillColor: Colors.green.withOpacity(0.5),
    radius: okDistance,
    strokeColor: Colors.green,
    strokeWidth: 1,
  );
  static final Marker marker =
      Marker(markerId: MarkerId('marekr'), position: companyLatLng);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: renderAppBar(),
        body: FutureBuilder<String>(
            future: checkPermission(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data == '위치 권한이 허가되었습니다.') {
                return StreamBuilder<Position>(
                    stream: Geolocator.getPositionStream(),
                    builder: (context, snapshot) {
                      bool isWidthRange = false;

                      if (snapshot.hasData) {
                        final start = snapshot.data!;
                        final end = companyLatLng;

                        final distance = Geolocator.distanceBetween(
                            start.latitude,
                            start.longitude,
                            end.latitude,
                            end.longitude);
                        if (distance < okDistance) {
                          isWidthRange = true;
                        }
                      }
                      return Column(
                        children: [
                          _CustomGoogleMap(
                            initialPosition: initialPosition,
                            withInDistanceCircle: isWidthRange
                                ? withInDistanceCircle
                                : notWithInDistanceCircle,
                            marker: marker,
                          ),
                          _ChoolCheckButton(),
                        ],
                      );
                    });
              } else {
                return Center(child: Text(snapshot.data));
              }
            }));
  }

  Future<String> checkPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      return '위치 서비스를 활성화 해주세요.';
    }

    LocationPermission checkedPermission = await Geolocator.checkPermission();

    if (checkedPermission == LocationPermission.denied) {
      checkedPermission = await Geolocator.requestPermission();

      if (checkedPermission == LocationPermission.denied) {
        return '위치 권한을 허가해주세요.';
      }
    }

    if (checkedPermission == LocationPermission.deniedForever) {
      return '앱의 위치 권한을 세팅에서 허가해주세요.';
    }

    return '위치 권한이 허가되었습니다.';
  }

  AppBar renderAppBar() {
    return AppBar(
      title: Text(
        '오늘도 출근',
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),
      ),
      backgroundColor: Colors.white,
    );
  }
}

class _CustomGoogleMap extends StatelessWidget {
  final CameraPosition initialPosition;
  final Circle withInDistanceCircle;
  final Marker marker;

  const _CustomGoogleMap(
      {required this.initialPosition,
      required this.withInDistanceCircle,
      required this.marker,
      Key? key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        circles: Set.from([withInDistanceCircle]),
        markers: Set.from([marker]),
      ),
    );
  }
}

class _ChoolCheckButton extends StatelessWidget {
  const _ChoolCheckButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text('출근'),
    );
  }
}
