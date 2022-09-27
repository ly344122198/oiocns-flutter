
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/component/click_item_type1.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/widget_util.dart';
import 'mine_card_controller.dart';

class MineCardPage extends GetView<MineCardController> {
  const MineCardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MineCardController>(
        init: MineCardController(),
        builder: (item) => UnifiedScaffold(
              appBarTitle: Text("我的名片", style: text16),
              appBarLeading: WidgetUtil.defaultBackBtn,
              bgColor: const Color.fromRGBO(240, 240, 240, 1),
              body: Container(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  margin: EdgeInsets.fromLTRB(0, 20.h, 0, 0),
                  child: ListView(
                    children: [
                      //名片层
                      Container(
                          height: 195.h,
                          width: 220.w,
                          margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 50.w),
                          child: Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                  image:
                                      AssetImage('images/person-card-bg.png')),
                            ),
                          )),
                      //二维码层
                      Container(
                        margin: EdgeInsets.fromLTRB(50.w, 0, 50.w, 50.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(20.w),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color:
                                          const Color.fromRGBO(0, 0, 0, 1))),
                              child: Container(
                                constraints: const BoxConstraints(
                                    minHeight: 150, minWidth: 150),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color: const Color.fromRGBO(
                                            255, 255, 0, 1))),
                              ),
                            )
                          ],
                        ),
                      ),
                      //功能层
                      Container(
                        margin: EdgeInsets.fromLTRB(50.w, 0, 50.w, 50.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ClickItemType1(
                              bgColor: const Color.fromRGBO(255, 235, 221, 1),
                              height: 50.w,
                              width: 50.w,
                              padding: const EdgeInsets.all(0),
                              text: '保存到相册',
                              icon: const Icon(Icons.image,color: Color.fromRGBO(238, 95, 0, 1),size: 32),
                            ),
                            ClickItemType1(
                              bgColor: const Color.fromRGBO(239, 251, 254, 1),
                              height: 50.w,
                              width: 50.w,
                              padding: const EdgeInsets.all(0),
                              text: '奥集能分享',
                              icon: const Icon(Icons.electric_bolt,color: Color.fromRGBO(75, 214, 249, 1),size: 32),
                            ),
                            ClickItemType1(
                              bgColor: const Color.fromRGBO(238, 255, 238, 1),
                              height: 50.w,
                              width: 50.w,
                              padding: EdgeInsets.all(10.w),
                              text: '微信分享',
                              icon: const Icon(Icons.message,color: Color.fromRGBO(102, 255, 102, 1),size: 28),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ));
  }
}