// this class is created to print a single hour forecast in Weather forecast section, we can use it multiple times for multiple hour cast in 2nd part of weatherscreen.dart


// ignore_for_file: file_names

import 'package:flutter/material.dart';

class HourlyCast extends StatelessWidget {
  //constructors for different temperature at different time
  final String time;
  final IconData icon;
  final String temp;

  const HourlyCast({
    super.key,
    required this.time,
    required this.icon,
    required this.temp,
    });

  @override
  Widget build(BuildContext context) {

    return 
    Card(
      elevation: 6,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Text(time,style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, ),maxLines: 1,overflow: TextOverflow.ellipsis,),
            const SizedBox(height: 8),
            Icon(icon, size: 35),
            const SizedBox(height: 8),
            Text(temp, style: const TextStyle(fontSize: 16),),
          ],  
        ),
      ),
    );

  }
}



