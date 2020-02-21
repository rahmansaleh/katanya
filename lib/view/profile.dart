import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:katanya/model/model_profile.dart';

import 'package:katanya/helper/api.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  var loading = false;
  final list = new List<ModelProfile>();

  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatData() async{
    list.clear();
    setState(() {
      loading = true;
    });

    final response = await http.get(BaseUrl.lihatProfile);

    if(response.contentLength == 2){

    } else {
      final data = jsonDecode(response.body);
      data.forEach((api){
        final ab = new ModelProfile(
          api['id'],
          api['status'],
          api['email'],
          api['fullname'],
        );
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
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
                          x.fullname,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(x.id),
                        Text(x.status),
                        Text(x.email),
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