import 'package:flutter/material.dart';
import 'widgets/app_image.dart';
import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'splash_screen.dart';
import 'login_screen.dart';
import 'publish_post_screen.dart';
import 'publish_note_screen.dart';
import 'settings_screen.dart';
import 'post_detail_screen.dart';
import 'note_detail_screen.dart';
import 'user_profile_screen.dart';
import 'ai_assistant_screen.dart';
import 'home_screen.dart';
import 'user_manager.dart';
import 'molianIAP/molianStoreView.dart';
import 'widgets/coin_icon.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MolianApp());
}

class MolianApp extends StatefulWidget {
  const MolianApp({super.key});

  @override
  State<MolianApp> createState() => _MolianAppState();
}

class _MolianAppState extends State<MolianApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initTracking());
  }

  Future<void> _initTracking() async {
    if (Platform.isIOS) {
      try {
        await Future.delayed(const Duration(seconds: 1));
        await AppTrackingTransparency.requestTrackingAuthorization();
      } catch (e) {
        // ignore tracking errors
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '探友',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFC94A5A),
        scaffoldBackgroundColor: const Color(0xFFF5F3F1),
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

  Widget _pageAt(int index) {
    switch (index) {
      case 1:
        return const FeedScreen();
      case 2:
        return const NotesScreen();
      case 3:
        return const ProfileScreen();
      case 0:
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageAt(_currentIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[200]!, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: const Color(0xFFE85A7A),
          unselectedItemColor: const Color(0xFF9A9A9A),
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: '首页',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: '发现',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.access_time),
              activeIcon: Icon(Icons.watch_later),
              label: '时光',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: '我的',
            ),
          ],
        ),
      ),
    );
  }
}

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final UserManager _userManager = UserManager();
  String _topic = '全部';

  @override
  void initState() {
    super.initState();
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

  final List<Map<String, dynamic>> _feedList = [
    {
      'id': '1',
      'avatar': 'assets/images/suxiaonuan.jpg',
      'name': '苏小暖',
      'time': '刚刚',
      'topic': '美食',
      'content': '下雨天适合吃馄饨。地铁口那家老店还在，老板还记得我要多放葱。',
      'images': ['assets/feed/wonton.jpg', 'assets/feed/wonton2.jpg', 'assets/feed/rain.jpg'],
      'likes': 6,
      'comments': 1,
      'isLiked': false,
    },
    {
      'id': '2',
      'avatar': 'assets/images/ajie.jpg',
      'name': '阿杰',
      'time': '12分钟前',
      'topic': '出行',
      'content': '爬了半天，腿已经不是自己的了。山顶风大，拍了两张就下来了。',
      'images': ['assets/feed/hike1.jpg', 'assets/feed/hike2.jpg'],
      'likes': 31,
      'comments': 8,
      'isLiked': true,
    },
    {
      'id': '3',
      'avatar': 'assets/images/linxiaoxi.jpg',
      'name': '林小溪',
      'time': '40分钟前',
      'topic': '美食',
      'content': '报告终于交了。奶茶店排队排到怀疑人生，杯壁还写错名字。',
      'images': ['assets/feed/milktea.jpg', 'assets/feed/milktea2.jpg'],
      'likes': 9,
      'comments': 2,
      'isLiked': false,
    },
    {
      'id': '4',
      'avatar': 'assets/images/zhangchen.jpg',
      'name': '张晨',
      'time': '1小时前',
      'topic': '运动',
      'content': '下午打羽毛球，对手太猛，我输得挺干脆。下次换双打。',
      'images': ['assets/feed/badminton.jpg'],
      'likes': 14,
      'comments': 3,
      'isLiked': false,
    },
    {
      'id': '5',
      'avatar': 'assets/images/xiamo.jpg',
      'name': '夏末',
      'time': '2小时前',
      'topic': '日常',
      'content': '折了只纸鹤，翅膀歪的。放桌上还挺好看。',
      'images': ['assets/feed/origami.jpg', 'assets/feed/desk.jpg'],
      'likes': 4,
      'comments': 0,
      'isLiked': false,
    },
    {
      'id': '6',
      'avatar': 'assets/images/wanghaoran.jpg',
      'name': '王浩然',
      'time': '昨天 19:08',
      'topic': '出行',
      'content': '下班路过天桥，晚霞把楼玻璃染成橘色。站了一会儿才想起来拍照。',
      'images': ['assets/feed/sunset.jpg'],
      'likes': 52,
      'comments': 11,
      'isLiked': true,
    },
    {
      'id': '7',
      'avatar': 'assets/images/default_avatar.jpg',
      'name': '陈思思',
      'time': '昨天',
      'topic': '学习',
      'content': '图书馆座位被占了，换到角落将就。耳机放白噪音，效率意外还行。',
      'images': ['assets/feed/library.jpg', 'assets/feed/library2.jpg'],
      'likes': 7,
      'comments': 1,
      'isLiked': false,
    },
    {
      'id': '8',
      'avatar': 'assets/images/limingxuan.jpg',
      'name': '李明轩',
      'time': '昨天',
      'topic': '出行',
      'content': '情绪不太对，去江边转了两圈。风挺大，帽子差点吹跑。',
      'images': ['assets/feed/river1.jpg', 'assets/feed/river2.jpg'],
      'likes': 18,
      'comments': 4,
      'isLiked': true,
    },
    {
      'id': '9',
      'avatar': 'assets/images/zhouxiaomi.jpg',
      'name': '周小米',
      'time': '2天前',
      'topic': '美食',
      'content': '烤箱第二次用，蛋糕塌了一半。室友说味道可以，我自己觉得偏甜。',
      'images': ['assets/feed/cake.jpg', 'assets/feed/cake2.jpg'],
      'likes': 22,
      'comments': 6,
      'isLiked': false,
    },
    {
      'id': '10',
      'avatar': 'assets/images/default_avatar.jpg',
      'name': '刘宇航',
      'time': '2天前',
      'topic': '美食',
      'content': '朋友来吃饭，炒了三个菜。最后一个糊了，端上桌大家还是吃完了。',
      'images': ['assets/feed/cooking.jpg', 'assets/feed/cooking2.jpg'],
      'likes': 3,
      'comments': 2,
      'isLiked': false,
    },
    {
      'id': '11',
      'avatar': 'assets/images/yangxiaotong.jpg',
      'name': '杨晓彤',
      'time': '3天前',
      'topic': '日常',
      'content': '去参加同事婚礼，宴会厅空调太冷，披了件外套。喜糖味道一般。',
      'images': ['assets/feed/wedding1.jpg', 'assets/feed/wedding2.jpg'],
      'likes': 41,
      'comments': 9,
      'isLiked': true,
    },
    {
      'id': '12',
      'avatar': 'assets/images/fangyuxin.jpg',
      'name': '方雨欣',
      'time': '3天前',
      'topic': '日常',
      'content': '咖啡馆碰到大学室友，聊到傍晚。账单AA，各回各家。',
      'images': ['assets/feed/coffee_meet.jpg', 'assets/feed/coffee2.jpg'],
      'likes': 12,
      'comments': 2,
      'isLiked': false,
    },
    {
      'id': '13',
      'avatar': 'assets/images/sunhaoyu.jpg',
      'name': '孙浩宇',
      'time': '上周',
      'topic': '运动',
      'content': '健身房满员，器械排队。做完一组就走了，至少没鸽自己。',
      'images': ['assets/feed/gym.jpg', 'assets/feed/gym2.jpg'],
      'likes': 8,
      'comments': 0,
      'isLiked': false,
    },
  ];

  static const _topics = ['全部', '美食', '出行', '日常', '运动', '学习'];

  @override
  Widget build(BuildContext context) {
    final filteredFeeds = _feedList.where((feed) {
      if (_userManager.isUserBlocked(feed['name'] as String)) return false;
      if (_topic != '全部' && feed['topic'] != _topic) return false;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F2),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PublishPostScreen()),
          );
        },
        backgroundColor: const Color(0xFFE85A7A),
        icon: const Icon(Icons.edit_rounded, color: Colors.white),
        label: const Text('发动态', style: TextStyle(color: Colors.white)),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            backgroundColor: Colors.white,
            elevation: 0,
            toolbarHeight: 58,
            titleSpacing: 16,
            title: const Text(
              '发现',
              style: TextStyle(
                color: Color(0xFF1A1A1A),
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.search_rounded, color: Colors.grey[700]),
              ),
              const SizedBox(width: 4),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: _topics.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final t = _topics[i];
                        final on = _topic == t;
                        return GestureDetector(
                          onTap: () => setState(() => _topic = t),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: on ? const Color(0xFFE85A7A) : const Color(0xFFF5F3F1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              t,
                              style: TextStyle(
                                color: on ? Colors.white : const Color(0xFF555555),
                                fontSize: 13,
                                fontWeight: on ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '最近活跃',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 78,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: _feedList.length > 8 ? 8 : _feedList.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 14),
                      itemBuilder: (context, i) {
                        final f = _feedList[i];
                        return GestureDetector(
                          onTap: () {
                            final stats = {
                              'followers': '${10 + i * 7}',
                              'following': '${5 + i * 3}',
                              'likes': '${50 + i * 19}',
                            };
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UserProfileScreen(
                                  avatar: f['avatar'] as String,
                                  name: f['name'] as String,
                                  signature: '偶尔发点日常',
                                  followers: stats['followers']!,
                                  following: stats['following']!,
                                  likes: stats['likes']!,
                                  mainFeed: f,
                                ),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: 58,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFE85A7A),
                                      width: 2,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundImage: AssetImage(f['avatar'] as String),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  f['name'] as String,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF555555)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (filteredFeeds.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text('这一类暂时还没有内容', style: TextStyle(color: Colors.grey[400])),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 88),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final feed = filteredFeeds[index];
                    final originalIndex = _feedList.indexOf(feed);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _buildFeedCard(
                        context: context,
                        feedId: feed['id'] as String,
                        feedIndex: originalIndex,
                        avatar: feed['avatar'] as String,
                        name: feed['name'] as String,
                        time: feed['time'] as String,
                        content: feed['content'] as String,
                        images: List<String>.from(feed['images'] as List),
                        likes: feed['likes'] as int,
                        comments: feed['comments'] as int,
                        isLiked: feed['isLiked'] as bool,
                      ),
                    );
                  },
                  childCount: filteredFeeds.length,
                ),
              ),
            ),
        ],
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
                      UserManager().blockUser(userName);
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
                  setState(() {
                    _feedList.removeAt(feedIndex);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('已屏蔽该动态'),
                      backgroundColor: const Color(0xFFC94A5A),
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
                  color: color.withValues(alpha: 0.1),
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
              onConfirm?.call();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(successMessage),
                  backgroundColor: const Color(0xFFC94A5A),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: const Text(
              '确定',
              style: TextStyle(color: Color(0xFFC94A5A)),
            ),
          ),
        ],
      ),
    );
  }
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final List<Map<String, dynamic>> _notesList = [
    {
      'id': 'note1',
      'time': '14:30',
      'date': '2月5日',
      'mood': '🙂',
      'title': '新店咖啡',
      'content': '点了美式，偏酸。座位靠窗，能看到路口红绿灯。坐了四十分钟，把邮件回完了。',
      'images': ['assets/feed/coffee_note.jpg', 'assets/feed/coffee2.jpg'],
      'tag': '咖啡',
    },
    {
      'id': 'note2',
      'time': '21:05',
      'date': '2月4日',
      'mood': '😮‍💨',
      'title': '夜跑半圈',
      'content': '本来想跑五公里，两公里就停了。回去冲了澡，比坐着刷手机强一点。',
      'images': ['assets/feed/jogging.jpg', 'assets/feed/rain.jpg'],
      'tag': '运动',
    },
    {
      'id': 'note3',
      'time': '16:12',
      'date': '2月3日',
      'mood': '😌',
      'title': '翻了几页书',
      'content': '《月亮与六便士》看到中间。主人公有点决绝，看得我不太舒服，但还是想看完。',
      'images': ['assets/feed/book.jpg', 'assets/feed/library2.jpg'],
      'tag': '阅读',
    },
    {
      'id': 'note4',
      'time': '09:40',
      'date': '2月1日',
      'mood': '😶',
      'title': '周末打算',
      'content': '想去海边，看预报可能下雨。不去也行，在家把阳台衣服收了。',
      'images': ['assets/feed/weekend.jpg', 'assets/feed/note_home.jpg'],
      'tag': '计划',
    },
    {
      'id': 'note5',
      'time': '19:20',
      'date': '1月28日',
      'mood': '🙂',
      'title': '阳台绿意',
      'content': '新买的绿萝搬上来了，浇水浇多了一次，托盘积水。下次少倒点。',
      'images': ['assets/feed/plants.jpg', 'assets/feed/balcony.jpg'],
      'tag': '家',
    },
    {
      'id': 'note6',
      'time': '22:10',
      'date': '1月25日',
      'mood': '😴',
      'title': '加班收尾',
      'content': '项目差不多交了，键盘敲到发烫。明天补觉，今晚先把自己哄睡。',
      'images': ['assets/feed/nightcode.jpg', 'assets/feed/desk.jpg'],
      'tag': '工作',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F2),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PublishNoteScreen()),
          );
        },
        backgroundColor: const Color(0xFFE85A7A),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE85A7A), Color(0xFFC94A5A)],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '时光',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '把日子翻成可以回看的页',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.88),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          _headerStat('${_notesList.length}', '篇笔记'),
                          const SizedBox(width: 10),
                          _headerStat('${_photoCount()}', '张照片'),
                          const SizedBox(width: 10),
                          _headerStat('${_notesList.length}', '个标签'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final note = _notesList[index];
                  return _buildNoteCard(context, index, note);
                },
                childCount: _notesList.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _photoCount() {
    var total = 0;
    for (final n in _notesList) {
      final imgs = n['images'];
      if (imgs is List) total += imgs.length;
    }
    return total;
  }

  Widget _headerStat(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteCard(BuildContext context, int noteIndex, Map<String, dynamic> note) {
    final images = List<String>.from(note['images'] as List);
    final cover = images.isNotEmpty ? images.first : 'assets/feed/desk.jpg';
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteDetailScreen(
              time: note['time'],
              date: note['date'],
              mood: note['mood'],
              title: note['title'],
              content: note['content'],
              images: images,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 10,
                  child: AppImage(cover, fit: BoxFit.cover),
                ),
                Positioned(
                  left: 12,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${note['mood']} ${note['tag']}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: IconButton(
                    onPressed: () => _showDeleteDialog(context, note['title'] as String, noteIndex),
                    icon: const Icon(Icons.delete_outline, color: Colors.white, size: 20),
                    style: IconButton.styleFrom(backgroundColor: Colors.black38),
                  ),
                ),
                if (images.length > 1)
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '1/${images.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${note['date']} · ${note['time']}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    note['title'] as String,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    note['content'] as String,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, height: 1.5, color: Colors.grey[700]),
                  ),
                  if (images.length > 1) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 64,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, i) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: AppImage(images[i], width: 64, height: 64, fit: BoxFit.cover),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String title, int noteIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('删除笔记', style: TextStyle(fontWeight: FontWeight.w600)),
        content: Text('确定要删除「$title」吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消', style: TextStyle(color: Colors.grey[600])),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _notesList.removeAt(noteIndex));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('笔记已删除'),
                  backgroundColor: const Color(0xFFC94A5A),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

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
  
  final List<Map<String, dynamic>> _myRecentFeeds = [
    {
      'id': 'my1',
      'time': '20分钟前',
      'content': '咖啡馆角落有只橘猫，踩了我鞋两脚。店员说它不让摸，结果它自己跳上我腿。',
      'images': ['assets/feed/cat1.jpg', 'assets/feed/cat2.jpg', 'assets/feed/coffee_meet.jpg'],
      'likes': 17,
      'comments': 4,
    },
    {
      'id': 'my2',
      'time': '今天早上',
      'content': '提拉米苏失败了，奶油化了。下次少放朗姆酒。',
      'images': ['assets/feed/tiramisu.jpg', 'assets/feed/cake2.jpg'],
      'likes': 5,
      'comments': 2,
    },
    {
      'id': 'my3',
      'time': '昨天',
      'content': '偶遇同学，聊了一会儿工作。各请一杯，分开时都说下次再约。',
      'images': ['assets/feed/coffee_meet.jpg', 'assets/feed/coffee2.jpg'],
      'likes': 9,
      'comments': 1,
    },
    {
      'id': 'my4',
      'time': '前天',
      'content': '阳台多摆了两盆绿萝。早上浇水浇多了，托盘溢出来一圈。',
      'images': ['assets/feed/plants.jpg', 'assets/feed/balcony.jpg'],
      'likes': 11,
      'comments': 3,
    },
    {
      'id': 'my5',
      'time': '上周',
      'content': '夜跑三次，第三次下雨中途回去了。记录一下，免得忘。',
      'images': ['assets/feed/jogging.jpg', 'assets/feed/rain.jpg'],
      'likes': 2,
      'comments': 0,
    },
    {
      'id': 'my6',
      'time': '上周',
      'content': '下雪那天早起拍了一张，又回去睡了。',
      'images': ['assets/feed/snow.jpg'],
      'likes': 8,
      'comments': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F2),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: AppImage('assets/home/cover_me.jpg', fit: BoxFit.cover),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 80,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0x99000000)],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _topIcon(Icons.account_balance_wallet_outlined, () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const MolianStoreView()),
                          );
                          setState(() {});
                        }),
                        const SizedBox(width: 8),
                        _topIcon(Icons.chat_bubble_outline, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AIAssistantScreen()),
                          );
                        }),
                        const SizedBox(width: 8),
                        _topIcon(Icons.settings_outlined, () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SettingsScreen()),
                          );
                          if (result != null && mounted) {
                            _userManager.updateUserInfo(
                              nickname: result['nickname'],
                              signature: result['signature'],
                              avatarPath: result['avatarPath'],
                            );
                            setState(() {});
                          }
                        }),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: -36,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 42,
                      backgroundImage: _avatarProvider(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 48, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _userManager.nickname,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _userManager.signature,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      _buildStatItem('42', '粉丝'),
                      _buildStatItem('38', '关注'),
                      _buildStatItem('186', '获赞'),
                      _buildStatItem('${_myRecentFeeds.length}', '动态'),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: _actionChip(Icons.edit_outlined, '编辑资料', () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SettingsScreen()),
                          );
                          if (result != null && mounted) {
                            _userManager.updateUserInfo(
                              nickname: result['nickname'],
                              signature: result['signature'],
                              avatarPath: result['avatarPath'],
                            );
                            setState(() {});
                          }
                        }),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _actionChip(Icons.chat_bubble_outline, '找小探聊聊', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AIAssistantScreen()),
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    '我的相册',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '点开看看最近发过的图',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.82,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final feed = _myRecentFeeds[index];
                  final images = List<String>.from(feed['images'] as List);
                  final cover = images.first;
                  return GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailScreen(
                            avatar: _userManager.avatarPathOrDefault,
                            name: _userManager.nickname,
                            time: feed['time'],
                            content: feed['content'],
                            images: images,
                            likes: feed['likes'],
                            comments: feed['comments'],
                            isLiked: true,
                            isMyPost: true,
                          ),
                        ),
                      );
                      if (result != null && result['deleted'] == true && mounted) {
                        setState(() => _myRecentFeeds.removeAt(index));
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          AppImage(cover, fit: BoxFit.cover),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(10, 24, 10, 10),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Color(0xB3000000)],
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    feed['content'] as String,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      height: 1.35,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.favorite, size: 12, color: Color(0xFFFF8FA3)),
                                      const SizedBox(width: 3),
                                      Text(
                                        '${feed['likes']}',
                                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                                      ),
                                      const Spacer(),
                                      if (images.length > 1)
                                        Text(
                                          '${images.length}图',
                                          style: const TextStyle(color: Colors.white70, fontSize: 11),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: _myRecentFeeds.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider _avatarProvider() {
    final path = _userManager.avatarPath;
    if (path != null && path.isNotEmpty) {
      return FileImage(File(path));
    }
    return const AssetImage('assets/images/default_avatar.jpg');
  }

  Widget _topIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _actionChip(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEDE8E4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: const Color(0xFFE85A7A)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildStatItem(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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
              color: const Color(0xFFC94A5A).withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              color: Color(0xFF333333),
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildImageGrid(images),
          const SizedBox(height: 12),
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
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: AppImage(
            images[0],
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (images.length == 2) {
      return SizedBox(
        height: 176,
        child: Row(
          children: images
              .map((url) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: url == images.last ? 0 : 8,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: AppImage(
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
            child: AppImage(
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
              setState(() {
                _myRecentFeeds.removeAt(feedIndex);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('动态已删除'),
                  backgroundColor: const Color(0xFFC94A5A),
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
    
    final likes = 50 + random.nextInt(9950);
    
    return {
      'followers': followers.toString(),
      'following': following.toString(),
      'likes': likes.toString(),
    };
  }

  String _generateUserSignature(String name) {
    final signatures = [
      '偶尔发点日常',
      '在吃，别叫我',
      '周末一般不出门',
      '下班路上随便拍',
      '想养只猫还在纠结',
      '坐标南方，怕冷',
      '球打得一般',
      '咖啡只喝美式',
      '最近在学做饭',
      '别私信推销',
      '晚睡晚期患者',
      '有事留言',
      '不接广告',
      '偶尔回消息',
      '路过看看',
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
              color: const Color(0xFFC94A5A).withValues(alpha: 0.08),
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
          child: AppImage(
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
                        child: AppImage(
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
            child: AppImage(
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
                    colors: [Color(0xFFC94A5A), Color(0xFFE07A6A), Color(0xFFEBA89A)],
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
