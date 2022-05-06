import 'package:flutter/material.dart';
import 'package:flutter_mask/Controller/getmyhomepagecontroller.dart';
import 'package:get/get.dart';
import 'View/getmyhomepage.dart';

void main() { //main runApp을 runApp(GetMaterialApp())으로 변경함
  runApp(
    GetMaterialApp(home: GetMyHomePage())
  );
}


class BindingController implements Bindings{ //binding을 클래스 형태로 만들어서 밖에 빼줌
  @override
  void dependencies(){
    Get.putAsync<GetMyHomepageController>(() async => await GetMyHomepageController());
  }
}