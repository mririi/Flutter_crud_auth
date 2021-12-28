import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class classe {
  int? codClass;
  String? nomClass;
  int? nbreEtud;
  String url = "http://192.168.56.1:8080/classes";
  classe(codClass, nomClass, nbreEtud) {
    this.codClass = codClass;
    this.nomClass = nomClass;
    this.nbreEtud = nbreEtud;
  }

  factory classe.fromJson(dynamic json) {
    print("id :" + json['codClass'].toString());

    return classe(json['codClass'], json['nomClass'], json['nbreEtud']);
  }

  delete(int id) async {
    var res = await http.delete(
      Uri.parse(url + '/' + id.toString()),
      headers: {
        'Content-Type': 'application/json',
      },
    );
  }

  update() async {
    var res = await http.put(Uri.parse(url + '/' + this.codClass.toString()),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String?, dynamic>{
          'nomClass': this.nomClass,
          'nbreEtud': this.nbreEtud,
        }));
  }

  add() async {
    var res = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String?, dynamic>{
          'nomClass': this.nomClass,
          'nbreEtud': this.nbreEtud,
        }));
    print(res.body);
  }
}
