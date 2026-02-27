import 'package:flutter/foundation.dart';

/// 用户信息管理类（单例模式）
class UserManager extends ChangeNotifier {
  static final UserManager _instance = UserManager._internal();
  
  factory UserManager() {
    return _instance;
  }
  
  UserManager._internal();
  
  // 用户信息
  String _nickname = '小雨';
  String _signature = '生活需要仪式感 ✨';
  String? _avatarPath;
  
  // 拉黑用户列表（存储被拉黑用户的名字）
  final Set<String> _blockedUsers = {};
  
  // Getters
  String get nickname => _nickname;
  String get signature => _signature;
  String? get avatarPath => _avatarPath;
  Set<String> get blockedUsers => Set.unmodifiable(_blockedUsers);
  
  // 获取头像路径（如果没有自定义头像，返回默认头像）
  String get avatarPathOrDefault => _avatarPath ?? 'assets/images/default_avatar.jpg';
  
  // 检查用户是否被拉黑
  bool isUserBlocked(String userName) {
    return _blockedUsers.contains(userName);
  }
  
  // 拉黑用户
  void blockUser(String userName) {
    _blockedUsers.add(userName);
    notifyListeners();
  }
  
  // 取消拉黑用户
  void unblockUser(String userName) {
    _blockedUsers.remove(userName);
    notifyListeners();
  }
  
  // 更新用户信息
  void updateUserInfo({
    String? nickname,
    String? signature,
    String? avatarPath,
  }) {
    if (nickname != null) _nickname = nickname;
    if (signature != null) _signature = signature;
    if (avatarPath != null) _avatarPath = avatarPath;
    notifyListeners();
  }
  
  // 更新头像
  void updateAvatar(String? path) {
    _avatarPath = path;
    notifyListeners();
  }
  
  // 重置用户信息（退出登录时调用）
  void reset() {
    _nickname = '小雨';
    _signature = '生活需要仪式感 ✨';
    _avatarPath = null;
    _blockedUsers.clear();
    notifyListeners();
  }
}
