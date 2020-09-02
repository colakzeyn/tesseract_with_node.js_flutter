import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TextDetectionFromImage extends StatefulWidget {
  @override
  _TextDetectionFromImageState createState() => _TextDetectionFromImageState();
}

class _TextDetectionFromImageState extends State<TextDetectionFromImage> {
  File _image;
  bool _loading = false;
  String _text;
  var _result;

  @override
  void initState() {
    super.initState();
    {
      setState(() {
        _loading = false;
      });
    }
  }

  selectFromImagePicker() async {    //galeriden resim seçen fonksiyon
    //galeriden resim seçme
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _image = image;
    });
  }

  convertImage() async {
    final bytes = _image.readAsBytesSync();   // resmi byte şeklinde oku
    String img64 = base64Encode(bytes);   //byte ları base64 stringi haline getir
    return img64;
  }

  void onChanged(String val) {
    print(val);
    setState(() {
      _text = val;     //TextField her değiştiğinde yazılanı sakla
    });
  }

  Future<http.Response> postRequest() async {
    String string64 = await convertImage();       //resmi base64'e çeviren fonksiyona gönderme

    var url = 'http://10.0.2.2:8002/';   //emülatörün bilgisayar localhostuna bağlanması için

    Map data = {'image': string64, 'text': _text};  // resmi ve texti map ile birleştirme
    var body = json.encode(data);     // mapi json haline getirme

    var response = await http.post(url,     //ayarlanan url ile json dosyasını gönderme
        headers: {"Content-Type": "application/json"}, body: body);
    print("${response.statusCode}");
    print("${response.body}");
    var map = json.decode(response.body) as Map<String, dynamic>;
    setState(() {
      _result = map["durum"];     //dönen response'taki cevabı result değişkeninde saklama
    });

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Okuduğunu doğrula'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.image),
          tooltip: "Galeriden Metin Resmi Seç",
          onPressed: selectFromImagePicker,
        ),
        body: Center(
          child: SingleChildScrollView(   //sayfayı yukarı aşağı kayabilir hale getiren
            child: Column(                    //verilerin alt alta olmasını sağlayan
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_loading)
                  Container(
                    alignment: Alignment.center,
                    child:
                        CircularProgressIndicator(), //ekranda yuvarlak yükleniyor işareti veriyor
                  ),
                if (_loading == false &&
                    _image ==
                        null) //image null ise ekrana resim seçilmedi yazısı yazdırma

                  Text(
                    "No image has been selected",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                if (_loading == false && _image != null)
                  Image.file(
                    // iamge seçildiyse ekranda gösterme
                    _image,
                    height: 300,
                    width: 300,
                  ),
                if (_loading == false && _image != null)
                  TextField(
                    onChanged: (String value) {    //textfieldde yazılan yazıyı saklayan 
                      onChanged(value);
                    },
                    autocorrect: false,
                    decoration:
                        new InputDecoration(labelText: "Okuduğunu yaz"),
                  ),
                if (_loading == false && _image != null)
                  RaisedButton(
                    child: new Text(" Gönder "),      //request mesajı gönderen buton
                    onPressed: () {
                      postRequest();     //tıklandığında requesti gönder
                    },
                  ),
                if (_result != null) Text(_result),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
  }
}
