import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:subnetting_calculator/view/detail_result.dart';
import 'package:http/http.dart' as http;


class CalculatorForm extends StatefulWidget {
  @override
  _CalculatorFormState createState() => _CalculatorFormState();
}

class Quotes {
  String q;
  String a;
  String h;

  Quotes({
    required this.q,
    required this.a,
    required this.h,
  });

  factory Quotes.fromJson(Map<String, dynamic> json) {
    return Quotes(
      q: json['q'],
      a: json['a'],
      h: json['h'],
    );
  }
}

class _CalculatorFormState extends State<CalculatorForm> {
  final ipAddressTextBoxController = TextEditingController();
  final subnetTextBoxController = TextEditingController();
  String ipClass = "";

  String randomQuotesAPI = "https://zenquotes.io/api/random";
  String quote = "";
  String author = "";

  String defaultDropdownValue = 'Select a Subnet'; // Default Drop Down Item.
  String selectedSubnet = 'Select a Subnet'; // To show Selected Item in Text.
  List<DropdownMenuItem<String>> subnetList = [];
  List<String> subnetListAll = [
    "Select a Subnet",
    "128.0.0.0/1",
    "192.0.0.0/2",
    "224.0.0.0/3",
    "240.0.0.0/4",
    "248.0.0.0/5",
    "252.0.0.0/6",
    "254.0.0.0/7",
    "255.0.0.0/8",
    "255.128.0.0/9",
    "255.192.0.0/10",
    "255.224.0.0/11",
    "255.240.0.0/12",
    "255.248.0.0/13",
    "255.252.0.0/14",
    "255.254.0.0/15",
    "255.255.0.0/16",
    "255.255.128.0/17",
    "255.255.192.0/18",
    "255.255.224.0/19",
    "255.255.248.0/21",
    "255.255.252.0/22",
    "255.255.254.0/23",
    "255.255.255.0/24",
    "255.255.255.128/25",
    "255.255.255.192/26",
    "255.255.255.224/27",
    "255.255.255.240/28",
    "255.255.255.248/29",
    "255.255.255.252/30",
    "255.255.255.254/31",
    "255.255.255.255/32"
  ];
  List<String> subnetListA = [
    "Select a Subnet",
    "255.0.0.0/8",
    "255.128.0.0/9",
    "255.192.0.0/10",
    "255.224.0.0/11",
    "255.240.0.0/12",
    "255.248.0.0/13",
    "255.252.0.0/14",
    "255.254.0.0/15",
    "255.255.0.0/16",
    "255.255.128.0/17",
    "255.255.192.0/18",
    "255.255.224.0/19",
    "255.255.248.0/21",
    "255.255.252.0/22",
    "255.255.254.0/23",
    "255.255.255.0/24",
    "255.255.255.128/25",
    "255.255.255.192/26",
    "255.255.255.224/27",
    "255.255.255.240/28",
    "255.255.255.248/29",
    "255.255.255.252/30",
    "255.255.255.254/31",
    "255.255.255.255/32"
  ];
  List<String> subnetListB = [
    "Select a Subnet",
    "255.255.0.0/16",
    "255.255.128.0/17",
    "255.255.192.0/18",
    "255.255.224.0/19",
    "255.255.240.0/20",
    "255.255.248.0/21",
    "255.255.252.0/22",
    "255.255.254.0/23",
    "255.255.255.0/24",
    "255.255.255.128/25",
    "255.255.255.192/26",
    "255.255.255.224/27",
    "255.255.255.240/28",
    "255.255.255.248/29",
    "255.255.255.252/30",
    "255.255.255.254/31",
    "255.255.255.255/32"
  ];
  List<String> subnetListC = [
    "Select a Subnet",
    "255.255.255.0/24",
    "255.255.255.128/25",
    "255.255.255.192/26",
    "255.255.255.224/27",
    "255.255.255.240/28",
    "255.255.255.248/29",
    "255.255.255.252/30",
    "255.255.255.254/31",
    "255.255.255.255/32"
  ];

  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => _getQuotes());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  _getQuotes() async {
    final response = await http.get(Uri.parse(this.randomQuotesAPI));
    final quotes = jsonDecode(response.body)[0];
    setState(() {
      this.author = quotes['a'];
      this.quote = quotes['q'];
    });
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = (MediaQuery.of(context).size.width * 0.9);

    return Scaffold(
      appBar: AppBar(
        title: Text("IPv4 Subnetting Calculator"),
        automaticallyImplyLeading: false
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: (maxWidth * 0.02), vertical: 10),
            child: Row(
              children: [_textBoxIPAddress(), _boxIPClass()],
            ),
          ),
          _dropdownSubnet(),
          _buttonCalculate(),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            child: Wrap(
              alignment: WrapAlignment.center,
              direction: Axis.horizontal,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 7),
                  child: Text(
                    '"' + this.quote + '"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Text(
                  this.author != "" ? "( " + this.author + " )" : "",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                )
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Mobile Programming",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "Universitas Bina Sarana Informatika",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  fetchAlbum() async {
    final response = await http.get(Uri.parse(this.randomQuotesAPI));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
      return response.body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  showAlertDialog(BuildContext context, title, message) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Close",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title,
          style: TextStyle(
              color: Colors.red, fontWeight: FontWeight.bold, fontSize: 30)),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _validateIPAddress(value) {
    List<String> arrOctet = value.split(".");
    if (arrOctet.length != 4) {
      // Make sure the ip address consist of 4 parts
      return false;
    }
    for (int i = 0; i < arrOctet.length; i++) {
      if (arrOctet[i].length > 3) {
        // To check if every octet have valid length of number
        return false;
      }
      if(int.parse(arrOctet[i]) > 255 || int.parse(arrOctet[i]) < 1) {
        return false;
      }
    }
    return true;
  }

  _boxIPClass() {
    double maxWidth = (MediaQuery.of(context).size.width);
    return Container(
      width: (maxWidth * 0.16),
      height: 60,
      child: Center(
          child: Text(this.ipClass,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black
      )),
    );
  }

  _textBoxIPAddress() {
    double maxWidth = (MediaQuery.of(context).size.width);
    return Container(
      width: (maxWidth * 0.8),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: "IP Address"),
        controller: ipAddressTextBoxController,
        onChanged: (value) {
          setState(() {
            String ip = value;
            String final_class = "";
            if (value.length <= 3) {
              ip = value;
            } else {
              ip = value.split(".")[0];
            }
            if (int.parse(ip) <= 127) {
              final_class = "A";
              this.defaultDropdownValue = "Select a Subnet";
              this.subnetList = getDropdownItems(this.subnetListA);
            } else if (int.parse(ip) <= 191) {
              final_class = "B";
              this.defaultDropdownValue = "Select a Subnet";
              this.subnetList = getDropdownItems(this.subnetListB);
            } else {
              final_class = "C";
              this.defaultDropdownValue = "Select a Subnet";
              this.subnetList = getDropdownItems(this.subnetListC);
            }
            this.ipClass = final_class;
          });
        },
      ),
    );
  }

  _dropdownSubnet() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: DropdownButton<String>(
          value: defaultDropdownValue,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.black, fontSize: 18),
          onChanged: (String? data) {
            setState(() {
              defaultDropdownValue = data!;
            });
          },
          items: (this.subnetList.length > 0
              ? this.subnetList
              : getDropdownItems(this.subnetListAll))),
    );
  }

  List<DropdownMenuItem<String>> getDropdownItems(List<String> list) {
    double maxWidth = (MediaQuery.of(context).size.width);
    return list.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Container(width: (maxWidth * 0.85), child: Text(value)),
      );
    }).toList();
  }

  void getSelectedDropdownSubnet() {
    setState(() {
      selectedSubnet = defaultDropdownValue;
    });
  }

  _buttonCalculate() {
    double maxWidth = (MediaQuery.of(context).size.width);
    getSelectedDropdownSubnet();
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: RaisedButton(
          color: Colors.blueAccent,
          child: Container(
            width: maxWidth,
            child: Center(
                child: Text("C A L C U L A T E",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold, color: Colors.white))),
          ),
          onPressed: () {
            String ipAddress = ipAddressTextBoxController.text;
            String subnet = selectedSubnet;

            if (!_validateIPAddress(ipAddressTextBoxController.text)) {
              showAlertDialog(context, "Error!", "Invalid IP Address!");
            } else if (subnet == "Select a Subnet") {
              showAlertDialog(
                  context, "Error!", "Please select a valid subnet!");
            } else {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) =>
                      DetailResult(ipAddress: ipAddress, subnet: subnet)));
            }
          },
        ));
  }
}
