import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart'as http;
import 'package:intl/intl.dart';
import 'package:lesson_flutter/custom/curency.dart';
import 'package:lesson_flutter/custom/datePicker.dart';
// import 'package:lesson_flutter/custom/datePicker.dart';
import 'package:lesson_flutter/modal/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart'as path;


class TambahProduk extends StatefulWidget {
  final VoidCallback reload;
  TambahProduk(this.reload);
  @override _TambahProdukState createState()=>_TambahProdukState();
}

class _TambahProdukState extends State<TambahProduk> {
  String namaProduk,
  qty,
  harga,
  idUsers;
  final _key=new GlobalKey<FormState>();
  File _imageFile;

  getPref() async {
    SharedPreferences preferences=await SharedPreferences.getInstance();

    setState(() {
        idUsers=preferences.getString("id");
      }

    );
  }

  _pilihGalery() async {
    var image=await ImagePicker.pickImage(source: ImageSource.gallery,
      maxHeight: 1920.0,
      maxWidth: 1800.0);

    setState(() {
        _imageFile=image;
      }

    );
  }

  _pilihCamera()async {
    var image=await ImagePicker.pickImage(source: ImageSource.camera,
      maxHeight: 1920.0,
      maxWidth: 1800.0);

    setState(() {
        _imageFile=image;
      }

    );
  }

  check() {
    final form=_key.currentState;

    if (form.validate()) {
      form.save();
      submit();
    }
  }

  submit() async {
    try {
      var stream=http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      var length=await _imageFile.length();
      var uri=Uri.parse(BaseUrl().tambahProduk);
      var request=http.MultipartRequest("POST", uri);
      request.fields['namaProduk']=namaProduk;
      request.fields['qty']=qty;
      request.fields['harga']=harga.replaceAll(",", '');
      request.fields['idUsers']=idUsers;
      request.fields['expDate']="$tgl";
      
      request.files.add(http.MultipartFile("image", stream, length,
          filename: path.basename(_imageFile.path)));
    var response = await request.send();
    if (response.statusCode > 2) {
      print("image upload");
      setState(() {
       widget.reload; 
       Navigator.pop(context);
      });
    } else {
      print("image failed");
    }

    }

    catch (e) {
      debugPrint("Error" +e);
    }
  }

  String piligTanggal, labelText;

  DateTime tgl = new DateTime.now();
   var formatTgl = new DateFormat('yyyy-MM-dd');

  final TextStyle valueStyle = TextStyle(fontSize:  16.0);
  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context:  context,
      initialDate: tgl,
      firstDate: DateTime(1992),
      lastDate: DateTime(2099)
    );
    if (picked !=null && picked !=tgl) {
      setState(() {
       tgl = picked; 
       piligTanggal = formatTgl.format(tgl);
      });
    }else{

    }
  }

  @override void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override Widget build(BuildContext context) {
    var placeholder=Container(width: double.infinity,
      height: 150.0,
      child: Image.asset('./img/placeholder.jpg'),
    );

    return Scaffold(appBar: AppBar(),
      body: Form(key: _key,
        child: Padding(padding: const EdgeInsets.all(16.0),
          child: ListView(children: <Widget>[ Container(width: double.infinity,
              height: 150.0,
              child: InkWell(onTap: () {
                  _pilihCamera();
                }

                ,
                child: _imageFile==null ? placeholder : Image.file(_imageFile,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            TextFormField(onSaved: (e)=>namaProduk=e,
              decoration: InputDecoration(labelText: "Nama Produk"
              ),
            ),
            TextFormField(onSaved: (e)=>qty=e,
              decoration: InputDecoration(labelText: "Quantity"
              ),
            ),
            TextFormField(inputFormatters: [ WhitelistingTextInputFormatter.digitsOnly,
              CurencyFormat()],
              onSaved: (e)=>harga=e,
              decoration: InputDecoration(labelText: "Harga"
              ),
            ),
            DateDropDown(
                labelText:  labelText,
                valueText: formatTgl.format(tgl),
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
            )],
          ),
        ),
      ),
    );
  }
}