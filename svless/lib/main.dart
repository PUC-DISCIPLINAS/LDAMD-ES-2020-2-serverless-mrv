import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:geocoding/geocoding.dart';

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

  GoogleMapController mapController;

  static LatLng _currentPosition;

  int _dialog = 0;

  /*
   * Chamado apenas uma única vez, na criação do Widget, assim que o widget
   * é inserido na widget tree. 
   */
  @override
  void initState() {
    super.initState();
    _getUserCurrentLocation();
    _listenUserLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  /*
   * Função responsável por gerar um alerta quando o usuário estiver chegado
   * ao seu destino.
   */

  void _showAlert(BuildContext context, String campus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Você chegou!"),
          content: Text("Bem vindo(a) à PUC Minas unidade " + campus),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("FECHAR"))
          ],
        );
      },
    );
  } // end _showAlert()

  /*
   * Método responsável por rastrear o usuário pegando suas coordenadas.
   * 
   * setState() => Exclusivo para widgets Stateful. É utilizado para alterações
   * de estado. Ao ser chamado o widget será reconstruído já com o novo valor 
   * da variável.
   * 
   */
  
  _getUserCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  } // end _getUserCurrentLocation()

  /*
   * Para ouvir as mudanças de localização utilizamos o getPositionStream() para
   * o fluxo de recepção, dessa forma recebemos as atualizações de posição.
   * 
   * @desiredAccuracy: a precisão dos dados de localização que o aplicativo
   * vai receber;
   * 
   * @timeInterval: a quantidade mínima de tempo que precisa passar antes que 
   * um evento de atualização seja gerado;
   * 
   * @distanceFilter: a distância mínima (medida em metros) que um dispositivo
   * deve se mover horizontalmente antes que um evento de atualização seja
   * gerado;
   */

  _listenUserLocation() {
    Geolocator
    .getPositionStream(desiredAccuracy: LocationAccuracy.best, 
      timeInterval: 1000, distanceFilter: 50)
      .listen((Position position) {
          setState(() {
            _currentPosition = LatLng(position.latitude, position.longitude);
          });
          _tryCheckInCampus();
      });
  } // end _listenUserLocation()

  _tryCheckInCampus() async {
    await searchCampus(_currentPosition);
  } // _tryCheckInCampus()

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
  searchCampus(LatLng currentPosition) async {
    
    var lat1, long1, lat2, long2;

    lat1 = currentPosition.latitude;
    long1 = currentPosition.longitude;

    int aux = 0;
    bool answer = false;

    FirebaseFirestore.instance
        .collection('campus')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) async {
                
                lat2 = doc["latitude"];
                long2 = doc["longitude"];

                String url =
                    "https://us-central1-clean-axiom-294822.cloudfunctions.net/distances?lat_s=" +
                        lat1.toString() +
                        "&lng_s=" +
                        long1.toString() +
                        "&lat_d=" +
                        lat2.toString() +
                        "&lng_d=" +
                        long2.toString();

                var httpClient = new HttpClient();

                try {
                  var request = await httpClient.getUrl(Uri.parse(url));
                  var response = await request.close();
                  if (response.statusCode == HttpStatus.ok) {
                    var json = await response.transform(utf8.decoder).join();
                    var data = jsonDecode(json);
                    var result = data["distance"] as double;
                    
                    if (result <= 100) {
                      answer = true;

                      if(answer) {
                        aux = 1;
                      }
                    
                      _showAlert(context, doc["nome"]);
                  
                      return true;
                    } else {
                      return false;
                    }
                  } else {
                    // ignore: unnecessary_statements
                    'Error getting IP address:\nHttp status ${response.statusCode}';
                  }
                } catch (exception) {
                  // result = 'Failed getting IP address';
                  print(exception);
                }
              })
        });
  
    if (aux == 1) {
      if(_dialog == 0) {
        _showAlert(context, "achei");
        _dialog = 1;
      }
    } else {
      _dialog = 0;
    }
  } // end searchCampus()

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('PUC SPOT MINAS'),
          backgroundColor: Colors.green[700],
        ),
        body: _currentPosition == null
            ? Container(child: Center(child: CircularProgressIndicator()),)
          : GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _currentPosition,
            zoom: 15,
          ),
          zoomGesturesEnabled: true,
          myLocationEnabled: true,
          compassEnabled: true,
          zoomControlsEnabled: false,
        ),
      ),
    );
  }

}
