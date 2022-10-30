
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;

class upload_image_Api extends StatefulWidget {
  const upload_image_Api({Key? key}) : super(key: key);

  @override
  State<upload_image_Api> createState() => _upload_image_ApiState();
}

class _upload_image_ApiState extends State<upload_image_Api> {

  File? image ;
  final _picker= ImagePicker();
  bool showSpinner= false;
  
  Future getImage() async{
    final pickedFile= await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if(pickedFile!=null){
     image = File(pickedFile.path);
     setState(() {
       
     });
    }else{
      print("File not Selected");
    }
  }
  Future<void> uploadImage() async {
    setState(() {
      showSpinner = true;
    });
    var stream = new http.ByteStream(image!.openRead());
    stream.cast();

    var length= await image!.length();

    var uri= Uri.parse('https://fakestoreapi.com/products');

    var request = new http.MultipartRequest('POST', uri );
    request.fields['title']= 'Static title';
    var multiPort= new http.MultipartFile(
        'image', stream, length);
     request.files.add(multiPort);
     var response= await request.send();
     if(response.statusCode==200){
       setState(() {
         showSpinner = false;
       });
       Text('Uploaded');
       print('Image uploaded');

     }else{
       setState(() {
         showSpinner = false;
       });
       print('Failed');
     }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: SafeArea(
          child: Scaffold(
            appBar: AppBar(title: Text("Upload image api"),),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    getImage();
                  },
                  child: Container(
                   child: image == null ? Center(child: Text("Pick Image"),)
                       :
                       Container(
                         child: Center(
                           child: Image.file(
                             File(image!.path).absolute,
                             height: 300,
                             width: 300,
                             fit: BoxFit.fill,

                           ),
                         ),
                       )
                  ),
                ),
                SizedBox(height: 100,),
                GestureDetector(
                  onTap: (){
                    uploadImage();
                  },
                  child: Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Center(
                      child: Text('Tap to Upload'),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
