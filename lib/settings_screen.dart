import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'help_feedback_screen.dart';
import 'about_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'user_manager.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '设置',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSettingItem(
            context,
            icon: Icons.person_outline,
            title: '编辑资料',
            subtitle: '修改个人信息',
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()),
              );
              // 如果有返回数据，传递回上一页
              if (result != null && context.mounted) {
                Navigator.pop(context, result);
              }
            },
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            context,
            icon: Icons.help_outline,
            title: '帮助与反馈',
            subtitle: '常见问题与意见反馈',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpFeedbackScreen()),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            context,
            icon: Icons.info_outline,
            title: '关于我们',
            subtitle: '了解探友',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            context,
            icon: Icons.description_outlined,
            title: '用户需知',
            subtitle: '用户使用须知',
            onTap: () => _launchURL('https://sites.google.com/view/molianyhxz/%E9%A6%96%E9%A1%B5'),
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            context,
            icon: Icons.privacy_tip_outlined,
            title: '隐私协议',
            subtitle: '隐私保护政策',
            onTap: () => _launchURL('https://sites.google.com/view/molianysxy/%E9%A6%96%E9%A1%B5'),
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            context,
            icon: Icons.person_remove_outlined,
            title: '注销账号',
            subtitle: '永久删除账号及数据',
            onTap: () => _showDeleteAccountDialog(context),
          ),
          const SizedBox(height: 32),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9D31FF).withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF9D31FF).withOpacity(0.1),
                        const Color(0xFFF260FF).withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: const Color(0xFF9D31FF), size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: Colors.grey[400], size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showLogoutDialog(context),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                '退出账号',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red[400],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('无法打开链接: $url');
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          '退出账号',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: const Text(
          '是否退出当前账号？\n退出登录后需要重新登录',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '取消',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          TextButton(
            onPressed: () {
              // 重置用户信息
              UserManager().reset();
              Navigator.pop(context); // 关闭对话框
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: const Text(
              '确定',
              style: TextStyle(color: Color(0xFF9D31FF)),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          '注销账号',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
        ),
        content: const Text(
          '是否注销该账号？\n注销后账号及所有数据将被永久删除，无法恢复',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '取消',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          TextButton(
            onPressed: () {
              // 重置用户信息
              UserManager().reset();
              Navigator.pop(context); // 关闭对话框
              
              // 返回登录页面
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: const Text(
              '确定',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
