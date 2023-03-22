import 'package:get/get.dart';
import 'package:orginone/pages/other/work/work_start/network.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/loading_dialog.dart';

import '../../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class CreateWorkController extends BaseController<CreateWorkState> {
  final CreateWorkState state = CreateWorkState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
  }

  Future init() async{
    for (var element in state.node.operations!) {
      await element.getOperationItems();
    }
    state.show.value = true;
  }

  Future<void> submit() async{
    for (var element in state.node.operations!) {
      for (var element in element.operationItems) {
        if (element.fields?.required??false) {
          if(element.fields!.defaultData.value == null){
            return ToastUtils.showMsg(msg: element.fields!.hint!);
          }
        }
      }
    }
    if(state.selectedThings.isEmpty){
      return ToastUtils.showMsg(msg:"请至少选择一条实体");
    }
    Map<String,dynamic> data = {};

    for (var element in state.node.operations!) {
      for (var element in element.operationItems) {
          if(element.fields?.defaultData.value!=null){
             if(element.fields?.type == "select"){
               if(!element.fields!.code!.contains("DATE")){
                 data[element.attrId!] = element.fields!.defaultData.value?.values?.first.toString() ?? "";
               }else{
                 data[element.attrId!] = element.fields?.defaultData.value;
               }
             }else{
               data[element.attrId!] = element.fields?.defaultData.value;
             }
          }
      }
    }

    WorkStartNetWork.createInstance(state.define, data, state.selectedThings.map((element) => element.id!).toList());
  }

  void jumpEntity() {
    Get.toNamed(Routers.choiceThing, arguments: {
      "selectedThings":
          state.selectedThings.map((element) => element.id).toList()
    })?.then((value) {
      state.selectedThings.value = value;
    });
  }

  void delete(int index) {
    state.selectedThings.removeAt(index);
  }
}
