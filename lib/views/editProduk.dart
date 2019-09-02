import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'
as http;
import 'package:intl/intl.dart';
import 'package:lesson_flutter/custom/datePicker.dart';
import 'package:lesson_flutter/modal/api.dart';
import 'package:lesson_flutter/modal/produkModel.dart';

class EditProduk extends StatefulWidget {
  final ProdukModel model;
  final VoidCallback reload;
  EditProduk(this.model, this.reload);


  @override _EditProdukState createState() => _EditProdukState();
}

class _EditProdukState extends State < EditProduk > {
  final _key = new GlobalKey < FormState > ();
  String namaProduk,
  harga,
  qty;

  TextEditingController txtNama,
  txtQty,
  txtHarga;
  String tglDate;
  var formatTgl = new DateFormat('yyyy-MM-dd');

  setup() {
    tglDate = widget.model.expDate;
    txtNama = TextEditingController(text: widget.model.namaProduk);
    txtQty = TextEditingController(text: widget.model.qty);
    txtHarga = TextEditingController(text: widget.model.harga);

  }

  check() {
    final form = _key.currentState;

    if (form.validate()) {
      form.save();
      submit();
    } else {}
  }

  submit() async {
    final response = await http.post(BaseUrl().editProduk, body: {
        "namaProduk": namaProduk,
        "qty": qty,
        "harga": harga,
        "idProduk": widget.model.id,
        "expDate" : "$tglDate" 
      }

    );
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesana = data['messege'];

    if (value == 1) {
      setState(() {
          widget.reload;
          Navigator.pop(context);
        }

      );
    } else {
      print(pesana);
    }

  }


  String piligTanggal,
  labelText;

  DateTime tgl = new DateTime.now();

  final TextStyle valueStyle = TextStyle(fontSize: 16.0);
  Future < Null > _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: tgl,
      firstDate: DateTime(1992),
      lastDate: DateTime(2099)
    );
    if (picked != null && picked != tgl) {
      setState(() {
        tgl = picked;
        tglDate = formatTgl.format(tgl);
      });
    } else {

    }
  }


  @override void initState() {
    // TODO: implement initState
    super.initState();
    setup();
  }

  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),

      body: Form(key: _key,
        child: Padding(padding: const EdgeInsets.all(16.0),
          child: ListView(children: < Widget > [TextFormField(controller: txtNama,
              onSaved: (e) => namaProduk = e,
              decoration: InputDecoration(labelText: "Nama Produk"),
            ),
            TextFormField(controller: txtQty,
              onSaved: (e) => qty = e,
              decoration: InputDecoration(labelText: "Quantity"),
            ),
            TextFormField(controller: txtHarga,
              onSaved: (e) => harga = e,
              decoration: InputDecoration(labelText: "Harga"

              ),
            ),
            DateDropDown(
                labelText:  labelText,
                valueText: tglDate,
                valueStyle: valueStyle,
                onPressed: (){
                  _selectedDate(context);
                },
            ),
            MaterialButton(onPressed: () {
                check();
              }

              ,
              child: Text("Simpan"),
            )
          ], ), ),
      ),
    );
  }
}