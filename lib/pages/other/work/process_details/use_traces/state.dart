

import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/pages/other/work/process_details/logic.dart';
import 'package:orginone/pages/other/work/to_do/state.dart';

class UseTracesState extends BaseGetState{

  ProcessDetailsController processDetailsController = Get.find<ProcessDetailsController>();

  XFlowInstance? get flowInstance => processDetailsController.state.flowInstance.value;

  WorkEnum? get type =>processDetailsController.state.type;

}