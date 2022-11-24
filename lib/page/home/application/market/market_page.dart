import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/api_resp/market_entity.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/market/market_item_widget.dart';
import 'package:orginone/component/text_search.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/controller/market/market_controller.dart';
import 'package:orginone/logic/authority.dart';
import 'package:orginone/controller/message/message_controller.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/widget_util.dart';

class MarketPage extends GetView<MarketController> {
  const MarketPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarTitle: Text("市场", style: AFont.instance.size22Black3),
      appBarCenterTitle: true,
      appBarLeading: WidgetUtil.defaultBackBtn,
      bgColor: UnifiedColors.navigatorBgColor,
      body: _body(),
      appBarActions: _actions,
    );
  }

  /// 按钮
  get _actions => <Widget>[
        IconButton(
          onPressed: () {
            Map<String, dynamic> args = {"func": ApplicationMarketFunc.create};
            Get.toNamed(Routers.marketMaintain, arguments: args);
          },
          icon: const Icon(Icons.create_outlined, color: Colors.black),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add, color: Colors.black),
        ),
      ];

  Widget _body() {
    return Container(
      color: UnifiedColors.navigatorBgColor,
      child: Column(
        children: [
          TextSearch(
            margin: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 20.h,
              bottom: 20.h,
            ),
            searchingCallback: controller.search,
            bgColor: Colors.white,
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                shrinkWrap: true,
                itemCount: controller.getSize(),
                itemBuilder: (context, index) {
                  return controller.mapping(index, _mapping);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapping(MarketEntity market) {
    var messageController = Get.find<MessageController>();
    var orgChatCache = messageController.orgChatCache;
    return MarketItemWidget(
      marketEntity: market,
      isSoft: controller.isSoft(market),
      isUserSpace: auth.isUserSpace(),
      spaceId: auth.spaceId,
      userId: auth.userId,
      belongName: orgChatCache.nameMap[market.belongId] ?? "-",
      transferCallback: (MarketEntity market) => Get.toNamed(
        Routers.merchandise,
        arguments: market.id,
      ),
      deleteCallback: (MarketEntity market) => controller.remove(market),
    );
  }
}
