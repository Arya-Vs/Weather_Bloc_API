import 'dart:developer';

import 'package:bloc_week18/bloc/weather_bloc_bloc.dart';
import 'package:bloc_week18/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: _determinePosition(),
          builder: (context, snap) {
            if (snap.hasData) {
              log('Has Data');
              return BlocProvider<WeatherBlocBloc>(
                create: (context) => WeatherBlocBloc()
                  ..add(FeatchWeather(position: snap.data as Position)),
                child: const HomeScreen(),
              );
            } else {
              log('Has No data');
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ));
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  log('In function');
  await Geolocator.requestPermission();
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    log('Permission denied');
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
 
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}
