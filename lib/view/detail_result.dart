import 'package:flutter/material.dart';
import 'dart:math';

class DetailResult extends StatefulWidget {
  String ipAddress = "";
  String subnet = "";
  String ipClass = "";

  DetailResult({ required this.ipAddress, required this.subnet, required this.ipClass });

  @override
  _DetailResult createState() => _DetailResult();
}

class _DetailResult extends State<DetailResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Subnetting Calculator")),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                child: Text("Details",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Card(
                child: ListTile(
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 6, 0, 3),
                        child: Row(children: [
                          Text("IP Address : "),
                          Text(widget.ipAddress,
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ]),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                        child: Row(children: [
                          Text("Subnet Mask : "),
                          Text((widget.subnet.split("/"))[0],
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ]),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                        child: Row(children: [
                          Text("IP Class : "),
                          Text(widget.ipClass,
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ]),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                        child: Row(children: [
                          Text("Network Subnet : "),
                          Text(
                              _getSubnetAddress(widget.ipAddress,
                                  widget.subnet.split("/")[0]),
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ]),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                        child: Row(children: [
                          Text("Broadcast Address : "),
                          Text(
                              _getListOfSubnets(
                                widget.ipAddress,
                                (widget.subnet.split("/"))[0],
                                (widget.subnet.split("/"))[1])[2][0],
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ]),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                        child: Row(children: [
                          Text("Host Range : "),
                          Text(
                              _getListOfSubnets(
                                widget.ipAddress,
                                (widget.subnet.split("/"))[0],
                                (widget.subnet.split("/"))[1])[1][0],
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ]),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                        child: Row(children: [
                          Text("Total Number of Host : "),
                          Text(
                              _getNumberOfHost((widget.subnet.split("/"))[0]).toString(),
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ]),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                        child: Row(children: [
                          Text("Total Usable Host : "),
                          Text(
                              _getUsableHost((widget.subnet.split("/"))[0]).toString(),
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ]),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                        child: Row(children: [
                          Text("Wildcard Mask : "),
                          Text(_getWildcardMask((widget.subnet.split("/"))[0]),
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ]),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                        child: Row(children: [
                          Text("CIDR (Classless Inter-Domain Routing) : "),
                          Text((widget.subnet.split("/"))[1],
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 15, 5, 0),
                child: Text("Possible Networks",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _getListOfSubnetsWithComponent(_getListOfSubnets(
                    widget.ipAddress,
                    (widget.subnet.split("/"))[0],
                    (widget.subnet.split("/"))[1])),
              ),
            ],
          ),
        ));
  }

  _getListOfSubnetsWithComponent(_subnets) {
    List<Card> subnets = [];
    for (int i = 0; i < _subnets[0].length; i++) {
      subnets.add(Card(
          child: ListTile(
              subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 6, 0, 3),
            child: Row(children: [
              Text("Network Address : "),
              Text(_subnets[0][i],
                  style: TextStyle(fontWeight: FontWeight.bold))
            ]),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 6, 0, 3),
            child: Row(children: [
              Text("Host Range : "),
              Text(_subnets[1][i],
                  style: TextStyle(fontWeight: FontWeight.bold))
            ]),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 6, 0, 3),
            child: Row(children: [
              Text("Broadcast Address : "),
              Text(_subnets[2][i],
                  style: TextStyle(fontWeight: FontWeight.bold))
            ]),
          ),
        ],
      ))));
    }
    return subnets;
  }

  _getUsableHost(_subnetMask) {
    return _getNumberOfHost(_subnetMask) - 2;
  }

  _getNumberOfHost(_subnetMask) {
    int octet = 255;
    List<String> arrSubnetMask = _subnetMask.split(".");
    for (int i = 0; i < arrSubnetMask.length; i++) {
      int _octet = int.parse(arrSubnetMask[i]);
      if (_octet > 0 && _octet < 255) {
        octet = _octet;
      }
    }
    int totalHost = 256 - octet;
    return totalHost;
  }

  _getListOfSubnets(_ipAddress, _subnetMask, _cidr) {
    int octet = 255;
    List<List<String>> listOfSubnets = [[], [], []];
    List<String> arrSubnetMask = _subnetMask.split(".");
    for (int i = 0; i < arrSubnetMask.length; i++) {
      int _octet = int.parse(arrSubnetMask[i]);
      if (_octet > 0 && _octet < 255) {
        octet = _octet;
      }
    }
    int octedIpAddress = int.parse(_ipAddress.split(".")[3]);
    int totalHost = 256 - octet;
    int totalSubnet = ((256 - octedIpAddress) / totalHost).floor();
    if (totalSubnet > 0) {
      String _ip3Block = ((_ipAddress.split(".")).sublist(0, 3)).join(".");
      for (int i = 0; i < totalSubnet; i++) {
        String networkAddress = _ip3Block + "." + (octedIpAddress).toString();
        String hostAddressRange = (_ip3Block + "." + (octedIpAddress+1).toString() + " - " + (_ip3Block + "." + (octedIpAddress + totalHost - 2).toString()));
        String broadcastAddress = _ip3Block + "." + (octedIpAddress + totalHost - 1).toString();
        if (octedIpAddress < 256) {
          listOfSubnets[0].add(networkAddress);
          listOfSubnets[1].add(hostAddressRange);
          listOfSubnets[2].add(broadcastAddress);
          octedIpAddress += totalHost;
        }
      }
    }
    return listOfSubnets;
  }

  _getWildcardMask(_subnetMask) {
    String wildcartMask = "";
    List<String> arrSubnetMask = _subnetMask.split(".");
    for (int i = 0; i < arrSubnetMask.length; i++) {
      if (wildcartMask != "") {
        wildcartMask += ".";
      }
      wildcartMask += ((int.parse(arrSubnetMask[i]) - 255).abs()).toString();
    }
    return wildcartMask;
  }

  _getSubnetAddress(_ipAddress, _subnetMask) {
    String subnetAddress = "";
    String ipAddressBinary = _convertAddressIntoBinary(_ipAddress);
    String subnetMaskBinary = _convertAddressIntoBinary(_subnetMask);

    // DO BITWISE
    for (int i = 0; i < ipAddressBinary.length; i++) {
      if (ipAddressBinary[i] == ".") {
        subnetAddress += ".";
        continue;
      }
      subnetAddress +=
          (int.parse(ipAddressBinary[i]) & int.parse(subnetMaskBinary[i]))
              .toString();
    }

    return _convertBinaryIntoAddress(subnetAddress);
  }

  _convertBinaryIntoAddress(_binary) {
    String _address = "";
    List<String> arrBinary = _binary.split(".");
    for (int i = 0; i < arrBinary.length; i++) {
      if (_address != "") {
        _address += ".";
      }
      _address += _binaryToDecimal(arrBinary[i]);
    }
    return _address;
  }

  _convertAddressIntoBinary(_ipAddress) {
    String _binary = "";
    List<String> arrAddress = _ipAddress.split(".");
    for (int i = 0; i < arrAddress.length; i++) {
      if (_binary != "") {
        _binary += ".";
      }
      _binary += _decimalToBinary(int.parse(arrAddress[i]));
    }
    return _binary;
  }

  _binaryToDecimal(_binary) {
    int binary = int.parse(_binary);
    int decimal = 0, i = 0;
    while (binary != 0) {
      int dec = binary % 10;
      int x = pow(2, i) as int;
      decimal = decimal + dec * x;
      binary = (binary / 10).floor();
      i += 1;
    }
    return decimal.toString();
  }

  _decimalToBinary(_decimal) {
    String _binary = "";
    List<int> listDecimal = [0, 0, 0, 0, 0, 0, 0, 0];
    int i = 0;

    while (_decimal > 0) {
      listDecimal[i] = _decimal % 2;
      _decimal = (_decimal / 2).floor();
      i++;
    }

    for (int j = 7; j >= 0; j--) {
      _binary += listDecimal[j].toString();
    }

    return _binary;
  }
}
