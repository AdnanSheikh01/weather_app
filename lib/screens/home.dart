import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/bloc/weather_bloc_bloc.dart';
import 'package:weather_app/widgets/weather_icon.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.position});

  final Position position;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final WeatherBlocBloc weatherBlocBloc;

  bool refresh = false;

  @override
  void initState() {
    weatherBlocBloc = WeatherBlocBloc();
    weatherBlocBloc.add(FetchWeather(widget.position));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Align(
                alignment: const AlignmentDirectional(2, -0.3),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(-2, -0.3),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0, -1.2),
                child: Container(
                  height: 300,
                  width: 400,
                  decoration: const BoxDecoration(
                      shape: BoxShape.rectangle, color: Colors.deepOrange),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
              refresh
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : BlocBuilder<WeatherBlocBloc, WeatherBlocState>(
                      builder: (context, state) {
                        if (state is WeatherBlocSuccess) {
                          String greeting = greetingWithTime();
                          return SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '📍 ${state.weather.areaName}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      greeting,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          refresh = true;
                                        });
                                        weatherBlocBloc.add(
                                          FetchWeather(widget.position),
                                        );

                                        Timer(
                                          const Duration(seconds: 3),
                                          () {
                                            setState(() {
                                              refresh = false;
                                            });
                                          },
                                        );
                                      },
                                      child: const Icon(
                                        Icons.refresh,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                                WeatherIcon(
                                    code: state.weather.weatherConditionCode!),
                                Center(
                                  child: Text(
                                    '${state.weather.temperature!.celsius!.round()}°C',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 55,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    state.weather.weatherMain!.toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Center(
                                  child: Text(
                                    DateFormat('EEEE dd ·')
                                        .add_jm()
                                        .format(state.weather.date!),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset('assets/images/11.png',
                                            scale: 8),
                                        const SizedBox(width: 5),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Sunrise',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              DateFormat().add_jm().format(
                                                  state.weather.sunrise!),
                                              // '5:30 am',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Image.asset('assets/images/12.png',
                                            scale: 8),
                                        const SizedBox(width: 5),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Sunset',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              DateFormat().add_jm().format(
                                                  state.weather.sunset!),
                                              // '7:30 pm',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Divider(color: Colors.grey),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset('assets/images/13.png',
                                            scale: 8),
                                        const SizedBox(width: 5),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Temp Max',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              '${state.weather.tempMax!.celsius!.round()}°C',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Image.asset('assets/images/14.png',
                                            scale: 8),
                                        const SizedBox(width: 5),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Temp Min',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              '${state.weather.tempMin!.celsius!.round()}°C',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }

  String greetingWithTime() {
    final hour = DateTime.now().hour;
    String greeting;

    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good evening';
    }
    return greeting;
  }
}
