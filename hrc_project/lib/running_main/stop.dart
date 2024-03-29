// ignore_for_file: unnecessary_new, prefer_const_constructors

import 'dart:async';
import 'dart:ffi';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hrc_project/running_main/countdown.dart';
import 'package:hrc_project/running_main/savePage.dart';
import 'package:hrc_project/running_main/showmap.dart';
import 'package:hrc_project/running_main/util.dart';
import 'package:intl/intl.dart';
import 'package:shake/shake.dart';
import 'counter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:google_fonts/google_fonts.dart';


double speed = 0;
double _avgSpeed = 0;
int _speedCounter = 0;
String user_name = '';
String email = '';
String user_image = '';
double dist = 0;
late String displayTime;
late int _time = 0;
late int _lastTime = 0;

class stop extends StatefulWidget {
  @override
  State<stop> createState() => MapSampleState();
}

class MapSampleState extends State<stop> {
  final Set<Polyline> polyline = {};
  Location _location = Location();

  late GoogleMapController _mapController;
  LatLng _center = const LatLng(0, 0);

  List<LatLng> route = [];

  late String date = getToday();

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose(); // Need to call dispose function.
  }


  //clear Varialbe Value
  void set_clear() {
    dist = 0;
    _time = 0;
    _lastTime = 0;
    speed = 0;
    _avgSpeed = 0;
    _speedCounter = 0;
  }

  //Calculating Expression [Speed, distance]
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    double appendDist;

    _location.onLocationChanged.listen((event) {
      LatLng loc = LatLng(event.latitude!, event.longitude!);
      _mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: loc, zoom: 16)));

      if (route.length > 0) {
        appendDist = Geolocator.distanceBetween(route.last.latitude,
            route.last.longitude, loc.latitude, loc.longitude);
        dist = dist + appendDist;
        int timeDuration = (_time - _lastTime);

        if (_lastTime != null && timeDuration != 0) {
          speed = (appendDist / (timeDuration / 100)) * 3.6;
          if (speed != 0) {
            _avgSpeed = _avgSpeed + speed;
            _speedCounter++;
          }
        }
      }
      _lastTime = _time;
      route.add(loc);

      polyline.add(Polyline(
          polylineId: PolylineId(event.toString()),
          visible: true,
          points: route,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          color: Color.fromARGB(255, 48, 114, 255)));

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
      _stopWatchTimer.onExecute
          .add(StopWatchExecute.start); // Do stuff on phone shake
    });
    return new Scaffold(
      body: Stack(
        children: [
          Container(
              child: GoogleMap(
            polylines: polyline,
            zoomControlsEnabled: true,
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(target: LatLng(37.42796133580664, -122.085749655962), zoom: 13),
          )),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[200],
                  foregroundImage: NetworkImage(
                    user_image,
                  ),
                  child: Icon(
                    Icons.account_circle,
                    size: 17,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user_name,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        getToday(),
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.05),
            child: Positioned(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 20,
                    height: 80,
                  ),
                  SizedBox(height: 100),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0x50C9EF).withOpacity(0.7),
                              const Color(0X53DFA9).withOpacity(0.3),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.7),
                              spreadRadius: 0,
                              blurRadius: 5.0,
                              offset:
                                  Offset(0, 10), // changes position of shadow
                            ),
                          ],
                        ),
                        height: MediaQuery.of(context).size.width / 1.1,
                        width: 200,
                        margin: EdgeInsets.all(35.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 27,
                            ),
                            Container(
                                child: StreamBuilder<int>(
                              stream: _stopWatchTimer.rawTime,
                              initialData: 0,
                              builder: (context, snap) {
                                _time = snap.data!;
                                displayTime = StopWatchTimer
                                        .getDisplayTimeHours(_time) +
                                    ":" +
                                    StopWatchTimer.getDisplayTimeMinute(_time) +
                                    ":" +
                                    StopWatchTimer.getDisplayTimeSecond(_time);
                                return Text(
                                  displayTime,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 30,
                                  ),
                                );
                              },
                            )),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              child: Text(
                                u_rc,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color: Color.fromARGB(255, 87, 85, 85),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Divider(
                                    color: Color.fromARGB(255, 141, 137, 137),
                                    thickness: 2.0)),
                            SizedBox(
                              height: 13,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      child: Text(
                                        (dist / 1000).toStringAsFixed(2),
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        'km',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                Color.fromARGB(255, 92, 89, 89),
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    InkWell(
                                      child: Image.asset('image/play_btn.png',
                                          width: 60, height: 60),
                                      onTap: () {
                                        _stopWatchTimer.onExecute
                                            .add(StopWatchExecute.start);
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      child: Text(
                                        speed.toStringAsFixed(2),
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        'pace',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                Color.fromARGB(255, 92, 89, 89),
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    InkWell(
                                      child: Image.asset('image/stop_btn.png',
                                          width: 50, height: 50),
                                      onLongPress: () {
                                        startcounter();
                                        _stopWatchTimer.onExecute
                                            .add(StopWatchExecute.stop);
                                        addSubCollection();
                                        updatePersonalRecord();
                                        set_clear();
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return savePage();
                                            },
                                          ),
                                        );
                                      },
                                      onTap: () {
                                        startcounter();
                                        _stopWatchTimer.onExecute
                                            .add(StopWatchExecute.stop);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


//***************Firebase
Future updatePersonalRecord() async {
  Util ut = new Util();
  final user = await FirebaseAuth.instance.currentUser;

  final userData =
      await FirebaseFirestore.instance.collection('users').doc(user!.uid);

  u_sum_time += ut.timeToInt(displayTime);
  u_sum_dist += double.parse((dist / 1000).toStringAsFixed(2));

  await userData.update({
    'sum_distance': u_sum_dist,
    'sum_time': u_sum_time,
  });
}

Future addSubCollection() async {
  Util ut = new Util();
  final user = await FirebaseAuth.instance.currentUser;

  await FirebaseFirestore.instance
      .collection('users')
      .doc(user?.uid)
      .collection('running record')
      .add({
    'distance': double.parse((dist / 1000).toStringAsFixed(2)),
    'time': ut.timeToInt(displayTime),
    'pace': speed,
    'date': DateTime.now(),
  });
}
