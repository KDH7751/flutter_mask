import 'package:flutter/material.dart';
import 'package:flutter_mask/Controller/getmyhomepagecontroller.dart';
import 'package:get/get.dart';
import 'View/getmyhomepage.dart';


void main() {
  runApp( //runApp을 runApp(GetMaterialApp())으로 변경함
    GetMaterialApp(
      initialBinding: BindingsBuilder((){ // initialbinding 사용. 일반 binding과는 다르게 시작시 1회 실행해주는 기능이 있음.
        Get.put<GetMyHomepageController>(GetMyHomepageController()); // 실제로 binding해줄 컨트롤러 선언해주는 부분. 찾을 때는 Get.find를 사용한다.
      }),
      home: GetMyHomePage(),
    )
  );
}

//기존에는 컨트롤러가 있던 없던 상관없이 static을 붙여놔서 find가 없어도 여기저기서 불러오는 게 작동하기는 했음
//정상적인 방법으로는 Get.put으로 묶어주고, Get.Find로 찾는 방법
//기존에 사용하던 controller를 밖으로 따로 뺴주는 방법과 현재 사용중인 내부에 바로 묶어주는 방식은 취향 차이
//찾을 때 Get.find를 선언해주는 거조차 귀찮기 떄문에 statelesss를 대신해서 GetView<클래스이름>식으로 묶어버리기도 한다.