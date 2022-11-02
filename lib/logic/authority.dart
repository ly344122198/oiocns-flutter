import 'package:get/get.dart';
import 'package:orginone/api/person_api.dart';

import '../api_resp/token_authority_resp.dart';

enum OrgAuths {
  superAdmin("super-admin"),
  relationAdmin("relation-admin"),
  thingAdmin("thing-admin"),
  marketAdmin("market-admin"),
  applicationAdmin("application-admin");

  final String name;

  const OrgAuths(this.name);
}

class Authority {
  final TokenAuthorityResp resp;

  Authority._(this.resp);

  get spaceId => resp.spaceId;

  get userId => resp.userId;

  get userInfo => resp.userInfo;

  get spaceInfo => resp.spaceInfo;

  /// 判断目标是否含有系统权限
  /// [auths] 相应权限
  /// [targetIds] 相应目标
  bool _hasTargetsAuth(List<String> auths, List<String> targetIds) {
    var matchedFirst = resp.identitys.firstWhereOrNull((identity) {
      var authority = identity.authority;
      if (authority == null) {
        return false;
      }
      if (authority.belongId != null) {
        // 系统的权限
        return false;
      }
      return targetIds.contains(identity.belongId) &&
          auths.contains(authority.code);
    });
    return matchedFirst != null;
  }

  /// 获取目标相应的系统权限
  /// [targetId] 目标 id
  String getTargetIdentities(String targetId) {
    return resp.identitys
        .where((identity) => identity.belongId == targetId)
        .map((identity) => identity.name)
        .join(",");
  }

  /// 是否为用户空间
  bool isUserSpace() {
    return resp.userId == resp.spaceId;
  }

  /// 是否为单位空间
  bool isCompanySpace() {
    return resp.userId != resp.spaceId;
  }

  /// 是否为组织管理员
  /// [targetIds] 目标对象
  bool isSuperAdmin(List<String> targetIds) {
    return _hasTargetsAuth([OrgAuths.superAdmin.name], targetIds);
  }

  /// 是否为组织关系管理员
  /// [targetIds] 目标对象
  bool isRelationAdmin(List<String> targetIds) {
    var auths = [OrgAuths.superAdmin.name, OrgAuths.relationAdmin.name];
    return _hasTargetsAuth(auths, targetIds);
  }

  /// 是否为组织物资管理员
  /// [targetIds] 目标对象
  bool isThingAdmin(List<String> targetIds) {
    var auths = [OrgAuths.superAdmin.name, OrgAuths.thingAdmin.name];
    return _hasTargetsAuth(auths, targetIds);
  }

  /// 是否为组织商店管理员
  /// [targetIds] 目标对象
  bool isMarketAdmin(List<String> targetIds) {
    var auths = [OrgAuths.superAdmin.name, OrgAuths.marketAdmin.name];
    return _hasTargetsAuth(auths, targetIds);
  }

  /// 是否为组织应用管理员
  /// [targetIds] 目标对象
  bool isApplicationAdmin(List<String> targetIds) {
    var auths = [
      OrgAuths.superAdmin.name,
      OrgAuths.thingAdmin.name,
      OrgAuths.applicationAdmin.name,
    ];
    return _hasTargetsAuth(auths, targetIds);
  }
}

late Authority _instance;

Authority get auth => _instance;

Future<Authority> loadAuth() async {
  TokenAuthorityResp authorityResp = await PersonApi.tokenInfo();
  _instance = Authority._(authorityResp);
  return _instance;
}