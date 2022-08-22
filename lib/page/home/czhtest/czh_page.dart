import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/config/custom_colors.dart';
import 'package:orginone/page/home/czhtest/czh_controller.dart';

class CzhPage extends GetView<CzhController> {
  const CzhPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GFAppBar(
          leading: GFIconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
            type: GFButtonType.transparent,
          ),
          title: const Text("会话设置"),
          // actions: <Widget>[
          //   GFIconButton(icon: const Icon(Icons.favorite), onPressed: () {
          //     Get.toNamed(Routers.czh);
          //   })
          // ],
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                    color: CustomColors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(2))),
                margin: const EdgeInsets.all(10),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(6),
                child: const Text(
                  '江',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
            Container(
                margin: const EdgeInsets.all(10),
                child: const Text("江", style: TextStyle(fontSize: 30))),
          ]),
          const Divider(
            height: 0,
          ),
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    margin: const EdgeInsets.all(10),
                    child:
                        const Text("组成员 2人", style: TextStyle(fontSize: 16))),
                Container(
                  constraints: const BoxConstraints(
                      maxHeight: 40,
                      minHeight: 40,
                      minWidth: 50,
                      maxWidth: 150),
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                      controller: controller.searchGroupText,
                      decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.search),
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFDCDFE6)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF409EFF)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                          ),
                          hintText: "搜索成员")),
                )
              ]),
          Container(
            height: 70,
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 20,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: 50,
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FadeInImage.assetNetwork(
                          placeholder: 'images/person-empty.png',
                          image: 'qqqqqq',
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage('images/person-empty.png'),
                                      fit: BoxFit.cover)),
                            );
                          },
                          width: 50,
                          height: 50,
                        ),
                        const Text("测试人员长字符测试",
                            style: TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  );
                }),
          ),
          const Divider(
            height: 0,
          ),
          Obx(() => Row(
                children: [
                  Radio(
                    value: 1,
                    groupValue: controller.textField1.value,
                    onChanged: (a) {
                      controller.test1(a);
                    },
                  ),
                  const Text("设置群消息免打扰")
                ],
              )),
          Obx(() => Row(
                children: [
                  Radio(
                    value: 2,
                    groupValue: controller.textField2.value,
                    onChanged: (a) {
                      controller.test1(a);
                    },
                  ),
                  const Text("置顶该群")
                ],
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0,10,0,0),
                child: GFButton(
                  color: const Color.fromRGBO(255, 0, 0, 1),
                  onPressed: () async {},
                  text: "清空聊天记录",
                  blockButton: true,
                ),
              )
            ],
          )
        ]));
  }
}