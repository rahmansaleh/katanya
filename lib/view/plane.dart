import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:katanya/model/model_plane.dart';

import 'package:katanya/helper/api.dart';

class Plane extends StatefulWidget {
  @override
  _PlaneState createState() => _PlaneState();
}

class _PlaneState extends State<Plane> {

  var loading = false;
  final list = new List<ModelPlane>();

  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatData() async{
    list.clear();
    setState(() {
      loading = true;
    });

    final response = await http.get(BaseUrl.lihatPesawat);

    if(response.contentLength == 2){

    } else {
      final data = jsonDecode(response.body);
      data.forEach((api){
        final ab = new ModelPlane(
            api['id'],
            api['icao'],
            api['ident'],
            api['squawk'],
            api['latitude'],
            api['longitude'],
            api['altitude'],
            api['speed'],
            api['heading'],
            api['uat']
        );
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  dialogDelete(String id){
    showDialog(
        context: context,
        builder: (context){
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  "Apakah kamu ingin menghapus data ini?",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Text("Tidak"),
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                  ],
                )
              ],
            ),
          );
        }
    );
  }

  @override
  void initState(){
    super.initState();
    _lihatData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _lihatData,
        key: _refresh,
        child: loading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i){
            final x = list[i];
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          x.icao,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(x.ident),
                        Text(x.squawk),
                        Text(x.latitude),
                        Text(x.longitude),
                        Text(x.altitude),
                        Text(x.speed),
                        Text(x.heading),
                        Text(x.uat),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}