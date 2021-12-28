import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tp7_crud_authentication/models/etudiants.dart';
import 'package:tp7_crud_authentication/models/classe.dart';

import 'scol_list_dialogue_classe.dart';

class classeWidget extends StatefulWidget {
  const classeWidget({Key? key}) : super(key: key);

  @override
  _classeWidgetState createState() => _classeWidgetState();
}

class _classeWidgetState extends State<classeWidget> {
  String url = "http://172.19.224.1:8080/classes";
  List classes = [];
  StreamController _streamController = StreamController();
  ScolListDialogc? dialog = ScolListDialogc();

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

    classes = List<classe>.from(json
        .decode(res.body)['_embedded']['classes']
        .map((x) => classe.fromJson(x)));
    await Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _streamController.add(classes);
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
                builder: (BuildContext context) =>
                    dialog!.buildDialogc(context, new classe(00, "", 0), true),
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
                              itemCount: classes.length,
                              itemBuilder: (context, index) {
                                var use = snapshot.data;
                                return Card(
                                    margin: EdgeInsets.all(10),
                                    child: Dismissible(
                                      key: UniqueKey(),
                                      onDismissed: (direction) {
                                        setState(() {
                                          delete(use[index].codClass);

                                          classes.removeAt(index);
                                          _streamController.add(classes);
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
                                          title: Text(use[index].nomClass +
                                              "\n NbreEtud = " +
                                              use[index].nbreEtud.toString()),
                                          leading: Text(
                                              use[index].codClass.toString()),
                                          trailing: IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              print(index.toString());
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      dialog!.buildDialogc(
                                                          context,
                                                          new classe(
                                                            use[index].codClass,
                                                            use[index].nomClass,
                                                            use[index].nbreEtud,
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
