
import 'dart:ffi';
import 'dart:io';


import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'package:video_player/video_player.dart';

class FilePickk extends StatefulWidget{
  FilePickk({Key? key}):super(key: key);
  @override
  _FilePick createState(){
    return _FilePick();}
}
class _FilePick extends State<FilePickk>{
  VideoPlayerController?_videoPlayerController;
  var _filepurl,ext;
  var _openpath= 'Unknown';

  Future<File?> filePick() async {
    FilePickerResult result = (await FilePicker.platform.pickFiles())!;

    /*if(result==null) return null;
        File file = File(result.files.first.path!);
       PlatformFile fil = result.files.first;
        _filepurl=file;

        ext=fil.extension;
        _openpath=_filepurl.toString();
       // _videoPlayerController=file as VideoPlayerController;
        print(file);
        print('>>>>>>$_filepurl \n $_videoPlayerController  \n $_openpath');
        print(fil.name);
        print(fil.bytes);
        print(fil.size);
        print(fil.extension);
        print(fil.path);

        _videoPlayerController = VideoPlayerController.file(file)..initialize().then((_) {
          setState(() { });
          _videoPlayerController!.play();
        });*/
        return File(result.files.first.path!);


  }



  Future<void> openFile({required String url , String ?fileName}) async {
    final name= fileName ?? url.split('/').last;
    //final file = await dowanloadFile(url,name);
    final file=await filePick();

    if(file==null) return;
    print('Path:${file.path}');
    OpenFile.open(file.path);

    setState(() {

    });
  }

  Future<File?> dowanloadFile(String url,String name) async{
    final appStorage= await getApplicationDocumentsDirectory();
      final file=File('${appStorage.path}/$name');
      try {
        final response = await Dio().get(
          url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0,
          ),
        );
        final raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(response.data);
        await raf.close();
        return file;

      }catch(e){
        return null;
      }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick file'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(onTap: (){openFile(url: 'url', fileName: '',);},
            child: Text('click to pick file'),),
            Container(
              child:_filepurl!=null? Text('$_filepurl'):Text('hello'),
            ),
            Container(
              child: ext=='jpg'?Image.file(_filepurl):ext=='mp4'?_videoPlayerController!.value.isInitialized
                  ? AspectRatio(
                aspectRatio: _videoPlayerController!.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController!),
              )
                  : Container():ext=='jpg'||ext=='mp4'?Text('please pic the genuine data'):InkWell(onTap: (){
                    openFile(url: 'url', );
              },
              child: Container(
                height: 15,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  borderRadius: BorderRadius.circular(20)

              ),
              child: Text('Click To View File')),
              )
            ),

          ],
        ),
      ),
    );
  }
}
