import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'CameraRoute.dart';
import 'dart:io';

class EmployeeLogin extends StatefulWidget {
  const EmployeeLogin({
    super.key,
  });

  @override
  State<EmployeeLogin> createState() => _EmployeeLoginState();
}

class _EmployeeLoginState extends State<EmployeeLogin> {
  String _username = "0";
  String _password = "0";

  final _formkey = GlobalKey<FormState>();

  //USERNAME

  void login() {
    print("Username: $_username");
  }

  void usernameHandler(String value) {
    setState(() {
      _username = value;
    });
  }

//PASSWORD
  void loginPassword() {
    print("Password: $_password");
  }

  void passwordHandler(String valuePassword) {
    setState(() {
      _password = valuePassword;
    });
  }

  //TextEditingController mailController = TextEditingController();
  //TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  Future signIn(String mail, String password) async {
    Map data = {'mail': mail, 'password': password};

    var response = await http.post(
      Uri.parse('https://localhost:7112/api/Login/employee-login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'mail': mail, 'password': password}),
    );

    var jsonData;
    log('data: $response');
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      setState(() {
        _isLoading = false;
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => CameraRoute()),
            (Route<dynamic> route) => false);
      });
    } else {
      print(response.body);
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    //double width = MediaQuery.of(context).size.width;

    return Scaffold(
      //backgroundColor: Colors.purple[900],
      body: SizedBox(
        height: height,

        //width: width,

        child: Form(
          key: _formkey,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    'https://s3.amazonaws.com/adroitart/images/4289/original/4013-1.jpg?1648214345'),
                                fit: BoxFit.cover)),
                        height: height,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 350),
                        child: Container(
                            child: const Center(
                                child: FittedBox(
                          child: Text(
                            "W o r l d\n    o f\n",
                            style: TextStyle(
                                fontSize: 50,
                                color: Color.fromARGB(255, 201, 169, 65),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Pacifico-Regular'),
                          ),
                        ))),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 200),
                        child: Container(
                            child: const Center(
                                child: FittedBox(
                          child: Text(
                            "c   a   r   p   e   t   s",
                            // "carpets",
                            style: TextStyle(
                                fontSize: 50,
                                // letterSpacing: 25.0,
                                fontStyle: FontStyle.italic,
                                color: Color.fromARGB(255, 200, 156, 46),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Pacifico-Regular'),
                          ),
                        ))),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    height: height,
                    //color: Color.fromARGB(223, 243, 238, 224),
                    color: Color.fromARGB(255, 233, 212, 193),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.170),
                        RichText(
                            text: const TextSpan(children: [
                          TextSpan(
                            text: 'Welcome to ',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'World of Carpets',
                            style: TextStyle(
                              fontSize: 25,
                              fontStyle: FontStyle.italic,
                              color: Color.fromARGB(255, 203, 158, 10),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ])),
                        SizedBox(height: height * 0.1),
                        TextFormField(
                          //controller: mailController,
                          keyboardType: TextInputType.emailAddress,

                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 203, 158, 10),
                                  width: 2,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            hintText: 'Enter your e-mail',
                            labelText: 'E-mail',
                            prefixIcon: const Icon(Icons.person,
                                color: Color.fromARGB(255, 203, 158, 10)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            labelStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 205, 194, 194),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onChanged: usernameHandler,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your e-mail';
                            }
                            if (value.length > 20) {
                              return 'The e-mail must have a maximum of 20 characters.';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: height * 0.04),
                        TextFormField(
                          //controller: passwordController,

                          validator: (value_password) {
                            if (value_password == null ||
                                value_password.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value_password.length > 20) {
                              return 'The Password must have a maximum of 20 characters.';
                            }
                            return null;
                          },

                          keyboardType: TextInputType.visiblePassword,

                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 203, 158, 10),
                                  width: 2,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            hintText: 'Enter your password',
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock,
                                color: Color.fromARGB(255, 203, 158, 10)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            labelStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 205, 194, 194),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _password = value;
                            });
                          },
                        ),
                        SizedBox(height: height * 0.05),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 203, 158, 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              signIn(_username, _password).then((value) {
                                if (value != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CameraRoute(),
                                    ),
                                  );
                                } else if (value == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Incorrect username or password'),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Incorrect username or password'),
                                    ),
                                  );
                                }
                              });
                            }
                          },
                          child: const Text(
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 232, 229, 233),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// final http.Response response = await http.post(
//     'https://localhost:7112/api/Customers',
//     headers: <String, String>{
//       'Authorization': '000000-000000-000000-000000',
//       'accept': 'text/plain',
//       'Content-Type': 'application/json'
//     },
//     body: jsonEncode(<String, String>{
//        "customer_Id": "" ,
//   "name": "string",
//   "surname": "string",
//   "mail": "string",
//   "number": "0"
//     }),
// );
