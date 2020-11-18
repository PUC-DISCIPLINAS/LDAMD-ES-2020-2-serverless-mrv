// import 'dart:convert';
// import 'dart:ffi';
// import 'dart:io';
// import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
// import 'package:location_permissions/location_permissions.dart';
// import 'package:geocoding/geocoding.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'PUC SPOT MINAS'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Position _currentPosition;

  GoogleMapController mapController;

   final LatLng _center = const LatLng(45.521563, -122.677433);

  // static LatLng _currentPosition;

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  /*
   * Função responsável por gerar um alerta quando o usuário estiver chegado
   * ao seu destino.
   */

  // void _showAlert(BuildContext context, String campus) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Você chegou!"),
  //         content: Text("Bem vindo(a) à PUC Minas unidade " + campus),
  //         actions: [
  //           FlatButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text("FECHAR"))
  //         ],
  //       );
  //     },
  //   );
  // }

  // /*
  //  * Widget responsável por exibir o mapa com a
  //  * localização do usuário
  //  */
  // Widget _userLocation() {
  //   GoogleMapController mapController;

  //   return Scaffold(
  //     body: Stack(
  //       children: <Widget>[
  //         GoogleMap(
  //             mapType: MapType.normal,
  //             myLocationEnabled: true,
  //             compassEnabled: true,
  //             initialCameraPosition: CameraPosition(
  //               target: LatLng(
  //                   _currentPosition.latitude, _currentPosition.longitude),
  //               zoom: 10.0,
  //             ),
  //             onMapCreated: _onMapCreated),
  //       ],
  //     ),
  //   );
  // }

  /*
   * Método responsável por rastrear o usuário pegando suas coordenadas
   * e toda vez que as coordenadas do usuário mudarem, o método 
   * verifyLocations é chamado.
   */
  // _getCurrentLocation() async {
  //   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
  //       .then((Position position) => {
  //             setState(() {
  //               // constructor
  //               _currentPosition =
  //                   LatLng(position.latitude, position.longitude);
  //             })
  //           });
  // }

  /*
   * QuerySnapShot é retornado uma consulta de coleção e permite que inspecione 
   * essa coleção.
   * 
   * Para acessar os documentos em QuerySnapshot, chame a propriedade docs que 
   * retorna uma lisa que contém o DocumentSnapshot.
   *  
   * DocumentSnapshot => é retornado de uma consulta ou acessando o documento 
   * diretamente. Mesmo que não exista nenhum documento no banco de dados, um 
   * instantâneo sempre será retornado.
   * 
   */
  // findCampusAround(LatLng currentPosition) async {
  //   var lat1, long1, lat2, long2;

  //   lat1 = currentPosition.latitude;
  //   long1 = currentPosition.longitude;

  //   FirebaseFirestore.instance
  //       .collection('campus')
  //       .get()
  //       .then((QuerySnapshot querySnapshot) => {
  //             querySnapshot.docs.forEach((doc) async {
  //               // Traduzir as coordenadas de latitude e longitude em um endereço
  //               // List<Placemark> placemark = await placemarkFromCoordinates(
  //               //   doc["latitude"], doc["longitude"]);

  //               lat2 = doc["latitude"];
  //               long2 = doc["longitude"];

  //               String url =
  //                   "https://us-central1-clean-axiom-294822.cloudfunctions.net/distances?lat_s=" +
  //                       lat1.toString() +
  //                       "&lng_s=" +
  //                       long1.toString() +
  //                       "&lat_d=" +
  //                       lat2.toString() +
  //                       "&lng_d=" +
  //                       long2.toString();

  //               var httpClient = new HttpClient();

  //               try {
  //                 var request = await httpClient.getUrl(Uri.parse(url));
  //                 var response = await request.close();
  //                 if (response.statusCode == HttpStatus.ok) {
  //                   var json = await response.transform(utf8.decoder).join();
  //                   var data = jsonDecode(json);
  //                   var result = data["distance"] as int;

  //                   if (result <= 100) {
  //                     setState(() {
  //                       _showAlert(context, doc["nome"]);
  //                     });
  //                     return true;
  //                   }
  //                   return false;
  //                 } else {
  //                   // ignore: unnecessary_statements
  //                   'Error getting IP address:\nHttp status ${response.statusCode}';
  //                 }
  //               } catch (exception) {
  //                 // result = 'Failed getting IP address';
  //                 print(exception);
  //               }
  //             })
  //           });
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('PUC Spot Minas'),
  //     ),
  //     body: _currentPosition == null
  //         ? Container(
  //             child: Center(
  //               child: CircularProgressIndicator(),
  //             ),
  //           )
  //         : Container(
  //             child: GoogleMap(
  //               initialCameraPosition: CameraPosition(
  //                 target: _center,
  //                 zoom: 15,
  //               ),
  //               onMapCreated: _onMapCreated,
  //               zoomGesturesEnabled: true,
  //               myLocationEnabled: true,
  //               compassEnabled: true,
  //               zoomControlsEnabled: false,
  //             ),
  //           ),
  //   ); // This trailing comma makes auto-formatting nicer for build methods.
  // }

   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      ),
    );
  }


}
