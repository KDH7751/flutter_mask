import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/getmyhomepagecontroller.dart';
import '../model/store.dart';

class GetMyHomePage extends GetView<GetMyHomepageController> { //stf -> stl로 변경
  GetMyHomePage({Key key}) : super(key: key); //const 없애고 Key 뒤에 ? 없앰

  @override //UI 부분에 해당하는 위젯.
  Widget build(BuildContext context) {

    // 없어도 되는 Get.put 부분을 삭제하고, Get.find 부분을 넣는 대신 GetView를 사용해서 위치 특정해줌.

    return Scaffold(
      appBar: AppBar(
        title: Obx(() { //obx로 묶어줘야 카운트가 제대로 됨
          return Text('마스크 재고 있는 곳 : ${storesCut()
              .length}곳');

        }),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh),onPressed: controller.fetch) //새로고침 버튼 눌렀을때 fetch를 하라고 함,controller.fetch로 변경
        ],
      ),

      body: Obx(() { //여기 참고할 것, obx랑 builder로 감쌌음.()가 빌더에 해당하는 부분
        return controller.isLoading.value //Controller.isLoading.value로 변경
            ? loadingWidget() : ListView( //리스트뷰. 리스트 형태로 보여줌. & 로딩 중일때랑 아닐때 분기를 나눠서 표시해야 되기 때문에 ?로 확인
          children: storesCut()
              .map((e){
            return ListTile( //여기가 약국이름(title)&위치(subtitle)&오른쪽(trailing) 리스트로 보여주는 부분.
              title: Text(e.name),
              subtitle: Text(e.addr),
              trailing: _buildRemainStatWidget(e),
            );
          }).toList(),
        );
      }),
    );
  }

  Iterable<Store> storesCut() { //일정 이하는 표시 안하기 위한 것, 2번 사용되서 밖으로 따로 뺐음
    return controller.stores.where((e) { //controller.stores로 변경
          return e.remainStat =='plenty' ||
              e.remainStat =='some' ||
              e.remainStat =='few';
        });
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