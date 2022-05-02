//바꾸는 중이었음.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mask/model/store.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

void main() { //main에서 myapp 시작시키기. 별다를게 없다.
  runApp(
    MyApp()
  );
}

class MyApp extends StatelessWidget { //평범한 Stl위젯. 홈을 MyHomePage라고 지정하는거 빼곤 안건드린듯
 
   @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GetMyHomePage(),
    );
  }
}
 //여기 아래쪽 obs부분도 참고할 것
class GetMyHomepageController extends GetxController { //여기를 채워야 함
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


class GetMyHomePage extends StatelessWidget { //stf -> stl로 변경
  GetMyHomePage({Key key}) : super(key: key); //const 없애고 Key 뒤에 ? 없앰

  @override //UI 부분에 해당하는 위젯.
  Widget build(BuildContext context) {

    //컨트롤러가 원래 여기서 생성이 되어야 하는데 생성이 안되고 있어서 oninit 이 실행이 안되고있음.
    //binding을 걸던가 변수로 만들던가 해야 함.
    Get.putAsync<GetMyHomepageController>(() async => await GetMyHomepageController()); //바인딩 해줌

    return Scaffold(
      appBar: AppBar(
        title: Text('마스크 재고 있는 곳 : ${GetMyHomepageController.stores
            .where((e) { //일정 이하는 표시 안하기 위한것
          return e.remainStat =='plenty' ||
              e.remainStat =='some' ||
              e.remainStat =='few';
        })
            .length}곳'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh),onPressed: GetMyHomepageController.fetch,) //새로고침 버튼 눌렀을때 fetch를 하라고 함,GetMyHomepageController.fetch로 변경
        ],
      ),

      body: Obx(() { //여기 참고할 것, obx랑 builder로 감쌌음.()가 빌더에 해당하는 부분
        return GetMyHomepageController.isLoading.value //GetMyHomepageController.isLoading.value로 변경
         ? loadingWidget() : ListView( //리스트뷰. 리스트 형태로 보여줌. & 로딩 중일때랑 아닐때 분기를 나눠서 표시해야 되기 때문에 ?로 확인
        children: GetMyHomepageController.stores //GetMyHomepageController.stores로 변경
            .where((e) { //일정 이하는 표시 안하기 위한것
        return e.remainStat =='plenty' ||
        e.remainStat =='some' ||
        e.remainStat =='few';
        })
            .map((e){
        return ListTile( //여기가 약국이름(title)&위치(subtitle)&오른쪽(trailing) 리스트로 보여주는 부분.
        title: Text(e.name),
        subtitle: Text(e.addr),
        trailing: _buildRemainStatWidget(e),
        );
        })
        .
        toList
        (
        )
        ,
        );

      }),
    );
  }
  Widget _buildRemainStatWidget(Store store){ //오른쪽 부분에 색깔 입히고, 상태별로 글자 종류바꿔서 띄워주기 위한 위젯
    var remainStat = '판매중지';
    var description = '판매중지';
    var color = Colors.black;
    if(store.remainStat == 'plenty'){
      remainStat = '충분';
      description = '100개 이상';
      color = Colors.green;
    }
    switch(store.remainStat){
      case 'plenty':
        remainStat = '충분';
        description = '100개 이상';
        color = Colors.green;
        break;
      case 'some':
        remainStat = '보통';
        description = '30 ~ 100개';
        color = Colors.yellow;
        break;
      case 'few':
        remainStat = '부족';
        description = '2 ~ 30개';
        color = Colors.red;
        break;
      case 'empty':
        remainStat = '소진임박';
        description = '1개 이하';
        color = Colors.grey;
        break;
      default:
    }

    return Column(
      children: <Widget>[
        Text(remainStat, style: TextStyle(color: color, fontWeight: FontWeight.bold),),
        Text(description, style: TextStyle(color: color),),
      ],
    );
  }

  Widget loadingWidget(){ //로딩 중일때 표시할 위젯
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('정보를 가져오는 중'),
            CircularProgressIndicator(),
          ]
      ),
    );
  }
}