
import 'package:flutter/material.dart';
import 'dart:io';
import 'splash_screen.dart';
import 'login_screen.dart';
import 'publish_post_screen.dart';
import 'publish_note_screen.dart';
import 'settings_screen.dart';
import 'post_detail_screen.dart';
import 'note_detail_screen.dart';
import 'user_profile_screen.dart';
import 'ai_assistant_screen.dart';
import 'user_manager.dart';
import 'molianIAP/molianStoreView.dart';

void main() {
  runApp(const MolianApp());
}

class MolianApp extends StatelessWidget {
  const MolianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '陌恋',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF9D31FF),
        scaffoldBackgroundColor: const Color(0xFFF8F9FD),
        fontFamily: 'SF Pro Display',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const FeedScreen(),
    const NotesScreen(),
    const AIAssistantScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFF9D31FF),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '动态',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '笔记',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            label: 'AI助手',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
}

// 动态广场页面
class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final UserManager _userManager = UserManager();
  
  @override
  void initState() {
    super.initState();
    // 监听用户信息变化（包括拉黑列表变化）
    _userManager.addListener(_onUserInfoChanged);
  }
  
  @override
  void dispose() {
    _userManager.removeListener(_onUserInfoChanged);
    super.dispose();
  }
  
  void _onUserInfoChanged() {
    setState(() {});
  }
  
  // 动态列表数据
  final List<Map<String, dynamic>> _feedList = [
    {
      'id': '1',
      'avatar': 'assets/images/suxiaonuan.jpg',
      'name': '苏小暖',
      'time': '5分钟前',
      'content': '早起看到窗外下雨了☔️ 突然很想喝一碗热乎乎的馄饨，于是出门找了家老店，果然没让我失望！',
      'images': [
        'https://picsum.photos/seed/food1/400/400',
        'https://picsum.photos/seed/food2/400/400',
      ],
      'likes': 23,
      'comments': 4,
      'isLiked': false,
    },
    {
      'id': '2',
      'avatar': 'assets/images/ajie.jpg',
      'name': '阿杰',
      'time': '15分钟前',
      'content': '周末去爬山啦🏔️ 虽然累到腿软，但站在山顶看到云海的那一刻，觉得一切都值得了！大自然真的太治愈了',
      'images': [
        'https://picsum.photos/seed/mountain1/400/400',
        'https://picsum.photos/seed/mountain2/400/400',
      ],
      'likes': 28,
      'comments': 5,
      'isLiked': true,
    },
    {
      'id': '3',
      'avatar': 'assets/images/linxiaoxi.jpg',
      'name': '林小溪',
      'time': '30分钟前',
      'content': '终于把这个月的工作报告搞定了！奖励自己一杯奶茶🧋 最近加班太多了，要好好休息一下',
      'images': [
        'https://picsum.photos/seed/drink1/400/400',
      ],
      'likes': 15,
      'comments': 2,
      'isLiked': false,
    },
    {
      'id': '4',
      'avatar': 'assets/images/zhangchen.jpg',
      'name': '张晨',
      'time': '1小时前',
      'content': '今天天气太好了！约了几个朋友去公园打羽毛球，出了一身汗，感觉整个人都轻松了😊',
      'images': [
        'https://picsum.photos/seed/sport1/400/400',
      ],
      'likes': 19,
      'comments': 3,
      'isLiked': true,
    },
    {
      'id': '5',
      'avatar': 'assets/images/xiamo.jpg',
      'name': '夏末',
      'time': '2小时前',
      'content': '周末在家学做手工，第一次尝试折纸鹤，虽然有点丑但是很有成就感哈哈哈🦢',
      'images': [
        'https://picsum.photos/seed/craft1/400/400',
        'https://picsum.photos/seed/craft2/400/400',
        'https://picsum.photos/seed/craft3/400/400',
      ],
      'likes': 26,
      'comments': 5,
      'isLiked': false,
    },
    {
      'id': '6',
      'avatar': 'assets/images/wanghaoran.jpg',
      'name': '王浩然',
      'time': '3小时前',
      'content': '下班路上偶遇超美的晚霞🌅 赶紧拍下来分享给大家！这个城市真的很美',
      'images': [
        'https://picsum.photos/seed/sunset1/400/400',
      ],
      'likes': 30,
      'comments': 5,
      'isLiked': true,
    },
    {
      'id': '7',
      'avatar': 'assets/images/default_avatar.jpg',
      'name': '陈思思',
      'time': '4小时前',
      'content': '图书馆学习ing📚 准备下个月的考试，加油加油！顺便拍了张照片记录一下',
      'images': [
        'https://picsum.photos/seed/study1/400/400',
        'https://picsum.photos/seed/study2/400/400',
      ],
      'likes': 22,
      'comments': 4,
      'isLiked': false,
    },
    {
      'id': '8',
      'avatar': 'assets/images/limingxuan.jpg',
      'name': '李明轩',
      'time': '5小时前',
      'content': '今天心情不太好，去海边走了走，看着海浪一波一波的，突然觉得什么烦恼都不算什么了🌊',
      'images': [
        'https://picsum.photos/seed/sea1/400/400',
        'https://picsum.photos/seed/sea2/400/400',
      ],
      'likes': 27,
      'comments': 5,
      'isLiked': true,
    },
    {
      'id': '9',
      'avatar': 'assets/images/zhouxiaomi.jpg',
      'name': '周小米',
      'time': '6小时前',
      'content': '周末在家做烘焙🍰 第一次尝试做蛋糕，虽然卖相不太好但味道还不错！下次继续努力',
      'images': [
        'https://picsum.photos/seed/cake1/400/400',
        'https://picsum.photos/seed/cake2/400/400',
      ],
      'likes': 20,
      'comments': 4,
      'isLiked': false,
    },
    {
      'id': '10',
      'avatar': 'assets/images/default_avatar.jpg',
      'name': '刘宇航',
      'time': '7小时前',
      'content': '周末在家研究新菜谱，做了一桌子菜请朋友们来吃饭🍜 大家都说好吃，太有成就感了！',
      'images': [
        'https://picsum.photos/seed/cooking1/400/400',
        'https://picsum.photos/seed/cooking2/400/400',
      ],
      'likes': 29,
      'comments': 5,
      'isLiked': true,
    },
    {
      'id': '11',
      'avatar': 'assets/images/default_avatar.jpg',
      'name': '许梦瑶',
      'time': '8小时前',
      'content': '早上被闹钟吵醒，发现外面在下雪❄️ 立刻爬起来冲到阳台，好久没见过这么大的雪了！堆个雪人去～',
      'images': [
        'https://picsum.photos/seed/snow1/400/400',
        'https://picsum.photos/seed/snow2/400/400',
      ],
      'likes': 24,
      'comments': 4,
      'isLiked': false,
    },
    {
      'id': '12',
      'avatar': 'assets/images/default_avatar.jpg',
      'name': '赵子龙',
      'time': '9小时前',
      'content': '加班到深夜终于完成了这个项目的最后一个模块💻 虽然累但是看到代码跑通的那一刻，所有辛苦都值得了！',
      'images': [
        'https://picsum.photos/seed/work1/400/400',
      ],
      'likes': 21,
      'comments': 3,
      'isLiked': true,
    },
    {
      'id': '13',
      'avatar': 'assets/images/yangxiaotong.jpg',
      'name': '杨晓彤',
      'time': '10小时前',
      'content': '今天去参加了朋友的婚礼💐 看着她穿着婚纱的样子真的好美，祝福她们永远幸福！顺便吃到了超好吃的婚宴',
      'images': [
        'https://picsum.photos/seed/wedding1/400/400',
        'https://picsum.photos/seed/wedding2/400/400',
        'https://picsum.photos/seed/wedding3/400/400',
      ],
      'likes': 30,
      'comments': 5,
      'isLiked': true,
    },
    {
      'id': '14',
      'avatar': 'assets/images/default_avatar.jpg',
      'name': '吴昊天',
      'time': '11小时前',
      'content': '终于拿到驾照啦🚗 从科一到科四一路过关，感谢教练的耐心指导！周末就可以开车带家人出去玩了',
      'images': [
        'https://picsum.photos/seed/car1/400/400',
        'https://picsum.photos/seed/car2/400/400',
      ],
      'likes': 27,
      'comments': 5,
      'isLiked': false,
    },
    {
      'id': '15',
      'avatar': 'assets/images/fangyuxin.jpg',
      'name': '方雨欣',
      'time': '12小时前',
      'content': '下午茶时间☕️ 在咖啡馆偶遇了大学室友，聊了好久好久，回忆起那些年一起熬夜赶论文的日子，真怀念啊～',
      'images': [
        'https://picsum.photos/seed/coffee1/400/400',
        'https://picsum.photos/seed/coffee2/400/400',
      ],
      'likes': 16,
      'comments': 2,
      'isLiked': false,
    },
    {
      'id': '16',
      'avatar': 'assets/images/sunhaoyu.jpg',
      'name': '孙浩宇',
      'time': '13小时前',
      'content': '健身房打卡第30天✨ 坚持真的会有回报，现在的状态比一个月前好太多了！继续加油，目标是练出腹肌💪',
      'images': [
        'https://picsum.photos/seed/gym1/400/400',
        'https://picsum.photos/seed/gym2/400/400',
      ],
      'likes': 25,
      'comments': 4,
      'isLiked': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: Column(
        children: [
          // 顶部导航栏
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey[100]!, width: 1),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF9D31FF).withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/logo.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFF9D31FF), Color(0xFFF260FF)],
                          ).createShader(bounds),
                          child: const Text(
                            '陌恋',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Text(
                          '动态广场',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 动态列表
          Expanded(
            child: Builder(
              builder: (context) {
                // 过滤掉被拉黑用户的动态
                final filteredFeeds = _feedList
                    .where((feed) => !_userManager.isUserBlocked(feed['name'] as String))
                    .toList();
                
                if (filteredFeeds.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '暂无动态',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredFeeds.length,
                  itemBuilder: (context, index) {
                    final feed = filteredFeeds[index];
                    final originalIndex = _feedList.indexOf(feed);
                    return Column(
                      children: [
                        _buildFeedCard(
                          context: context,
                          feedId: feed['id'],
                          feedIndex: originalIndex,
                          avatar: feed['avatar'],
                          name: feed['name'],
                          time: feed['time'],
                          content: feed['content'],
                          images: List<String>.from(feed['images']),
                          likes: feed['likes'],
                          comments: feed['comments'],
                          isLiked: feed['isLiked'],
                        ),
                        if (index < filteredFeeds.length - 1) const SizedBox(height: 12),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PublishPostScreen()),
          );
        },
        backgroundColor: const Color(0xFF9D31FF),
        child: const Icon(Icons.edit_rounded, size: 28),
      ),
    );
  }

  Widget _buildFeedCard({
    required String feedId,
    required int feedIndex,
    required String avatar,
    required String name,
    required String time,
    required String content,
    required List<String> images,
    required int likes,
    required int comments,
    required bool isLiked,
    required BuildContext context,
  }) {
    return _FeedCard(
      feedId: feedId,
      feedIndex: feedIndex,
      avatar: avatar,
      name: name,
      time: time,
      content: content,
      images: images,
      likes: likes,
      comments: comments,
      isLiked: isLiked,
      onBlocked: () {
        // 从列表中移除被屏蔽的动态
        setState(() {
          _feedList.removeAt(feedIndex);
        });
      },
      onMoreTap: () => _showOthersPostMenu(context, name, feedIndex),
    );
  }

  void _showOthersPostMenu(BuildContext context, String userName, int feedIndex) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              _buildMenuOption(
                context,
                icon: Icons.block_outlined,
                title: '拉黑',
                subtitle: '不再看到此用户的内容',
                color: Colors.orange,
                onTap: () {
                  Navigator.pop(context);
                  _showConfirmDialog(
                    context,
                    '拉黑用户',
                    '确定要拉黑「$userName」吗？\n拉黑后将不再看到TA的任何内容',
                    '已拉黑该用户',
                    onConfirm: () {
                      // 执行拉黑操作
                      final userManager = UserManager();
                      userManager.blockUser(userName);
                    },
                  );
                },
              ),
              _buildMenuOption(
                context,
                icon: Icons.report_outlined,
                title: '举报',
                subtitle: '举报不良内容',
                color: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  _showConfirmDialog(
                    context,
                    '举报动态',
                    '确定要举报这条动态吗？\n我们会尽快处理',
                    '举报已提交，感谢您的反馈',
                  );
                },
              ),
              _buildMenuOption(
                context,
                icon: Icons.visibility_off_outlined,
                title: '屏蔽',
                subtitle: '不再看到此条动态',
                color: Colors.grey[700]!,
                onTap: () {
                  Navigator.pop(context);
                  // 从列表中移除被屏蔽的动态
                  setState(() {
                    _feedList.removeAt(feedIndex);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('已屏蔽该动态'),
                      backgroundColor: const Color(0xFF9D31FF),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
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
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmDialog(
    BuildContext context,
    String title,
    String content,
    String successMessage, {
    VoidCallback? onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        content: Text(content, style: const TextStyle(height: 1.5)),
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
              Navigator.pop(context);
              onConfirm?.call(); // 执行回调
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(successMessage),
                  backgroundColor: const Color(0xFF9D31FF),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
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
}

// 时光笔记页面
class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  // 笔记列表数据
  final List<Map<String, dynamic>> _notesList = [
    {
      'id': 'note1',
      'time': '14:30',
      'date': '2月5日',
      'mood': '🤗',
      'title': '春日咖啡时光',
      'content': '今天下午去了新开的咖啡馆，点了一杯拿铁。阳光透过落地窗洒进来，整个空间都变得温暖起来。店里放着轻柔的爵士乐，让人不自觉地放松下来。',
      'images': [
        'https://picsum.photos/seed/cafe1/600/400',
        'https://picsum.photos/seed/cafe2/600/400',
        'https://picsum.photos/seed/cafe3/600/400',
      ],
      'likes': 20,
      'comments': 3,
    },
    {
      'id': 'note2',
      'time': '20:15',
      'date': '2月4日',
      'mood': '😴',
      'title': '夜跑感悟',
      'content': '晚上去公园跑了5公里，感觉整个人都轻松了很多。夜晚的风很凉爽，路灯下的影子一长一短。跑步的时候什么都不想，只专注于呼吸和脚步。',
      'images': [
        'https://picsum.photos/seed/running1/600/400',
        'https://picsum.photos/seed/running2/600/400',
      ],
      'likes': 25,
      'comments': 4,
    },
    {
      'id': 'note3',
      'time': '16:45',
      'date': '2月3日',
      'mood': '😌',
      'title': '读书笔记',
      'content': '今天读完了《月亮与六便士》，被主人公的勇气深深打动。有时候我们需要的不是别人的理解，而是追随内心的勇气。',
      'images': [
        'https://picsum.photos/seed/book1/600/400',
      ],
      'likes': 25,
      'comments': 4,
    },
    {
      'id': 'note4',
      'time': '10:20',
      'date': '2月2日',
      'mood': '😊',
      'title': '周末计划',
      'content': '这个周末想去海边走走，已经很久没有看海了。准备带上相机，记录下海浪和日落。希望天气能好一点。',
      'images': [],
      'likes': 25,
      'comments': 4,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: Column(
        children: [
          // 顶部渐变导航栏
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF9D31FF), Color(0xFFF260FF), Color(0xFFFF609F)],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '时光笔记',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '记录每一个珍贵时刻',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.white, size: 20),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PublishNoteScreen()),
                          );
                        },
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 笔记列表 - 时间轴样式
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              itemCount: _notesList.length,
              itemBuilder: (context, index) {
                final note = _notesList[index];
                return _buildTimelineNote(
                  context,
                  noteIndex: index,
                  time: note['time'],
                  date: note['date'],
                  mood: note['mood'],
                  title: note['title'],
                  content: note['content'],
                  images: List<String>.from(note['images']),
                  isFirst: index == 0,
                  isLast: index == _notesList.length - 1,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineNote(
    BuildContext context, {
    required int noteIndex,
    required String time,
    required String date,
    required String mood,
    required String title,
    required String content,
    required List<String> images,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧时间轴 - 减小宽度
          SizedBox(
            width: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9D31FF),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // 时间轴线和圆点
          Column(
            children: [
              // 上方线条
              if (!isFirst)
                Container(
                  width: 2,
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF9D31FF).withOpacity(0.3),
                        const Color(0xFF9D31FF).withOpacity(0.5),
                      ],
                    ),
                  ),
                ),
              // 圆点
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9D31FF), Color(0xFFF260FF)],
                  ),
                  border: Border.all(
                    color: const Color(0xFFF8F9FD),
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9D31FF).withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              // 下方线条
              if (!isLast)
                Container(
                  width: 2,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF9D31FF).withOpacity(0.5),
                        const Color(0xFF9D31FF).withOpacity(0.2),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
          // 右侧笔记内容 - 扩大占比
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteDetailScreen(
                      time: time,
                      date: date,
                      mood: mood,
                      title: title,
                      content: content,
                      images: images,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9D31FF).withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题和删除按钮
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  mood,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              _showDeleteDialog(context, title, noteIndex);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 正文
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        content,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                          height: 1.6,
                        ),
                      ),
                    ),
                    // 图片
                    if (images.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildImageGrid(images),
                      ),
                    ],
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid(List<String> images) {
    if (images.isEmpty) return const SizedBox();

    if (images.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          images[0],
          width: double.infinity,
          height: 180,
          fit: BoxFit.cover,
        ),
      );
    } else if (images.length == 2) {
      return Row(
        children: images
            .map((url) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: url == images.last ? 0 : 8,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        url,
                        height: 140,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ))
            .toList(),
      );
    } else {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: images.length > 3 ? 3 : images.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              images[index],
              fit: BoxFit.cover,
            ),
          );
        },
      );
    }
  }

  void _showDeleteDialog(BuildContext context, String title, int noteIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          '删除笔记',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: Text('确定要删除「$title」吗？'),
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
              Navigator.pop(context);
              // 从列表中删除笔记
              setState(() {
                _notesList.removeAt(noteIndex);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('笔记已删除'),
                  backgroundColor: const Color(0xFF9D31FF),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            child: const Text(
              '删除',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

// 个人中心页面
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserManager _userManager = UserManager();
  
  @override
  void initState() {
    super.initState();
    // 监听用户信息变化
    _userManager.addListener(_onUserInfoChanged);
  }
  
  @override
  void dispose() {
    _userManager.removeListener(_onUserInfoChanged);
    super.dispose();
  }
  
  void _onUserInfoChanged() {
    setState(() {});
  }
  
  // 我的最近动态列表
  final List<Map<String, dynamic>> _myRecentFeeds = [
    {
      'id': 'my1',
      'time': '2分钟前',
      'content': '今天的午后阳光真好，在咖啡馆遇见了一只超可爱的橘猫🐱 它一直在我脚边蹭来蹭去，心都要化了～',
      'images': [
        'https://picsum.photos/seed/cat1/400/400',
        'https://picsum.photos/seed/cat2/400/400',
        'https://picsum.photos/seed/cat3/400/400',
      ],
      'likes': 128,
      'comments': 32,
    },
    {
      'id': 'my2',
      'time': '15分钟前',
      'content': '第一次尝试做提拉米苏，虽然卖相不太好，但味道还不错！下次继续努力💪',
      'images': [
        'https://picsum.photos/seed/dessert1/400/400',
        'https://picsum.photos/seed/dessert2/400/400',
      ],
      'likes': 25,
      'comments': 4,
    },
    {
      'id': 'my3',
      'time': '5小时前',
      'content': '今天在咖啡馆偶遇了大学同学，聊了好久好久☕️ 时光飞逝，但友谊依旧。感恩生命中遇到的每一个人～',
      'images': [
        'https://picsum.photos/seed/friends1/400/400',
        'https://picsum.photos/seed/friends2/400/400',
      ],
      'likes': 32,
      'comments': 7,
    },
    {
      'id': 'my4',
      'time': '昨天',
      'content': '终于把阳台改造完成了🌿 种了好多绿植，每天早上起来看到这些小生命就觉得很治愈。生活需要一点绿色！',
      'images': [
        'https://picsum.photos/seed/plants1/400/400',
        'https://picsum.photos/seed/plants2/400/400',
        'https://picsum.photos/seed/plants3/400/400',
      ],
      'likes': 41,
      'comments': 9,
    },
    {
      'id': 'my5',
      'time': '2天前',
      'content': '夜跑打卡第100天�‍♀️ 从最初的坚持不了1公里，到现在轻松跑5公里，真的很有成就感！坚持就是胜利💪',
      'images': [
        'https://picsum.photos/seed/jogging1/400/400',
      ],
      'likes': 38,
      'comments': 6,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFF),
      body: CustomScrollView(
        slivers: [
          // 顶部区域
          SliverAppBar(
            expandedHeight: 80,
            pinned: false,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      const Color(0xFFF8F9FD).withOpacity(0.3),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12, right: 20),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SettingsScreen()),
                          );
                          // 如果有返回数据，更新个人信息
                          if (result != null && mounted) {
                            _userManager.updateUserInfo(
                              nickname: result['nickname'],
                              signature: result['signature'],
                              avatarPath: result['avatarPath'],
                            );
                            setState(() {}); // 触发重建
                          }
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FD),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.settings,
                            color: Colors.grey[700],
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 用户信息卡片
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF9D31FF).withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // 用户信息 - 左右布局
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              // 头像
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF9D31FF), Color(0xFFF260FF)],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF9D31FF).withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: _userManager.avatarPath != null
                                      ? Image.file(
                                          File(_userManager.avatarPath!),
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/images/default_avatar.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // 昵称和签名
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _userManager.nickname,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      _userManager.signature,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 分隔线
                        Container(
                          height: 1,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.grey[200]!,
                                Colors.grey[100]!,
                                Colors.grey[200]!,
                              ],
                            ),
                          ),
                        ),
                        // 数据统计 - 左右布局
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          child: Row(
                            children: [
                              Expanded(child: _buildStatItem('42', '粉丝')),
                              Container(
                                width: 1,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.grey[200]!,
                                      Colors.grey[300]!,
                                      Colors.grey[200]!,
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(child: _buildStatItem('38', '关注')),
                              Container(
                                width: 1,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.grey[200]!,
                                      Colors.grey[300]!,
                                      Colors.grey[200]!,
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(child: _buildStatItem('186', '获赞')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 金币余额卡片
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MolianStoreView()),
                      );
                      // 返回后刷新UI（UserManager会自动通知）
                      setState(() {});
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFFB75E), Color(0xFFED8F03)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFFFB75E).withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.diamond,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '金币余额',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${_userManager.coins}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '充值',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // 最近动态 - 参考动态页面布局
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '最近动态',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // 动态卡片列表
                        ..._myRecentFeeds.asMap().entries.map((entry) {
                          final index = entry.key;
                          final feed = entry.value;
                          return Column(
                            children: [
                              _buildMyRecentFeedCard(
                                context: context,
                                feedIndex: index,
                                time: feed['time'],
                                content: feed['content'],
                                images: List<String>.from(feed['images']),
                                likes: feed['likes'],
                                comments: feed['comments'],
                              ),
                              if (index < _myRecentFeeds.length - 1) const SizedBox(height: 12),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMyRecentFeedCard({
    required int feedIndex,
    required String time,
    required String content,
    required List<String> images,
    required int likes,
    required int comments,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(
              avatar: _userManager.avatarPathOrDefault,
              name: _userManager.nickname,
              time: time,
              content: content,
              images: images,
              likes: likes,
              comments: comments,
              isLiked: true,
              isMyPost: true,
            ),
          ),
        );
        
        // 如果返回了删除标记，从列表中移除该动态
        if (result != null && result['deleted'] == true && mounted) {
          setState(() {
            _myRecentFeeds.removeAt(feedIndex);
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9D31FF).withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 时间
            Text(
              time,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
          ),
          const SizedBox(height: 12),
          // 内容
          Text(
            content,
            style: const TextStyle(
              color: Color(0xFF333333),
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          // 图片网格
          _buildImageGrid(images),
          const SizedBox(height: 12),
          // 互动区
          Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[100]!),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(
                  icon: Icons.favorite,
                  label: likes.toString(),
                  color: Colors.pink,
                ),
                _buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: comments.toString(),
                  color: Colors.grey,
                ),
                GestureDetector(
                  onTap: () => _showDeleteMyPostDialog(context, feedIndex),
                  child: _buildActionButton(
                    icon: Icons.delete_outline,
                    label: '',
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildImageGrid(List<String> images) {
    if (images.isEmpty) return const SizedBox();

    if (images.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.network(
            images[0],
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (images.length == 2) {
      return SizedBox(
        height: 150,
        child: Row(
          children: images
              .map((url) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: url == images.last ? 0 : 8,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      );
    } else {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemCount: images.length > 9 ? 9 : images.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              images[index],
              fit: BoxFit.cover,
            ),
          );
        },
      );
    }
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        if (label.isNotEmpty) ...[
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 14),
          ),
        ],
      ],
    );
  }

  void _showDeleteMyPostDialog(BuildContext context, int feedIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          '删除动态',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: const Text(
          '确定要删除这条动态吗？\n删除后将无法恢复',
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
              Navigator.pop(context);
              // 删除动态
              setState(() {
                _myRecentFeeds.removeAt(feedIndex);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('动态已删除'),
                  backgroundColor: const Color(0xFF9D31FF),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: const Text(
              '删除',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

// 动态卡片组件（带动画）
class _FeedCard extends StatefulWidget {
  final String feedId;
  final int feedIndex;
  final String avatar;
  final String name;
  final String time;
  final String content;
  final List<String> images;
  final int likes;
  final int comments;
  final bool isLiked;
  final VoidCallback onMoreTap;
  final VoidCallback onBlocked;

  const _FeedCard({
    required this.feedId,
    required this.feedIndex,
    required this.avatar,
    required this.name,
    required this.time,
    required this.content,
    required this.images,
    required this.likes,
    required this.comments,
    required this.isLiked,
    required this.onMoreTap,
    required this.onBlocked,
  });

  @override
  State<_FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<_FeedCard> with SingleTickerProviderStateMixin {
  late bool _isLiked;
  late int _likesCount;
  late AnimationController _likeAnimationController;
  late Animation<double> _likeScaleAnimation;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _likesCount = widget.likes;

    _likeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _likeScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.3),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(
      parent: _likeAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    super.dispose();
  }

  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return AssetImage(imagePath);
    } else {
      return NetworkImage(imagePath);
    }
  }

  // 根据用户名生成不同的统计数据
  Map<String, String> _generateUserStats(String name) {
    // 使用名字的哈希值作为种子，确保同一个用户总是显示相同的数据
    final seed = name.hashCode.abs();
    final random = _SeededRandom(seed);
    
    // 生成粉丝数 (10-999)
    final followers = 10 + random.nextInt(990);
    
    // 生成关注数 (5-500)
    final following = 5 + random.nextInt(496);
    
    // 生成获赞数 (50-9999)
    final likes = 50 + random.nextInt(9950);
    
    return {
      'followers': followers.toString(),
      'following': following.toString(),
      'likes': likes.toString(),
    };
  }

  // 根据用户名生成不同的个性签名
  String _generateUserSignature(String name) {
    final signatures = [
      '热爱生活，享受每一天 ✨',
      '记录生活的美好瞬间 📷',
      '用心感受世界的温度 🌈',
      '简单生活，快乐至上 😊',
      '追逐梦想，永不放弃 💪',
      '分享快乐，传递正能量 ☀️',
      '慢生活，细品人生 🍃',
      '做自己喜欢的事 🎨',
      '保持热爱，奔赴山海 🌊',
      '生活需要仪式感 ✨',
      '平凡日子里的小确幸 🌸',
      '用镜头记录生活 📸',
      '热爱可抵岁月漫长 🌟',
      '愿你眼中有光，心中有爱 💖',
      '做一个温暖的人 🌻',
    ];
    
    final seed = name.hashCode.abs();
    return signatures[seed % signatures.length];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(
              avatar: widget.avatar,
              name: widget.name,
              time: widget.time,
              content: widget.content,
              images: widget.images,
              likes: _likesCount,
              comments: widget.comments,
              isLiked: _isLiked,
              isMyPost: false,
            ),
          ),
        );
        
        // 如果返回了屏蔽标记，调用回调函数
        if (result != null && result['blocked'] == true) {
          widget.onBlocked();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9D31FF).withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 用户信息
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    final stats = _generateUserStats(widget.name);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfileScreen(
                          avatar: widget.avatar,
                          name: widget.name,
                          signature: _generateUserSignature(widget.name),
                          followers: stats['followers']!,
                          following: stats['following']!,
                          likes: stats['likes']!,
                          mainFeed: {
                            'time': widget.time,
                            'content': widget.content,
                            'images': widget.images,
                            'likes': _likesCount,
                            'comments': widget.comments,
                          },
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: _getImageProvider(widget.avatar),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      final stats = _generateUserStats(widget.name);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfileScreen(
                            avatar: widget.avatar,
                            name: widget.name,
                            signature: _generateUserSignature(widget.name),
                            followers: stats['followers']!,
                            following: stats['following']!,
                            likes: stats['likes']!,
                            mainFeed: {
                              'time': widget.time,
                              'content': widget.content,
                              'images': widget.images,
                              'likes': _likesCount,
                              'comments': widget.comments,
                            },
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          widget.time,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const _FollowButton(),
              ],
            ),
            const SizedBox(height: 12),
            // 内容
            Text(
              widget.content,
              style: const TextStyle(
                color: Color(0xFF333333),
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            // 图片网格
            _buildImageGrid(widget.images),
            const SizedBox(height: 12),
            // 互动区
            Container(
              padding: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[100]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isLiked = !_isLiked;
                        _likesCount += _isLiked ? 1 : -1;
                      });
                      _likeAnimationController.forward(from: 0);
                    },
                    child: ScaleTransition(
                      scale: _likeScaleAnimation,
                      child: Row(
                        children: [
                          Icon(
                            _isLiked ? Icons.favorite : Icons.favorite_border,
                            color: _isLiked ? Colors.pink : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _likesCount.toString(),
                            style: TextStyle(
                              color: _isLiked ? Colors.pink : Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.chat_bubble_outline, color: Colors.grey, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        widget.comments.toString(),
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: widget.onMoreTap,
                    child: const Icon(Icons.more_horiz, color: Colors.grey, size: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid(List<String> images) {
    if (images.isEmpty) return const SizedBox();

    if (images.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.network(
            images[0],
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (images.length == 2) {
      return SizedBox(
        height: 150,
        child: Row(
          children: images
              .map((url) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: url == images.last ? 0 : 8,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      );
    } else {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemCount: images.length > 9 ? 9 : images.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              images[index],
              fit: BoxFit.cover,
            ),
          );
        },
      );
    }
  }
}

// 关注按钮组件（带动画）
class _FollowButton extends StatefulWidget {
  const _FollowButton();

  @override
  State<_FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<_FollowButton> with SingleTickerProviderStateMixin {
  bool _isFollowing = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.9),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.9, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isFollowing = !_isFollowing;
          });
          _animationController.forward(from: 0);
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: _isFollowing
                ? null
                : const LinearGradient(
                    colors: [Color(0xFF9D31FF), Color(0xFFF260FF), Color(0xFFFF609F)],
                  ),
            color: _isFollowing ? Colors.grey[200] : null,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Text(
            _isFollowing ? '已关注' : '关注',
            style: TextStyle(
              color: _isFollowing ? Colors.grey[600] : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// 简单的伪随机数生成器，使用种子确保可重复性
class _SeededRandom {
  int _seed;
  
  _SeededRandom(this._seed);
  
  int nextInt(int max) {
    _seed = ((_seed * 1103515245 + 12345) & 0x7fffffff);
    return _seed % max;
  }
}
