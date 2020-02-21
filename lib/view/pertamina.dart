import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:katanya/helper/api.dart';

class Pertamina extends StatefulWidget {
  @override
  _PertaminaState createState() => _PertaminaState();
}

class _PertaminaState extends State<Pertamina> {

  List responseJSONPertamina;

  Future<String> ambilDataPertamina() async{
    http.Response response = await http.get(BaseUrl.pertamina);

    setState(() {
      responseJSONPertamina = json.decode(response.body);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    ambilDataPertamina();
  }

  @override
  Widget build(BuildContext context) {
      return Container(
        child: ListView.builder(
          itemCount: responseJSONPertamina == null ? 0 : responseJSONPertamina.length,
          itemBuilder: (context, i) {
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        responseJSONPertamina[i]['wilayah'],
                        style: TextStyle(fontSize: 20.0, color: Colors.blue),
                      ),
                      Text("Pertalite : " + responseJSONPertamina[i]['pertalite']),
                      Text("Pertamax : " + responseJSONPertamina[i]['pertamax']),
                      Text("Pertamax Turbo : " + responseJSONPertamina[i]['pertamax_turbo']),
                      Text("Pertamax Racing : " + responseJSONPertamina[i]['pertamax_racing']),
                      Text("Dexlite : " + responseJSONPertamina[i]['dexlite']),
                      Text("Pertamina Dex : " + responseJSONPertamina[i]['pertamina_dex']),
                      Text("Solar Non Subsidi : " + responseJSONPertamina[i]['solar_nonsubsidi']),
                      Text("Minyak Tanah Non Subsidi : " + responseJSONPertamina[i]['mtanah_nonsubsidi']),
                      Text("Terakhir update : " + responseJSONPertamina[i]['terakhir_updatepertamina']),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
  }
}

class ListPertaminaLess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListPertaminaFul();
  }
}

class ListPertaminaFul extends StatefulWidget {
  @override
  _ListPertaminaFulState createState() => _ListPertaminaFulState();
}

class _ListPertaminaFulState extends State<ListPertaminaFul> {
  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}