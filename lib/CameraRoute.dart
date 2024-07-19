import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CameraRoute extends StatefulWidget {
  CameraRoute({Key? key}) : super(key: key);

  @override
  State<CameraRoute> createState() => _CameraRouteState();
}

class _CameraRouteState extends State<CameraRoute> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  bool _isPictureTaken = false;
  XFile? image;
  double cmPerPixelAsDouble = 0.0;
  double priceAsDouble = 0.0;
  double totalPrice = 0.0;
  List<double> rowData = [];
  String width = "-";
  String height = "-";
  String area = "-";

//UPLOAD IMAGE
//we can upload image from camera or from gallery based on parameter
  Future uploadImage(BuildContext context, ImageSource media) async {
    var img = await _picker.pickImage(source: media);

    if (img == null) return;

    String? fileName = img.path.split('.').last;
    if (fileName != 'jpg') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a JPG file.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      image = img;
      _isPictureTaken = true;
    });
  }

//UPLOAD IMAGE TO API
  imagetoAPI(String title, String cmPerPixel, String price) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://localhost:7112/api/Measurements/' +
          cmPerPixel +
          '/' +
          price),
    );
    request.fields['Name'] = "file";
    request.fields['cmPerPixel'] = cmPerPixel;
    request.fields['price'] = price;

    request.files.add(http.MultipartFile.fromBytes(
        'file', File(image!.path).readAsBytesSync(),
        filename: image!.path));
    var res = await request.send();
    final respStr = await res.stream.bytesToString();
    debugPrint(respStr);

    var carpetInfo = List.from(respStr
        .substring(1, respStr.length - 2)
        .replaceAll(RegExp(r'"'), '')
        .split(','));

    if (res.statusCode == 200) {
      setState(() {
        image = XFile(carpetInfo[2]);
        cmPerPixelAsDouble = double.parse(cmPerPixel);
        width = carpetInfo[0];
        height = carpetInfo[1];
        area = (double.parse(carpetInfo[0]) * double.parse(carpetInfo[1]))
            .toString();
        priceAsDouble = double.parse(price);
        totalPrice = priceAsDouble * double.parse(area);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: [
          Expanded(
            child: Container(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: NetworkImage(
                          'https://images.rawpixel.com/image_800/czNmcy1wcml2YXRlL3Jhd3BpeGVsX2ltYWdlcy93ZWJzaXRlX2NvbnRlbnQvbHIvdHAyMjAtMDEta3pwaGhybXQuanBn.jpg'),
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    )),
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(160, 100, 450, 400),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shadowColor: Color.fromARGB(255, 30, 28, 32),
                            backgroundColor: Color.fromARGB(220, 164, 120, 59),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 60, vertical: 20),
                            textStyle: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            uploadImage(context, ImageSource.gallery);
                          },
                          child: const Text(
                            "Take Picture",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(130, 200, 30, 0),
                    child: Row(children: [
                      Text(
                        'cmPerPixel: ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 161, 108, 22),
                        ),
                      ),
                      Container(
                        width: 150,
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10)
                          ],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 161, 108, 22),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
                            hintText: 'Enter cmPerPixel..',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Color.fromARGB(255, 63, 62, 68),
                            ),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (double.tryParse(value) == null) {
                              return;
                            }
                            setState(() {
                              cmPerPixelAsDouble = double.parse(value);
                            });
                          },
                        ),
                      ),
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(170, 300, 30, 0),
                    child: Row(children: [
                      Text(
                        'Price: ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 161, 108, 22),
                        ),
                      ),
                      Container(
                        width: 150,
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10)
                          ],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 161, 108, 22),
                                  width: 2,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            //border: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 117, 32, 114))),

                            hintText: 'Enter TL/cm²..',

                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Color.fromARGB(255, 63, 62, 68),
                            ),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (double.tryParse(value) == null) {
                              return;
                            }
                            setState(() {
                              priceAsDouble = double.parse(value);
                            });
                          },
                        ),
                      )
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(200, 400, 30, 0),
                    child: Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 184, 162, 19),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            textStyle: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: _isPictureTaken
                              ? () {
                                  imagetoAPI(
                                      "resim",
                                      cmPerPixelAsDouble.toString(),
                                      priceAsDouble.toString());
                                }
                              : null,
                          child: const Text(
                            "Upload",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

//çekilen resmi ekranda gösterme
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(750, 50, 30, 0),
                    child: image == null
                        ? Container()
                        : Container(
                            width: 300,
                            height: 300,
                            margin: const EdgeInsets.all(20),
                            color: const Color.fromARGB(0, 121, 15, 15),
                            child: Image.file(
                              File(image!.path),
                              fit: BoxFit.contain,
                            ),
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(700, 400, 30, 0),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DataTable(columns: const <DataColumn>[
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Width',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 110, 103, 18),
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Height',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 110, 103, 18),
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Total Area',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 110, 103, 18),
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Total Price',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 110, 103, 18),
                                ),
                              ),
                            ),
                          ),
                        ], rows: <DataRow>[
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Text(width + ' cm')),
                              DataCell(Text(height + ' cm')),
                              DataCell(Text(area + ' cm²')),
                              DataCell(Text(totalPrice.toString() + ' TL')),
                            ],
                          ),
                        ])),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}