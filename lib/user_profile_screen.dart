import 'package:flutter/material.dart';
import 'post_detail_screen.dart';
import 'user_manager.dart';

class UserProfileScreen extends StatefulWidget {
  final String avatar;
  final String name;
  final String signature;
  final String followers;
  final String following;
  final String likes;
  final Map<String, dynamic>? mainFeed; // 主页动态数据

  const UserProfileScreen({
    super.key,
    required this.avatar,
    required this.name,
    required this.signature,
    required this.followers,
    required this.following,
    required this.likes,
    this.mainFeed, // 可选参数
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isFollowing = false;
  late List<Map<String, dynamic>> _userFeeds;

  @override
  void initState() {
    super.initState();
    _userFeeds = _generateUserFeeds();
  }

  // 根据用户名生成不同的动态
  List<Map<String, dynamic>> _generateUserFeeds() {
    final feeds = <Map<String, dynamic>>[];
    
    // 第一条动态：如果有主页动态数据，使用它；否则生成默认动态
    if (widget.mainFeed != null) {
      feeds.add({
        'time': widget.mainFeed!['time'],
        'content': widget.mainFeed!['content'],
        'images': List<String>.from(widget.mainFeed!['images']),
        'likes': widget.mainFeed!['likes'],
        'comments': widget.mainFeed!['comments'],
      });
    }
    
    // 使用用户名的哈希值作为种子，生成不同的动态
    final seed = widget.name.hashCode.abs();
    final random = _SeededRandom(seed);
    
    // 扩展的动态内容池
    final contentPool = [
      {'content': '周末去爬山啦🏔️ 虽然累到腿软，但站在山顶看到云海的那一刻，觉得一切都值得了！', 'images': ['https://picsum.photos/seed/hike1/400/400', 'https://picsum.photos/seed/hike2/400/400']},
      {'content': '今天在咖啡馆偶遇了大学同学，聊了好久好久☕️ 时光飞逝，但友谊依旧～', 'images': ['https://picsum.photos/seed/meet1/400/400']},
      {'content': '终于把阳台改造完成了🌿 种了好多绿植，每天早上起来看到这些小生命就觉得很治愈', 'images': ['https://picsum.photos/seed/garden1/400/400', 'https://picsum.photos/seed/garden2/400/400']},
      {'content': '夜跑打卡🏃‍♀️ 从最初的坚持不了1公里，到现在轻松跑5公里，真的很有成就感！', 'images': ['https://picsum.photos/seed/run1/400/400']},
      {'content': '周末在家学做手工，第一次尝试折纸鹤，虽然有点丑但是很有成就感哈哈哈🦢', 'images': ['https://picsum.photos/seed/diy1/400/400', 'https://picsum.photos/seed/diy2/400/400']},
      {'content': '今天心情不太好，去海边走了走，看着海浪一波一波的，突然觉得什么烦恼都不算什么了🌊', 'images': ['https://picsum.photos/seed/beach1/400/400']},
      {'content': '和闺蜜们一起去逛街啦！买了好多好看的衣服，开心到飞起✨', 'images': ['https://picsum.photos/seed/shop1/400/400', 'https://picsum.photos/seed/shop2/400/400']},
      {'content': '研究新菜谱，做了一桌子菜请朋友们来吃饭🍜 大家都说好吃，太有成就感了！', 'images': ['https://picsum.photos/seed/meal1/400/400']},
      {'content': '图书馆学习ing📚 准备下个月的考试，加油加油！顺便拍了张照片记录一下', 'images': ['https://picsum.photos/seed/library1/400/400']},
      {'content': '下班路上偶遇超美的晚霞🌅 赶紧拍下来分享给大家！这个城市真的很美', 'images': ['https://picsum.photos/seed/sky1/400/400']},
      {'content': '第一次尝试做提拉米苏，虽然卖相不太好，但味道还不错！下次继续努力💪', 'images': ['https://picsum.photos/seed/tiramisu1/400/400']},
      {'content': '今天去参加了朋友的婚礼💐 看着她穿着婚纱的样子真的好美，祝福她们永远幸福！', 'images': ['https://picsum.photos/seed/wed1/400/400', 'https://picsum.photos/seed/wed2/400/400']},
      {'content': '终于拿到驾照啦🚗 从科一到科四一路过关，感谢教练的耐心指导！', 'images': ['https://picsum.photos/seed/license1/400/400']},
      {'content': '早上被闹钟吵醒，发现外面在下雪❄️ 立刻爬起来冲到阳台，好久没见过这么大的雪了！', 'images': ['https://picsum.photos/seed/winter1/400/400']},
      {'content': '加班到深夜终于完成了这个项目的最后一个模块💻 虽然累但是看到代码跑通的那一刻，所有辛苦都值得了！', 'images': ['https://picsum.photos/seed/code1/400/400']},
      {'content': '今天天气太好了！约了几个朋友去公园打羽毛球，出了一身汗，感觉整个人都轻松了😊', 'images': ['https://picsum.photos/seed/badminton1/400/400']},
      {'content': '终于把这个月的工作报告搞定了！奖励自己一杯奶茶🧋 最近加班太多了，要好好休息一下', 'images': ['https://picsum.photos/seed/tea1/400/400']},
      {'content': '早起看到窗外下雨了☔️ 突然很想喝一碗热乎乎的馄饨，于是出门找了家老店，果然没让我失望！', 'images': ['https://picsum.photos/seed/wonton1/400/400']},
    ];
    
    final timePool = ['2小时前', '3小时前', '5小时前', '8小时前', '昨天', '2天前', '3天前'];
    
    // 随机选择2-3条额外动态（确保不重复）
    final extraCount = 2 + random.nextInt(2);
    final selectedIndices = <int>{};
    
    // 如果有主页动态，需要避免选择相同的内容
    final mainContent = widget.mainFeed?['content'] as String?;
    
    while (selectedIndices.length < extraCount && selectedIndices.length < contentPool.length) {
      final index = random.nextInt(contentPool.length);
      // 确保不选择与主页动态相同的内容
      if (mainContent == null || contentPool[index]['content'] != mainContent) {
        selectedIndices.add(index);
      }
    }
    
    for (var index in selectedIndices) {
      final item = contentPool[index];
      feeds.add({
        'time': timePool[random.nextInt(timePool.length)],
        'content': item['content'],
        'images': item['images'],
        'likes': 15 + random.nextInt(30),
        'comments': 2 + random.nextInt(8),
      });
    }
    
    return feeds;
  }

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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      const Color(0xFFF8F9FD).withValues(alpha: 0.3),
                    ],
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
                          color: const Color(0xFF9D31FF).withValues(alpha: 0.08),
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
                                      color: const Color(0xFF9D31FF).withValues(alpha: 0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: _getImageWidget(widget.avatar),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // 昵称和签名
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.name,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      widget.signature,
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
                              Expanded(child: _buildStatItem(widget.followers, '粉丝')),
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
                              Expanded(child: _buildStatItem(widget.following, '关注')),
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
                              Expanded(child: _buildStatItem(widget.likes, '获赞')),
                            ],
                          ),
                        ),
                        // 关注按钮
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isFollowing = !_isFollowing;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(_isFollowing ? '已关注' : '已取消关注'),
                                    backgroundColor: const Color(0xFF9D31FF),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isFollowing ? Colors.grey[200] : const Color(0xFF9D31FF),
                                foregroundColor: _isFollowing ? Colors.grey[700] : Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: Text(
                                _isFollowing ? '已关注' : '+ 关注',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // 最近动态
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
                        ..._userFeeds.asMap().entries.map((entry) {
                          final feed = entry.value;
                          return Column(
                            children: [
                              _buildUserFeedCard(
                                context: context,
                                time: feed['time'] as String,
                                content: feed['content'] as String,
                                images: List<String>.from(feed['images']),
                                likes: feed['likes'] as int,
                                comments: feed['comments'] as int,
                              ),
                              if (entry.key < _userFeeds.length - 1) const SizedBox(height: 12),
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

  Widget _getImageWidget(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return Image.asset(imagePath, fit: BoxFit.cover);
    } else {
      return Image.network(imagePath, fit: BoxFit.cover);
    }
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

  Widget _buildUserFeedCard({
    required String time,
    required String content,
    required List<String> images,
    required int likes,
    required int comments,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(
              avatar: widget.avatar,
              name: widget.name,
              time: time,
              content: content,
              images: images,
              likes: likes,
              comments: comments,
              isLiked: false,
              isMyPost: false,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9D31FF).withValues(alpha: 0.08),
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
                    icon: Icons.favorite_border,
                    label: likes.toString(),
                    color: Colors.grey,
                  ),
                  _buildActionButton(
                    icon: Icons.chat_bubble_outline,
                    label: comments.toString(),
                    color: Colors.grey,
                  ),
                  GestureDetector(
                    onTap: () => _showReportMenu(context),
                    child: _buildActionButton(
                      icon: Icons.more_horiz,
                      label: '',
                      color: Colors.grey,
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

  void _showReportMenu(BuildContext context) {
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
                    '确定要拉黑「${widget.name}」吗？\n拉黑后将不再看到TA的任何内容',
                    '已拉黑该用户',
                    onConfirm: () {
                      // 执行拉黑操作
                      final userManager = UserManager();
                      userManager.blockUser(widget.name);
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
              onConfirm?.call(); // 执行回调
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(successMessage),
                  backgroundColor: const Color(0xFF9D31FF),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
              // 如果是拉黑操作，延迟后返回
              if (title == '拉黑用户') {
                Future.delayed(const Duration(milliseconds: 500), () {
                  Navigator.pop(context);
                });
              }
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

// 简单的伪随机数生成器，使用种子确保可重复性
class _SeededRandom {
  int _seed;
  
  _SeededRandom(this._seed);
  
  int nextInt(int max) {
    _seed = ((_seed * 1103515245 + 12345) & 0x7fffffff);
    return _seed % max;
  }
}
