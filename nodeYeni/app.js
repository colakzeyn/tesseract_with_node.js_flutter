//import edilen modüller
var express = require('express');   //işimizi kolaylaştırecak node.js çerçevesi
var bodyParser = require('body-parser');     //json dosyalarımızı istediğimiz formata dönüştürmek için
var app = express();
var fs = require('fs');      //dosya işlemleri için
app.use(bodyParser.json());

const tesseract = require("node-tesseract-ocr");     //bu eklentiyi kullanacağız

const config = {
    lang: "eng",
    oem: 1,
    psm: 3,
};


app.post("/", function (req, res) {       //gelen post requesti yakalama
    
    var base64 = req.body["image"];      //requestin içindeki json dosyasından base64 stringini alma
    var gelentext = req.body["text"];   //requestle gelen texti alma
    
    var ReadableData = require("stream").Readable     //okunabilir stream oluşturma
    const imageBufferData = Buffer.from(base64, "base64")    //base64 stringini buffera atma
    var streamObj = new ReadableData()      //okunabilir stream objesi oluşturmaa
    streamObj.push(imageBufferData)    // streame bufferdakileri atma
    streamObj.push(null)
    streamObj.pipe(fs.createWriteStream("testImage.jpg"));    //pipe bufferdaki bilgileri parça parça alır
                                                            //fs ile streamdekileri resim haline getirir
    var resulttext;

    tesseract.recognize("testImage.jpg", config)       //dizinde oluşturduğumuz resmi tesseract eklentisine gönder
        .then(text => {
            
            console.log("Result:", text);
            resulttext = text;
 
            console.log("gelentext");
            console.log(gelentext);
            console.log(gelentext.length) 
            console.log("resulttext");
            console.log(resulttext);
            console.log(resulttext.length)

            if (gelentext === resulttext.substring(0,gelentext.length)) { 
                res.send({ "durum": "successful" });  //requestten gelen text ile eklentiden dönen text                        
                console.log("başarılıı")                        //eşit ise success response'u gönder
            } else {
                res.send({ "durum": "unsuccessful" });  //requestten gelen text ile eklentiden dönen text
                console.log("başarısız");                    //eşit değil ise ise unsuccess response'u gönder
            }
            console.log(gelentext === resulttext.substring(0,gelentext.length));
            console.log(resulttext.substring(0,gelentext.length));
        })
        .catch(error => {           //hata olursa ekrana bas
            console.log(error.message)
        });


})

app.listen(8002, function () {    //8000. portu dinle
    console.log("started");
})


