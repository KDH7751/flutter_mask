import 'dart:convert';

import 'package:flutter_mask/model/store.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetMyHomepageController extends GetxController {
  static var stores = List<Store>().obs; //리스트 만들기, 리스트에도 obs 붙여서 관리할 수 있음, 리스트 불러올 떄는 value로 안불러옴. static 붙여서 밖에서도 호출 가능하게 함
  static var isLoading = true.obs; //처음에 앱 실행시 로딩중인 상태로 만들기 위해 우선 true로, static 붙여서 밖에서도 호출 가능하게 함

  static Future fetch() async { //static 붙였음
    //async - await용
    //fetch를 본격적으로 하기 전에 로딩중으로 만들기 위해서 true로 둔다.
    isLoading.value = true;

    var url = Uri.parse(
        'https://gist.githubusercontent.com/junsuk5/bb7485d5f70974deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json');
    //주소 받아오는 곳
    var response = await http.get(url); //async - await용

    final jsonResult = jsonDecode(response.body);

    final jsonStores = jsonResult['stores']; // 리스트에 stores에 해당하는 부분만 불러오기 위해서 만듬

    stores.clear(); //밖으로 뺌
    jsonStores.forEach((e){
      stores.add(Store.fromJson(e));
    });

    isLoading.value = false; //isloading을 setstate 밖으로 뺌
    print('fetch완료'); //fetch가 제대로 잘 됬는지 알수없으니까 로그 띄워주는 용도
  }

  @override //위쪽 setstate로 상태 변경시 initstate에서 fetch를 불러와줌, initstate에서 oninit으로 변경함, 위치가 어디에 있던 처음 시작할때 fetch를 불러와주는 역할인 것 같음
  void onInit() {
    super.onInit();
    fetch();
  }

}