import 'package:flutter/material.dart';
import 'package:water_monitor/component/all_data_card.dart';
import 'package:water_monitor/models/monitored_data.dart';

class AllDataPage extends StatelessWidget {
  final List<MonitoredData> allDataList;
  const AllDataPage({super.key, required this.allDataList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Data"), centerTitle: true),
      body: ListView.builder(
        itemCount: allDataList.length,
        itemBuilder: (BuildContext context, int index) {
          return AllDataCard(data: allDataList[index]);
        },
      ),
    );
  }
}
