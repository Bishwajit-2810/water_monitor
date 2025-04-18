import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:water_monitor/ai/prompt_result_screen.dart';
import 'package:water_monitor/api.dart';
import 'package:water_monitor/component/all_data_page.dart';
import 'package:water_monitor/component/value_card.dart';
import 'package:water_monitor/models/monitored_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:water_monitor/theme/theme_notifier.dart';

class WaterApp extends StatefulWidget {
  const WaterApp({super.key});

  @override
  State<WaterApp> createState() => _WaterAppState();
}

class _WaterAppState extends State<WaterApp> {
  Stream<List<MonitoredData>> get waterDataStream async* {
    while (true) {
      yield await getAllDataWater();
      await Future.delayed(Duration(seconds: 10)); // Fetch every 10 sec
    }
  }

  Future<List<MonitoredData>> getAllDataWater() async {
    try {
      final response = await http.get(Uri.parse(API));

      if (response.statusCode != 200) {
        throw 'Failed to load data';
      }

      final data = jsonDecode(response.body.toString());

      if (data == null || data.isEmpty) {
        throw 'No data found';
      }

      return data
          .map<MonitoredData>(
            (i) => MonitoredData(
              sId: i['_id'],
              t: i['T'],
              d: i['D'],
              u: i['U'],
              p: i['P'],
              f: i['F'],
              l: i['L'],
              timestamp: i['timestamp'],
              iV: i['__v'],
            ),
          )
          .toList();
    } catch (e) {
      throw 'Error fetching data: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return ValueListenableBuilder(
      valueListenable: isDarkThemeNotifier,
      builder: (BuildContext context, dynamic isDarkTheme, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Water Monitor",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: InkWell(
                  onTap: () {
                    isDarkThemeNotifier.value = !isDarkThemeNotifier.value;
                  },
                  child:
                      (isDarkThemeNotifier.value)
                          ? FaIcon(
                            color: Colors.yellow,
                            FontAwesomeIcons.solidSun,
                            size: 25,
                          )
                          : FaIcon(
                            FontAwesomeIcons.solidMoon,
                            color: Colors.blueGrey,
                            size: 25,
                          ),
                ),
              ),
            ],
          ),
          body: StreamBuilder<List<MonitoredData>>(
            stream: waterDataStream, // Stream updates every 2 minutes
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No data available"));
              }

              List<MonitoredData> dataList = snapshot.data!;
              MonitoredData latestData = dataList[0];

              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      child: Column(
                        children: [
                          (alert(
                                latestData.p! * 1.0,
                                latestData.u! * 1.0,
                                latestData.d! * 1.0,
                              ))
                              ? SizedBox(
                                height: screenHeight * 0.3,
                                width: screenWidth,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ContentScreen(
                                              latestAlertData: latestData,
                                            );
                                          },
                                        ),
                                      );
                                    });
                                  },
                                  child: Lottie.asset('lib/assets/alert.json'),
                                ),
                              )
                              : SizedBox(
                                height: screenHeight * 0.3,
                                width: screenWidth,
                                child: Lottie.asset('lib/assets/green.json'),
                              ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              width: double.infinity,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Color(0xffFEE665),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.tachometerAlt,
                                            color: Colors.black,
                                            size: 20,
                                          ),
                                          Text(
                                            " Flow Rate",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "${latestData.f} L/min",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.tint,
                                            color: Colors.black,
                                            size: 20,
                                          ),
                                          Text(
                                            " Water Flowed",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "${latestData.l} L",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.center,
                            children: [
                              ValueCard(
                                cHeight: screenHeight * 0.25,
                                cWidth: screenWidth * 0.45,
                                label: "pH",
                                backColor: Color(0xffFF935F),
                                cardIcon: FontAwesomeIcons.flask,
                                dataToShown: latestData.p.toString(),
                                details:
                                    "Water pH measures acidity or alkalinity on a scale from 0 to 14, with 7 being neutral; safe drinking water typically has a pH between 6.5 and 8.5.",
                              ),
                              ValueCard(
                                cHeight: screenHeight * 0.25,
                                cWidth: screenWidth * 0.45,
                                label: "Turbidity",
                                backColor: Color(0xff8EFF67),
                                cardIcon: FontAwesomeIcons.water,
                                dataToShown: latestData.u.toString(),
                                details:
                                    "Water turbidity measures clarity, indicating suspended particles; safe drinking water typically has turbidity below 1 NTU, with a maximum limit of 5 NTU.",
                              ),
                              ValueCard(
                                cHeight: screenHeight * 0.25,
                                cWidth: screenWidth * 0.45,
                                label: "TDS",
                                backColor: Color(0xffDA88FF),
                                cardIcon: FontAwesomeIcons.handHoldingWater,
                                dataToShown: latestData.d.toString(),
                                details:
                                    "Water TDS (Total Dissolved Solids) measures dissolved minerals and salts; safe drinking water typically has a TDS range of 50–500 mg/L, with an upper limit of 1,000 mg/L.",
                              ),
                              ValueCard(
                                cHeight: screenHeight * 0.25,
                                cWidth: screenWidth * 0.45,
                                label: "Temperature",
                                backColor: Color(0xff78DCFB),
                                cardIcon: FontAwesomeIcons.temperatureHigh,
                                dataToShown: latestData.t.toString(),
                                details:
                                    "Water temperature affects its quality and ecosystem; safe drinking water typically ranges from 10°C to 25°C for optimal taste and health.",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return AllDataPage(allDataList: dataList);
                              },
                            ),
                          );
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(0xff787C9A),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.database,
                                  size: 18,
                                  color: Colors.black,
                                ),
                                Text(
                                  "  All Data By Time",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  bool alert(double ph, double turbidity, double tds) {
    return (ph < 6.0 || ph > 8.0) || turbidity >= 100.0 || tds >= 500.0;
  }
}
