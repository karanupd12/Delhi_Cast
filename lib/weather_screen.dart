// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info_items.dart';
import 'package:weather_app/confidential.dart';
import 'package:weather_app/hourly_cast.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget{
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  
  //api for latest weather forecast

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try{
      String cityname = "uttarakhand";
      final result = await http.get(Uri.parse('http://api.openweathermap.org/data/2.5/forecast?q=$cityname&APPID=$openweatherapikey'),);

      final data = jsonDecode(result.body);
    
      if(data['cod'] != '200'){
        throw 'An unexpected error occured';
      }
      return data;
      
    }catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //APPBAR
      appBar: AppBar(
        centerTitle: true,
        title : const Text('Delhi Cast \u{1F327}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26 ),),
        actions: [IconButton(onPressed: () {
          setState(() {});
        }, icon: const Icon(Icons.refresh))],
      ),
      

      //BODY : we are going to create 3 parts in body  1st - a card for selected , 2nd - a scrollable row with multiple hourly cast cards , 3rd -  for multiple climate conditions

      //fetching data from the openweathermap api
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          // ignore: avoid_print
          print (snapshot);

          if (snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }

          if(snapshot.hasError){
            return Text(snapshot.error.toString());
          }
          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];

          final currentTemp = currentWeatherData ['main']['temp'];
          final currentsky = currentWeatherData ['weather'][0]['main'];
          final pressure = currentWeatherData ['main']['pressure'];
          final humidity = currentWeatherData ['main']['humidity'];
          final windspeed = currentWeatherData ['wind']['speed'];

          return Padding(
          padding: const EdgeInsets.all(16),
              
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              
              //part-1 >> showing the temp and weather of current time
              SizedBox(    //box for card 1
                width: double.infinity,
                child: Card(
                  elevation: 11,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1.3, sigmaY:1.3),
              
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text( "$currentTemp K", style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold) ,),
                          Icon(currentsky == 'Clouds' || currentsky == 'Rain' ? Icons.cloud : Icons.sunny , size: 36,),
                          Text(currentsky, style: const TextStyle(fontSize:20, ))                                
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              
              //part-2 >> showing the weather at different time >>>creating multiple cards inside a horizontablly scrollable row by returning hourlycast in desired loop
              const SizedBox(height: 30),
              const Text('Weather Forecast', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              SizedBox(
                height: 130,
                child: ListView.builder(
                  itemCount: 8,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final Hourly_Cast = data['list'][index + 1];
                    final Hourly_Sky = data['list'][index +1]['weather'][0]['main'];
                    final time = DateTime.parse(Hourly_Cast['dt_txt']);
                    return HourlyCast(
                      time: DateFormat.j().format(time),
                      icon: Hourly_Sky == 'Clouds' || Hourly_Sky == 'Rain' ? Icons.cloud : Icons.sunny,
                      temp: '${Hourly_Cast['main']['temp']} K',
                    );
                  },
                ),
              ),
              

              //part-3 >>  for multiple climate conditions
              const SizedBox(height: 30),
              const Text('Additional Information', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
              const SizedBox(height: 8),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInfoItems(icon: Icons.water_drop, label: 'Humidity', value: humidity.toString(),),
                  AdditionalInfoItems(icon: Icons.air, label: 'Wind Speed', value: windspeed.toString(),),
                  AdditionalInfoItems(icon: Icons.beach_access, label: 'Pressure', value: pressure.toString(),),
                ],
              ),
              
              
            ],
          ), 
        );
        },
      ),
    );
  }
}



