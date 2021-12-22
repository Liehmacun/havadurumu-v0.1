import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:weather_app/location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HavaDurumu v0.1 uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Geçerli konumu almak için

  Location location = new Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  late double latitude;
  late double longitude;
  int toggle = 1;

// Konum için fonksiyon
  Future getlocation() async {
    // Konum hizmeti etkin mi değil mi kontrol için
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    //izin verilip verilmediğini kontrol et
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    // konumu almak
    _locationData = await location.getLocation();
    latitude = _locationData.latitude!;
    longitude = _locationData.longitude!;
  }

  // Geçerli tarih ve saati almak için
  String main = DateFormat('MMM ').format(DateTime.now());
  String formattedtime = DateFormat('kk:mm').format(DateTime.now());
  String formatteddate = DateFormat('EEE, d MMM').format(DateTime.now());
  String formatteddate1 = (DateTime.now().day + 1).toString();
  String formatteddate2 = (DateTime.now().day + 2).toString();
  String formatteddate3 = (DateTime.now().day + 3).toString();
  String formatteddate4 = (DateTime.now().day + 4).toString();
  String formatteddate5 = (DateTime.now().day + 5).toString();

  // hava durumunu almak için
  var temp;
  var state;
  var country;
  var temp8;
  var temp10;
  var temp12;
  var temp2;
  var temp4;
  var day1;
  var day2;
  var day3;
  var day4;
  var day5;

  Future getWeather(unit) async {
    Uri url2 = Uri.http("api.openweathermap.org", "/data/2.5/weather", {
      "lat": latitude.toString(),
      'lon': longitude.toString(),
      'appid': '2beb83c72a7edba1158a6b1cc981f660',
      'units': unit
    });
    //https://tile.openweathermap.org/map/temp_new/0/5.3/2.1.png?appid={API key}
    http.Response response = await http.get(url2);
    var results = jsonDecode(response.body);
    setState(() {
      this.temp = results['main']['temp'];

      this.state = results['name'];
      this.country = results['sys']['country'];
    });
  }

 
  Future getWeather2(city) async {
    Uri url2 = Uri.http("api.openweathermap.org", "/data/2.5/weather", {
      "q": city,
      'appid': '2beb83c72a7edba1158a6b1cc981f660',
      'units': 'metric'
    });

    http.Response response = await http.get(url2);
    var results = jsonDecode(response.body);
    setState(() {
      this.temp = results['main']['temp'];

      this.state = results['name'];
      this.country = results['sys']['country'];
    });
  }

  // hava durumunu tahminini al
  Future getWeatherfore(units) async {
    Uri url2 = Uri.http("api.openweathermap.org", "/data/2.5/onecall", {
      "lat": latitude.toString(),
      'lon': longitude.toString(),
      'appid': '2beb83c72a7edba1158a6b1cc981f660',
      'units': units
    });

    http.Response response = await http.get(url2);
    var results = jsonDecode(response.body);
    setState(() {
      this.temp8 = results['hourly'][8]['temp'];
      this.temp10 = results['hourly'][10]['temp'];
      this.temp12 = results['hourly'][12]['temp'];
      this.temp2 = results['hourly'][2]['temp'];
      this.temp4 = results['hourly'][4]['temp'];

      this.day1 = results['daily'][0]['temp']['day'];
      this.day2 = results['daily'][1]['temp']['day'];
      this.day3 = results['daily'][2]['temp']['day'];
      this.day4 = results['daily'][3]['temp']['day'];
      this.day5 = results['daily'][4]['temp']['day'];
    });
  }

  @override
  void initState() {
    super.initState();
    // kullanıcı arayüzünü oluşturulmadan önce konumu alın
    this.getlocation().then((value) {
      this.getWeatherfore('metric');
      return this.getWeather('metric');
    });
    // kullanıcı arayüzünü oluşturulmadan önce hava durumunu alın
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.indigo[600],
        padding: EdgeInsets.symmetric(vertical: 80, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Locaton(
                                  lat: latitude,
                                  long: longitude,
                                )));
                  },
                  child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.indigo[400],
                          borderRadius: BorderRadius.circular(40.0)),
                      child: Row(
                        children: [
                          Icon(Icons.location_pin, color: Colors.white),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                state != null
                                    ? state.toString() +
                                        ', ' +
                                        (country != null
                                            ? country.toString()
                                            : '')
                                    : "Yükleniyor",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                          )
                        ],
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    bottomsheet2();
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.indigo[400],
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Icon(Icons.notifications, color: Colors.white),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showdialog();
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.indigo[400],
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Icon(Icons.search, color: Colors.white),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (toggle == 1) {
                      setState(() {
                        toggle = 2;
                      });
                      this.getWeather('imperial');
                      this.getWeatherfore('imperial');
                    } else {
                      setState(() {
                        toggle = 1;
                      });
                      this.getWeather('metric');
                      this.getWeatherfore('metric');
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.indigo[400],
                        borderRadius: BorderRadius.circular(10.0)),
                    child: toggle == 1
                        ? Icon(Icons.toggle_on, color: Colors.white)
                        : Icon(Icons.toggle_off, color: Colors.white),
                  ),
                )
              ],
            ),

            ////
            ///
            Container(
              padding: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5, // edited
              decoration: BoxDecoration(
                  color: Colors.indigo[400],
                  borderRadius: BorderRadius.circular(13.0),
                  border: Border.all(color: Colors.white, width: 1.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    FaIcon(FontAwesomeIcons.cloudRain,
                        color: Colors.white, size: 40.0),
                    SizedBox(width: 10),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bugün',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          Text(formatteddate,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white))
                        ]),
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(temp != null ? temp.toString() + "\u00B0" : "Yükleniyor",
                        style: TextStyle(fontSize: 80, color: Colors.white)),
                    SizedBox(
                      width: 5,
                    ),
                    Text((toggle == 1 ? 'C' : 'F'),
                        style: TextStyle(fontSize: 40, color: Colors.white))
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                        state != null
                            ? state.toString() +
                                ', ' +
                                (country != null ? country.toString() : '')
                            : "Yükleniyor",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    SizedBox(width: 5),
                    Icon(Icons.stop_circle_rounded,
                        color: Colors.white, size: 7),
                    SizedBox(width: 5),
                    Text('$formattedtime',
                        style: TextStyle(color: Colors.white, fontSize: 20))
                  ]),
                ],
              ),
            ),

            //////
            GestureDetector(
              onTap: () {
                bottomsheet();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                    color: Colors.indigo[400],
                    borderRadius: BorderRadius.circular(5.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width / 3),
                    Text('Hava tahmin raporu',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    SizedBox(
                      width: 20,
                    ),
                    FaIcon(FontAwesomeIcons.angleUp, color: Colors.white),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //hava durumu raporu için
  bottomsheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: false,
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(12.0),
            height: MediaQuery.of(context).size.height / 1.5,
            // height: MediaQuery.of(context).size.height / 1,
            child: Column(
              children: [
                SizedBox(
                  height: 2,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Divider(thickness: 6, color: Colors.black45),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(40.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Tahmin raporu',
                                style: TextStyle(
                                    color: Colors.indigo[400], fontSize: 17)),
                            SizedBox(
                              width: 20,
                            ),
                            FaIcon(FontAwesomeIcons.angleDown,
                                color: Colors.indigo[500]),
                          ],
                        ),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Bugün",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border:
                          Border.all(color: Colors.indigo[100]!, width: 1.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(children: [
                        Text(
                            temp8 != null
                                ? temp8.toString() +
                                    "\u00B0" +
                                    (toggle == 1 ? 'c' : 'F')
                                : "---",
                            style: TextStyle(fontSize: 20)),
                        //Icon(Icons.wb_sunny_outlined, color: Colors.orange),
                        SizedBox(height: 7),
                        Icon(Icons.wb_sunny_outlined,
                            color: Colors.orange, size: 35),
                        SizedBox(height: 7),
                        Text('08:00', style: TextStyle(fontSize: 20))
                      ]),
                      Column(children: [
                        Text(
                            temp10 != null
                                ? temp10.toString() +
                                    "\u00B0" +
                                    (toggle == 1 ? 'c' : 'F')
                                : "---",
                            style: TextStyle(fontSize: 20)),
                        //Icon(Icons.wb_sunny_outlined, color: Colors.orange),
                        SizedBox(height: 7),
                        Icon(Icons.wb_sunny_outlined,
                            color: Colors.orange, size: 35),
                        SizedBox(height: 7),
                        Text('10:00', style: TextStyle(fontSize: 20))
                      ]),
                      Column(children: [
                        Text(
                            temp12 != null
                                ? temp12.toString() +
                                    "\u00B0" +
                                    (toggle == 1 ? 'c' : 'F')
                                : "---",
                            style: TextStyle(fontSize: 20)),
                        //Icon(Icons.wb_sunny_outlined, color: Colors.orange),
                        SizedBox(height: 7),
                        Icon(Icons.wb_sunny_rounded,
                            color: Colors.orange, size: 35),
                        SizedBox(height: 7),
                        Text('12:00', style: TextStyle(fontSize: 20))
                      ]),
                      Column(children: [
                        Text(
                            temp2 != null
                                ? temp2.toString() +
                                    "\u00B0" +
                                    (toggle == 1 ? 'c' : 'F')
                                : "---",
                            style: TextStyle(fontSize: 20)),
                        //Icon(Icons.wb_sunny_outlined, color: Colors.orange),
                        SizedBox(height: 7),
                        Icon(Icons.wb_sunny_rounded,
                            color: Colors.orange, size: 35),
                        SizedBox(height: 7),
                        Text('14:00', style: TextStyle(fontSize: 20))
                      ]),
                      Column(children: [
                        Text(
                            temp4 != null
                                ? temp4.toString() +
                                    "\u00B0" +
                                    (toggle == 1 ? 'c' : 'F')
                                : "---",
                            style: TextStyle(fontSize: 20)),
                        //Icon(Icons.wb_sunny_outlined, color: Colors.orange),
                        SizedBox(height: 7),
                        Icon(Icons.wb_sunny_rounded,
                            color: Colors.orange, size: 35),
                        SizedBox(height: 7),
                        Text('16:00', style: TextStyle(fontSize: 20))
                      ]),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Sonraki tahmin",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold)),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Colors.indigo[400],
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Text('Beş gün',
                          style: TextStyle(color: Colors.white, fontSize: 17)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border:
                          Border.all(color: Colors.indigo[100]!, width: 1.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(main + formatteddate1,
                              style: TextStyle(fontSize: 20)),
                          //Icon(Icons.wb_sunny_outlined, color: Colors.orange),

                          Icon(Icons.wb_sunny_outlined,
                              color: Colors.orange, size: 35),

                          Text(
                              day1 != null
                                  ? day1.toString() +
                                      "\u00B0" +
                                      (toggle == 1 ? 'c' : 'F')
                                  : "---",
                              style: TextStyle(fontSize: 20))
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(main + formatteddate2,
                              style: TextStyle(fontSize: 20)),
                          //Icon(Icons.wb_sunny_outlined, color: Colors.orange),

                          Icon(Icons.wb_sunny_outlined,
                              color: Colors.orange, size: 35),

                          Text(
                              day2 != null
                                  ? day2.toString() +
                                      "\u00B0" +
                                      (toggle == 1 ? 'c' : 'F')
                                  : "---",
                              style: TextStyle(fontSize: 20))
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(main + formatteddate3,
                              style: TextStyle(fontSize: 20)),
                          //Icon(Icons.wb_sunny_outlined, color: Colors.orange),

                          Icon(Icons.wb_sunny_outlined,
                              color: Colors.orange, size: 35),

                          Text(
                              day3 != null
                                  ? day3.toString() +
                                      "\u00B0" +
                                      (toggle == 1 ? 'c' : 'F')
                                  : "---",
                              style: TextStyle(fontSize: 20))
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(main + formatteddate4,
                              style: TextStyle(fontSize: 20)),
                          //Icon(Icons.wb_sunny_outlined, color: Colors.orange),

                          Icon(Icons.wb_sunny_outlined,
                              color: Colors.orange, size: 35),

                          Text(
                              day4 != null
                                  ? day4.toString() +
                                      "\u00B0" +
                                      (toggle == 1 ? 'c' : 'F')
                                  : "---",
                              style: TextStyle(fontSize: 20))
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(main + formatteddate5,
                              style: TextStyle(fontSize: 20)),
                          //Icon(Icons.wb_sunny_outlined, color: Colors.orange),

                          Icon(Icons.wb_sunny_outlined,
                              color: Colors.orange, size: 35),

                          Text(
                              day5 != null
                                  ? day5.toString() +
                                      "\u00B0" +
                                      (toggle == 1 ? 'c' : 'F')
                                  : "---",
                              style: TextStyle(fontSize: 20))
                        ],
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  // bildirimler için
  bottomsheet2() {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: false,
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(20.0),
            height: MediaQuery.of(context).size.height / 2.3,
            // height: MediaQuery.of(context).size.height / 1,
            child: Column(
              children: [
                SizedBox(
                  height: 2,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Divider(thickness: 6, color: Colors.black45),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(40.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Bildirimlerim',
                            style: TextStyle(
                                color: Colors.indigo[400], fontSize: 17)),
                      )),
                ),
                SizedBox(
                  height: 40,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Yeni",
                      style: TextStyle(
                        color: Colors.black45,
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.wb_sunny_rounded,
                          color: Colors.orange, size: 35),
                      SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('10 dakika önce',
                              style: TextStyle(
                                color: Colors.black45,
                              )),
                          SizedBox(height: 5),
                          Text(' Bulunduğunuz yerde güneşli bir gün hakim',
                              style: TextStyle(
                                fontSize: 23,
                                color: Colors.black,
                              ))
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Daha erken",
                      style: TextStyle(
                        color: Colors.black45,
                      )),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.wb_sunny_rounded,
                          color: Colors.orange, size: 35),
                      SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('1 gün önce',
                              style: TextStyle(
                                color: Colors.black45,
                              )),
                          SizedBox(height: 5),
                          Text(' Bulunduğunuz yerde güneşli bir gün hakim',
                              style: TextStyle(
                                fontSize: 23,
                                color: Colors.black,
                              ))
                        ],
                      )
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.wb_sunny_rounded,
                          color: Colors.orange, size: 35),
                      SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('2 gün önce',
                              style: TextStyle(
                                color: Colors.black45,
                              )),
                          SizedBox(height: 5),
                          Text(' Bulunduğunuz yerde güneşli bir gün',
                              style: TextStyle(
                                fontSize: 23,
                                color: Colors.black,
                              ))
                        ],
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  //arama işlevi için iletişime geçme kutusu
  showdialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
              child: Container(
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Şehir adını giriniz...'),
                        onFieldSubmitted: (name) {
                          getWeather2(name);
                          Navigator.pop(context);
                        },
                        onSaved: (name) {
                          getWeather2(name);
                        }),
                  )),
            ));
  }
}
