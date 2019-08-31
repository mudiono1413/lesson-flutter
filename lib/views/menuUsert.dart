import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lesson_flutter/modal/api.dart';
import 'package:lesson_flutter/modal/produkModel.dart';
import 'package:http/http.dart'
as http;

class MenuUsers extends StatefulWidget {
  final VoidCallback signOut;
  MenuUsers(this.signOut);
  @override
  _MenuUsersState createState() => _MenuUsersState();
}

class _MenuUsersState extends State < MenuUsers > {
  final money = NumberFormat("#,###", "en_US");

  var loading = false;
  final list = new List < ProdukModel > ();
  final GlobalKey < RefreshIndicatorState > _refresh = GlobalKey < RefreshIndicatorState > ();

  Future < void > _lihatData() async {
    list.clear();

    setState(() {
        loading = true;
      }

    );
    final response = await http.get(BaseUrl().lihatproduk);

    if (response.contentLength == 2) {} else {
      final data = jsonDecode(response.body);

      data.forEach((api) {

          final ab = new ProdukModel(
            api['id'],
            api['namaProduk'],
            api['qty'],
            api['harga'],
            api['createdDate'],
            api['idUsers'],
            api['image'],
            api['nama']);
          list.add(ab);
        }

      );

      setState(() {
          loading = false;
        }

      );
    }


  }
  @override void initState() {
    // TODO: implement initState
    super.initState();
    _lihatData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Produk"),
        actions: < Widget > [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.shopping_cart),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                widget.signOut();
              });
            },
            icon: Icon(Icons.lock_open),
          ),
          
        ],
      ),
      body: Container(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: orientation == Orientation.portrait ? 2 : 3
              ),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final x = list[i];
                return Card(
                  child: Column(
                    children: < Widget > [
                      Expanded(
                        child: Image.network(
                          'http://192.168.1.121/lesson_flutter/upload/' + x.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(x.namaProduk, textAlign: TextAlign.center, ),
                      Text("Rp." + money.format(int.parse(x.harga)),
                        style: TextStyle(
                          color: Colors.orange
                        ), ),
                      SizedBox(
                        height: 10.0,
                      )
                    ],
                  ),
                );
              },
            );
          },
        )
      ),
    );
  }
}