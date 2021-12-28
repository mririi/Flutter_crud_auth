import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tp7_crud_authentication/models/etudiants.dart';
import 'package:tp7_crud_authentication/models/formation.dart';

import 'scol_list_dialogue_etudiant_copy.dart';

class formationWidget extends StatefulWidget {
  const formationWidget({Key? key}) : super(key: key);

  @override
  _formationWidgetState createState() => _formationWidgetState();
}

class _formationWidgetState extends State<formationWidget> {
  String url = "http://172.19.224.1:8080/formations";
  List formations = [];
  StreamController _streamController = StreamController();
  ScolListDialog1? dialog = ScolListDialog1();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
  }

  void getList() async {
    var res = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    formations = List<formation>.from(json
        .decode(res.body)['_embedded']['formations']
        .map((x) => formation.fromJson(x)));
    await Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _streamController.add(formations);
      });
    });
  }

  delete(int id) async {
    var res = await http.delete(
      Uri.parse(url + '/' + id.toString()),
      headers: {
        'Content-Type': 'application/json',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    getList();
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => dialog!
                    .buildDialog1(context, new formation(00, "", 0), true),
              ).then((value) => getList());
            },
            child: Icon(Icons.add)),
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Center(
                  child: Container(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: StreamBuilder(
                          stream: _streamController.stream,
                          builder: (context, AsyncSnapshot snapshot) {
                            return ListView.builder(
                              itemCount: formations.length,
                              itemBuilder: (context, index) {
                                var use = snapshot.data;
                                return Card(
                                    margin: EdgeInsets.all(10),
                                    child: Dismissible(
                                      key: UniqueKey(),
                                      onDismissed: (direction) {
                                        setState(() {
                                          delete(use[index].id);

                                          formations.removeAt(index);
                                          _streamController.add(formations);
                                        });
                                      },
                                      child: ListTile(
                                          onTap: () {
                                            /*Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => ),
                  );*/
                                          },
                                          title: Text(use[index].nom +
                                              "\n duree = " +
                                              use[index].dure.toString()),
                                          leading:
                                              Text(use[index].id.toString()),
                                          trailing: IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              print(index.toString());
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          dialog!.buildDialog1(
                                                              context,
                                                              new formation(
                                                                use[index].id,
                                                                use[index].nom,
                                                                use[index].dure,
                                                              ),
                                                              false));
                                            },
                                          )),
                                    ));
                              },
                            );
                          }),
                    ),
                  ),
                ))));
  }
}
