import 'package:flutter/material.dart';
import 'image_pick.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,          //arkaplan rengi
      appBar: AppBar(
        title: Text('Metin tanıma Uygulaması'),    //uygulama başlığı
      ),
      body: Center(                        //butonları ortalamak için Center
        child: Column(                    //Butonları alt alta yapmak için coloum
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(                     //ana ekrana koyulan resim Container içerisinde
              margin:EdgeInsets.all(23.0),
              height: 400,
              width: double.maxFinite,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.elliptical(10, 20)),
                image: DecorationImage(
                  image: ExactAssetImage("assets/tik.png"),    //koyulan resmin projedeki yolu
                  fit: BoxFit.cover,
                ),
                border: Border.all(             //koyulan resim etrafına kenarlar çizdirme
                  color: Colors.black,
                  width: 5,
                ),
              ),
              child: ClipRRect(),
            ),
            RaisedButton(                     //galeriden resim seçen buton
              child: Text('Select a Text Photo',
                  style: TextStyle(fontSize: 23)),
              onPressed: () {
                Navigator.of(context).push(
                  //diğer sayfaya gitmek navigator.push 
                  MaterialPageRoute(
                    builder: (context) => TextDetectionFromImage(),
                  ),
                );
              },
              shape: new RoundedRectangleBorder(      //buton şekli ayarlama
                  borderRadius: new BorderRadius.circular(30.0)),
              textColor: Colors.lightBlue,
            )
            
          ],
        ),
      ),
    );
  }
}
//ilk ekranın tasarımı ve buton yönlendirmeleri