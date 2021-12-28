import 'dart:convert';
import 'package:flutter/material.dart';

import 'User.dart';
import 'package:http/http.dart' as http;

import 'dashboard.dart';
import 'register.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  User user = User("", "");
  String url = "http://192.168.56.1:8080/login";
  bool login = false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  void _validateFields() {
    if (_formKey.currentState!.validate()) {
      save();
      // scaffoldKey.currentState!.showSnackBar(validSnackBar);
      //ScaffoldMessenger(child: scaffold());
    } else {
      print("form  not accepted");
    }
  }

  Future save() async {
    var res = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
          <String, String>{"email": user.email, "password": user.password}),
    );
    print("entered save method");
    print("email" + user.email + " password: " + user.password);
    print(res.body);

    if (res.body != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text("Login"),
          centerTitle: true,
        ),
        body: Center(
          child: Card(
            elevation: 8.0,
            child: Container(
              height: 350,
              width: 300,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          String pattern =
                              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                              r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                              r"{0,253}[a-zA-Z0-9])?)*$";
                          RegExp regex = RegExp(pattern);

                          if (!regex.hasMatch(value.toString()))
                            return 'Enter a valid email address';
                          else {
                            user.setEmail(value.toString());
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            hintText: "Your email...",
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "Please enter strong password:(";
                          }
                          user.setPassword(value.toString());
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: "Your password...",
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      InkWell(
                        onTap: _validateFields,
                        child: Container(
                          height: 50.0,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: const Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => register(),
                              ));
                        },
                        child: Container(
                          height: 50.0,
                          child: const Center(
                            child: Text(
                              "dont have an account?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/////////////////////////////////////////
///
///
///
