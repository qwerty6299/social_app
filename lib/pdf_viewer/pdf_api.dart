import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http ;
import 'package:path_provider/path_provider.dart';

class ApiServiceProvider {
 static Future<String>  loadpdf(String message)async{
    var response =  await http.get(Uri.parse(message));
    var dir = await getTemporaryDirectory();
    File file=new File(dir.path+"/data.pdf");
    file.writeAsBytes(response.bodyBytes,flush: true);
    return file.path;

  }
}