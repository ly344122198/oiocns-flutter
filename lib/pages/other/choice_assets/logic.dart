import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/event/choice_assets.dart';
import 'package:orginone/util/common_tree_management.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:worker_manager/worker_manager.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'mock.dart';
import 'state.dart';

class ChoiceAssetsController extends BaseController<ChoiceAssetsState> {
  final ChoiceAssetsState state = ChoiceAssetsState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    state.searchController.addListener(() {
      if (state.searchController.text.isNotEmpty) {
        state.showSearchPage.value = true;
        search(state.searchController.text);
      } else {
        state.showSearchPage.value = false;
      }
    });
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();

    state.assetsCategory.addAll(CommonTreeManagement().assetsCategory);
  }

  void search(String str) {
    state.searchList.clear();

    var filter = state.assetsCategory
        .where((element) => (element.name.contains(str)));
    if (filter.isNotEmpty) {
      state.searchList.addAll(filter);
    }
  }

  void selectItem(XDictItem item) {
    state.selectedAsset.value = item;
  }

  void back() {
    EventBusHelper.fire(ChoiceAssets(state.selectedAsset.value));

    Get.back();
  }
}
