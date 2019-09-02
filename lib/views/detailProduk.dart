import 'package:flutter/material.dart';
import 'package:lesson_flutter/modal/produkModel.dart';

class DetailProduk extends StatefulWidget {
  final ProdukModel model;
  DetailProduk(this.model);
  @override
  _DetailProdukState createState() => _DetailProdukState();
}

class _DetailProdukState extends State < DetailProduk > {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, boolinnerBoxIsScrolled) {
          return <Widget > [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: widget.model.id,
                  child: Image.network('http://192.168.3.96/lesson_flutter/upload/' + widget.model.image,
                    fit: BoxFit.cover, ),
                ),
              ),
            )
          ];
        },
        body:  Stack(
            children: < Widget > [
              Positioned(
                top: 30.0,
                left: 10.0,
                right: 10.0,
                child: Column(
                  children: < Widget > [
                    Text(widget.model.namaProduk),
                    Text(widget.model.harga),
                  ],
                ),
              ),
              Positioned(
                bottom: 10.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Material(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10.0),
                    child: MaterialButton(
                      onPressed: () {},
                      child: Text("Add Cart",
                        style: TextStyle(color: Colors.white), ),
                    )
                  ),
                ),
              )
            ],
          ),
      ),
    );
  }
}