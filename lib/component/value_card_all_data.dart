import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ValueCardAllData extends StatelessWidget {
  final dynamic backColor;
  final dynamic cardIcon;
  final dynamic dataToShown;
  final dynamic label;
  final double? cHeight;
  final double? cWidth;
  const ValueCardAllData({
    super.key,
    required this.backColor,
    required this.cardIcon,
    required this.dataToShown,
    required this.label,
    required this.cHeight,
    required this.cWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: cHeight,
      width: cWidth,
      decoration: BoxDecoration(
        color: backColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label:",
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FaIcon(cardIcon, color: Colors.black, size: 20),
                  Text(
                    dataToShown.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
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
