import 'package:flutter/material.dart';
import 'widgets/app_image.dart';
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

  List<Map<String, dynamic>> _generateUserFeeds() {
    final feeds = <Map<String, dynamic>>[];
    
    if (widget.mainFeed != null) {
      feeds.add({
        'time': widget.mainFeed!['time'],
        'content': widget.mainFeed!['content'],
        'images': List<String>.from(widget.mainFeed!['images']),
        'likes': widget.mainFeed!['likes'],
        'comments': widget.mainFeed!['comments'],
      });
    }
    
    final seed = widget.name.hashCode.abs();
    final random = _SeededRandom(seed);
    
    final contentPool = [
      {'content': '周末爬了半座山，膝盖有点抗议。下山买了瓶冰汽水。', 'images': ['assets/feed/hike1.jpg', 'assets/feed/hike2.jpg']},
      {'content': '咖啡馆碰到以前同学，聊了半小时工作，各请一杯就走了。', 'images': ['assets/feed/coffee_meet.jpg']},
      {'content': '阳台多了两盆绿萝，浇水浇多了，托盘积水。', 'images': ['assets/feed/plants.jpg']},
      {'content': '夜跑两公里就停了。至少出门了。', 'images': ['assets/feed/jogging.jpg']},
      {'content': '折了只纸鹤，翅膀一边高一边低。', 'images': ['assets/feed/origami.jpg']},
      {'content': '情绪一般，去江边转了转。风挺大。', 'images': ['assets/feed/river1.jpg']},
      {'content': '商场逛了一圈，只买了双袜子。', 'images': ['assets/feed/socks.jpg']},
      {'content': '炒了三个菜，最后一个糊了，朋友还是吃完了。', 'images': ['assets/feed/cooking.jpg']},
      {'content': '图书馆角落座位，耳机白噪音，效率还行。', 'images': ['assets/feed/library.jpg']},
      {'content': '天桥上看见晚霞，站了一会儿才想起拍照。', 'images': ['assets/feed/sunset.jpg']},
      {'content': '蛋糕塌了半边，室友说能吃就行。', 'images': ['assets/feed/cake.jpg']},
      {'content': '同事婚礼，空调太冷，披了外套。', 'images': ['assets/feed/wedding1.jpg', 'assets/feed/wedding2.jpg']},
      {'content': '驾照科目四过了。教练人挺好。', 'images': ['assets/feed/driving.jpg']},
      {'content': '早上窗外在下雪，拍了一张就回去睡了。', 'images': ['assets/feed/snow.jpg']},
      {'content': '项目收尾，半夜才合上电脑。明天补觉。', 'images': ['assets/feed/nightcode.jpg']},
      {'content': '羽毛球双打输了，下次换搭档。', 'images': ['assets/feed/badminton.jpg']},
      {'content': '报告交了，奶茶店写错我名字。', 'images': ['assets/feed/milktea.jpg']},
      {'content': '下雨天去吃馄饨，老板还记得我多加葱。', 'images': ['assets/feed/wonton.jpg']},
    ];
    
    final timePool = ['2小时前', '3小时前', '5小时前', '8小时前', '昨天', '2天前', '3天前'];
    
    final extraCount = 2 + random.nextInt(2);
    final selectedIndices = <int>{};
    
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
      backgroundColor: const Color(0xFFFAF8F6),
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
                      const Color(0xFFF5F3F1).withValues(alpha: 0.3),
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
                          color: const Color(0xFFC94A5A).withValues(alpha: 0.08),
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
                                    colors: [Color(0xFFC94A5A), Color(0xFFE07A6A)],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFC94A5A).withValues(alpha: 0.3),
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
                                    backgroundColor: const Color(0xFFC94A5A),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isFollowing ? Colors.grey[200] : const Color(0xFFC94A5A),
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
      return AppImage(imagePath, fit: BoxFit.cover);
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
                  backgroundColor: const Color(0xFFC94A5A),
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
              style: TextStyle(color: Color(0xFFC94A5A)),
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
