import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:water_monitor/component/value_card_all_data.dart';
import 'package:water_monitor/models/monitored_data.dart';
import 'package:intl/intl.dart';

class AllDataCard extends StatelessWidget {
  final MonitoredData data;
  const AllDataCard({super.key, required this.data});

  String? filteredDateTime(String? isoDate) {
    DateTime dateTime = DateTime.parse(isoDate!);
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    return formattedDate; // Output: 2025-03-30 19:11:17
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 350,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xff323445),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 18,
                right: 18,
                top: 15,
                bottom: 10,
              ),
              child: ValueCardAllData(
                cHeight: 100,
                cWidth: double.infinity,
                label: "Time",
                backColor: Color(0xff78DCFB),
                cardIcon: FontAwesomeIcons.clock,
                dataToShown: filteredDateTime(data.timestamp),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ValueCardAllData(
                  cHeight: 100,
                  cWidth: 150,
                  label: "pH",
                  backColor: Color(0xffFF935F),
                  cardIcon: FontAwesomeIcons.flask,
                  dataToShown: data.p.toString(),
                ),
                SizedBox(width: 10),
                ValueCardAllData(
                  cHeight: 100,
                  cWidth: 150,
                  label: "Turbidity",
                  backColor: Color(0xff8EFF67),
                  cardIcon: FontAwesomeIcons.water,
                  dataToShown: data.u.toString(),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ValueCardAllData(
                  cHeight: 100,
                  cWidth: 150,
                  label: "TDS",
                  backColor: Color(0xffDA88FF),
                  cardIcon: FontAwesomeIcons.handHoldingWater,
                  dataToShown: data.d.toString(),
                ),
                SizedBox(width: 10),

                ValueCardAllData(
                  cHeight: 100,
                  cWidth: 150,
                  label: "Temperature",
                  backColor: Color(0xff78DCFB),
                  cardIcon: FontAwesomeIcons.temperatureHigh,
                  dataToShown: data.t.toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
