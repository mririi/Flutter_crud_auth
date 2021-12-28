import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tp7_crud_authentication/models/classe.dart';
import 'package:tp7_crud_authentication/models/etudiants.dart';
import 'package:tp7_crud_authentication/models/formation.dart';

class ScolListDialogc {
  final txtNomEtud = TextEditingController();
  final txtPreEtud = TextEditingController();
  final txtNdate = TextEditingController();
  final txtNClass = TextEditingController();
  Widget buildDialogc(BuildContext context, classe list, bool isNew) {
    // dbuse helper =   context.read<dbuse>();
    if (!isNew) {
      txtNomEtud.text = list.nomClass.toString();
      txtPreEtud.text = list.nbreEtud.toString();
      // txtNClass.text = list.codClass.toString();
    }
    return AlertDialog(
        title: Text((isNew) ? 'Classe list' : 'Edit Classe list'),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        content: SingleChildScrollView(
          child: Column(children: <Widget>[
            TextField(
                controller: txtNomEtud,
                decoration: InputDecoration(hintText: 'Nom de Classe')),
            TextField(
              controller: txtPreEtud,
              decoration: InputDecoration(hintText: 'Nombre de etudiant'),
            ),
            RaisedButton(
              child: Text('Save classe'),
              onPressed: () {
                list.nomClass = txtNomEtud.text;
                list.nbreEtud = int.parse(txtPreEtud.text);
                var text = (isNew) ? 'classe list' : 'Edit classe list';
                if (text == "Edit classe list")
                  list.update();
                else
                  list.add();
                Navigator.pop(context);
              },
            ),
          ]),
        ));
  }
}
