import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lesson_flutter/modal/api.dart';
import 'package:lesson_flutter/modal/produkModel.dart';

class EditProduk extends StatefulWidget {
  final ProdukModel model;
  final VoidCallback reload;
  EditProduk(this.model, this.reload);
  

  @override
  _EditProdukState createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  final _key = new GlobalKey<FormState>();
  String namaProduk, harga,qty;

  TextEditingController txtNama, txtQty, txtHarga;

  setup(){
    txtNama = TextEditingController(text: widget.model.namaProduk);
    txtQty  = TextEditingController(text:  widget.model.qty);
    txtHarga = TextEditingController(text: widget.model.harga);

  }

  check(){
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }else{

    }
  }

  submit() async{
      final response = await http.post(BaseUrl().editProduk, body:{
          "namaProduk" : namaProduk,
          "qty" : qty,
          "harga" : harga,
          "idProduk" : widget.model.id
      });
      final data = jsonDecode(response.body);
      int value = data['value'];
      String pesana = data['messege'];
      if (value == 1) {
        setState(() {
          widget.reload;
         Navigator.pop(context); 
        });
      }else{
        print(pesana);
      }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
     
         body: Form(
        key:  _key,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
          children: <Widget>[
            TextFormField(
              controller: txtNama,
                onSaved: (e)=>namaProduk = e,
                  decoration: InputDecoration(
                    labelText: "Nama Produk"
                  ),
            ),
             TextFormField(
               controller: txtQty,
                onSaved: (e)=>qty = e,
                  decoration: InputDecoration(
                    labelText: "Quantity"
                  ),
            ),
             TextFormField(
               controller: txtQty,
                onSaved: (e)=>harga = e,
                  decoration: InputDecoration(
                    labelText: "Harga"
                  ),
            ),
            MaterialButton(
                onPressed: (){
                    check();
                },
                child: Text("Simpan"),
            )
          ],
        ),
              ),
      ),
    );
  }
}