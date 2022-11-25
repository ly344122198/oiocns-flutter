import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:orginone/api/hub/any_store.dart';
import 'package:orginone/api/kernelapi.dart';
import 'package:orginone/api/model.dart';

import 'package:orginone/api_resp/api_resp.dart';
import 'package:orginone/api_resp/message_detail.dart';
import 'package:orginone/api_resp/message_target.dart';
import 'package:orginone/api_resp/page_resp.dart';
import 'package:orginone/api_resp/target.dart';
import 'package:orginone/component/message/group_item_widget.dart';
import 'package:orginone/component/message/message_item_widget.dart';
import 'package:orginone/controller/message/message_controller.dart';
import 'package:orginone/enumeration/message_type.dart';
import 'package:orginone/enumeration/target_type.dart';
import 'package:orginone/logic/authority.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/encryption_util.dart';

import 'i_chat.dart';

class BaseChatGroup implements IChatGroup<GroupItemWidget> {
  final String _spaceId;
  final String _spaceName;
  final RxBool _isOpened;
  final RxList<IChat> _chats;

  BaseChatGroup({
    required String spaceId,
    required String spaceName,
    bool isOpened = true,
    List<IChat> chats = const [],
  })  : _spaceId = spaceId,
        _spaceName = spaceName,
        _isOpened = isOpened.obs,
        _chats = chats.obs;

  @override
  String get spaceId => _spaceId;

  @override
  String get spaceName => _spaceName;

  @override
  bool get isOpened => _isOpened.value;

  @override
  List<IChat> get chats => _chats.toList();

  @override
  GroupItemWidget mapping() {
    return GroupItemWidget(this);
  }

  @override
  openOrNot(bool isOpened) {
    _isOpened.value = isOpened;
  }
}

IChat createChat(String spaceId, String spaceName, MessageTarget target) {
  if (target.typeName == TargetType.person.name) {
    return PersonChat(spaceId: spaceId, spaceName: spaceName, target: target);
  } else {
    return CohortChat(spaceId: spaceId, spaceName: spaceName, target: target);
  }
}

class BaseChat implements IChat<MessageItemWidget> {
  final String _chatId;
  final String _spaceId;
  final String _spaceName;
  final RxInt _noReadCount;
  final RxInt _personCount;
  final MessageTarget _target;
  final RxList<MessageDetail> _messages;
  final RxList<Target> _persons;
  final Rx<MessageDetail?> _lastMessage;

  BaseChat({
    required String spaceId,
    required String spaceName,
    required MessageTarget target,
    int noReadCount = 0,
    int personCount = 0,
    List<MessageDetail> messages = const [],
    List<Target> persons = const [],
    MessageDetail? lastMessage,
  })  : _chatId = target.id,
        _spaceId = spaceId,
        _spaceName = spaceName,
        _noReadCount = noReadCount.obs,
        _personCount = personCount.obs,
        _target = target,
        _messages = messages.obs,
        _persons = persons.obs,
        _lastMessage = lastMessage.obs;

  @override
  String get chatId => _chatId;

  @override
  int get noReadCount => _noReadCount.value;

  @override
  int get personCount => _personCount.value;

  @override
  MessageDetail? get lastMessage => _lastMessage.value;

  @override
  List<MessageDetail> get messages => _messages.toList();

  @override
  List<Target> get persons => _persons.toList();

  @override
  String get spaceId => _spaceId;

  @override
  String get spaceName => _spaceName;

  @override
  MessageTarget get target => _target;

  @override
  ChatCache getCache() {
    return ChatCache(
      chatId: chatId,
      spaceId: spaceId,
      noReadCount: _noReadCount.value,
      lastMessage: _lastMessage.value,
    );
  }

  @override
  loadCache(ChatCache chatCache) {
    if (chatCache.lastMessage?.id != lastMessage?.id) {
      if (chatCache.lastMessage != null) {
        _messages.add(chatCache.lastMessage!);
      }
    }
    _noReadCount.value = chatCache.noReadCount;
    _lastMessage.value = chatCache.lastMessage;
  }

  @override
  clearMessage() {
    throw UnimplementedError();
  }

  @override
  Future<ApiResp> deleteMessage(String id) {
    throw UnimplementedError();
  }

  @override
  moreMessage({String? filter}) {
    throw UnimplementedError();
  }

  @override
  morePersons({String? filter}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> recallMessage(String id) async {
    for (var message in _messages) {
      if (message.id == id) {
        await kernelApi.recallImMsg(message);
        return true;
      }
    }
    return false;
  }

  @override
  receiveMessage(MessageDetail detail, bool noRead) async {
    if (detail.id != _lastMessage.value?.id) {
      _noReadCount.value += noRead ? 1 : 0;
      _lastMessage.value = detail;
      _messages.add(detail);
    }
  }

  @override
  Future<void> sendMsg(MsgType msgType, String msgBody) async {
    await kernelApi.createImMsg(ImMsgModel(
      msgType: msgType.name,
      msgBody: msgBody,
      spaceId: _spaceId,
      fromId: auth.userId,
      toId: _chatId,
    ));
  }

  @override
  MessageItemWidget mapping() {
    return MessageItemWidget(
      chat: this,
      onTap: (IChat chat) => onTap(chat),
    );
  }

  onTap(IChat chat) async {
    if (Get.isRegistered<MessageController>()) {
      var messageCtrl = Get.find<MessageController>();
      await messageCtrl.setCurrent(spaceId, chatId);
      Get.offNamedUntil(
        Routers.chat,
        (router) => router.settings.name == Routers.home,
      );
    }
  }

  @override
  readAll() {
    _noReadCount.value = 0;
  }
}

class PersonChat extends BaseChat {
  PersonChat({
    required super.spaceId,
    required super.spaceName,
    required super.target,
  });

  @override
  moreMessage({String? filter}) async {
    List<dynamic> details = [];
    if (spaceId == auth.userId) {
      // 如果是个人空间从本地存储拿数据
      var domain = Domain.user.name;
      Map<String, dynamic> options = {
        "match": {
          "sessionId": target.id,
          "spaceId": spaceId,
        },
        "sort": {"createTime": -1},
        "skip": _messages.length,
        "limit": 30
      };
      ApiResp apiResp = await kernelApi.anyStore.aggregate(
        collName: collName,
        opt: options,
        domain: domain,
      );
      details.addAll(apiResp.data);
    } else {
      // 如果是单位空间从接口拿数据
      var params = IdSpaceReq(
        id: target.id,
        spaceId: spaceId,
        page: PageModel(
          limit: 30,
          offset: _messages.length,
          filter: filter ?? "",
        ),
      );
      PageResp<MessageDetail> res = await kernelApi.queryFriendImMsgs(params);
      details.addAll(res.result);
    }
    // 插入最新的位置
    for (var item in details) {
      item["id"] = item["chatId"];
      var detail = MessageDetail.fromMap(item);
      detail.msgBody = EncryptionUtil.inflate(detail.msgBody ?? "");
      _messages.add(detail);
    }
  }
}

class CohortChat extends BaseChat {
  CohortChat({
    required super.spaceId,
    required super.spaceName,
    required super.target,
  });

  @override
  moreMessage({String? filter}) async {
    List<dynamic> details = [];
    if (spaceId == auth.userId) {
      // 如果是个人空间从本地存储拿数据
      var domain = Domain.user.name;
      Map<String, dynamic> options = {
        "match": {"sessionId": target.id},
        "sort": {"createTime": -1},
        "skip": _messages.length,
        "limit": 30
      };
      ApiResp apiResp = await kernelApi.anyStore.aggregate(
        collName: collName,
        opt: options,
        domain: domain,
      );
      details.addAll(apiResp.data);
    } else {
      // 如果是单位空间从接口拿数据
      var params = IdReq(
        id: target.id,
        page: PageModel(
          limit: 30,
          offset: _messages.length,
          filter: filter ?? "",
        ),
      );
      PageResp<MessageDetail> res = await kernelApi.queryCohortImMsgs(params);
      details.addAll(res.result);
    }
    // 插入最新的位置
    for (var item in details) {
      item["id"] = item["chatId"];
      var detail = MessageDetail.fromMap(item);
      detail.msgBody = EncryptionUtil.inflate(detail.msgBody ?? "");
      _messages.add(detail);
    }
  }

  @override
  morePersons({String? filter}) async {
    PageResp<Target> page = await kernelApi.querySubTargetById(IDReqSubModel(
      id: target.id,
      typeNames: [target.typeName],
      subTypeNames: [TargetType.person.label],
      page: PageModel(
        limit: 13,
        offset: _persons.length,
        filter: filter ?? "",
      ),
    ));
    for (var target in page.result) {
      target.name = target.team?.name ?? target.name;
      _persons.add(target);
    }
    _personCount.value = page.total;
  }
}
