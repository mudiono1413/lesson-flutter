import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lesson_flutter/modal/api.dart';
import 'package:lesson_flutter/modal/produkModel.dart';
import 'package:lesson_flutter/views/editProduk.dart';
import 'package:lesson_flutter/views/tambahProduk.dart';
import 'package:http/http.dart'
as http;

class Product extends StatefulWidget {

  @override _ProductState createState()=>_ProductState();
}

class _ProductState extends State < Product> {
  var loading=false;
  final list=new List < ProdukModel>();
  final GlobalKey < RefreshIndicatorState>_refresh=GlobalKey < RefreshIndicatorState>();

  Future < void>_lihatData() async {
    list.clear();

    setState(() {
        loading=true;
      }

    );
    final response=await http.get(BaseUrl().lihatproduk);

    if (response.contentLength==2) {}

    else {
      final data=jsonDecode(response.body);

      data.forEach((api) {

          final ab=new ProdukModel(api['id'],
            api['namaProduk'],
            api['qty'],
            api['harga'],
            api['createdDate'],
            api['idUsers'],
            api['nama']);
          list.add(ab);
        }

      );

      setState(() {
          loading=false;
        }

      );
    }
  }

  _dialoddelete(String id) {

    showDialog(context: context,
      builder: (context) {
        return Dialog(child: ListView(padding: EdgeInsets.all(16.0),
            shrinkWrap: true,
            children: <Widget>[ Text("Are you sure want to delete data ?",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
            SizedBox(height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[ 
              InkWell(
                onTap: (){
                  _delete(id);

                },
                child: Text("Yes")),
              SizedBox(
                  width: 16.0,
              ),
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                } ,
                child: Text("No")
                )
              ],
            ),
            ],
          ),
        );
      }

    );
  }

  _delete(String id) async {
    final response=await http.post(BaseUrl().deleteProduk, body: {
        "idProduk": id
      }

    );
    final data=jsonDecode(response.body);
    int value=data['value'];
    String pesan=data['messege'];

    if (value==1) {
      setState(() {
          _lihatData();
          Navigator.pop(context);
        }

      );
    }

    else {
      print(pesan);
    }
  }

  @override void initState() {
    // TODO: implement initState
    super.initState();
    _lihatData();
  }

  @override Widget build(BuildContext context) {
    return Scaffold(floatingActionButton: FloatingActionButton(onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> TambahProduk(_lihatData)));
        }

        ,
        child: Icon(Icons.add),

      ),
      body: RefreshIndicator(onRefresh: _lihatData,
        key: _refresh,
        child: loading ? Center(child: CircularProgressIndicator()) : ListView.builder(itemCount: list.length,
          itemBuilder: (context, i) {
            final x=list[i];
            return Padding(padding: const EdgeInsets.all(10.0),
              child: Container(child: Row(children: < Widget > [ Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: < Widget > [ Text(x.namaProduk,
                        style: TextStyle(fontSize: 18.0,
                          fontWeight: FontWeight.bold), ),
                      Text(x.qty),
                      Text(x.harga),
                      Text(x.nama),
                      Text(x.createdDate),

                      ],
                    ),
                  ),
                  IconButton(onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> EditProduk(x, _lihatData)));
                    }

                    ,
                    icon: Icon(Icons.edit),
                  ),
                  IconButton(onPressed: () {
                      // _delete(x.id);
                      _dialoddelete(x.id);
                    }

                    ,
                    icon: Icon(Icons.delete),
                  )],
                ),
              ),
            );
          }

          ,
        ),
      ));
  }
}