import 'package:flutter/material.dart';
import 'user_manager.dart';

class PostDetailScreen extends StatefulWidget {
  final String avatar;
  final String name;
  final String time;
  final String content;
  final List<String> images;
  final int likes;
  final int comments;
  final bool isLiked;
  final bool isMyPost;

  const PostDetailScreen({
    super.key,
    required this.avatar,
    required this.name,
    required this.time,
    required this.content,
    required this.images,
    required this.likes,
    required this.comments,
    required this.isLiked,
    this.isMyPost = false,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> with TickerProviderStateMixin {
  final UserManager _userManager = UserManager();
  late bool _isLiked;
  late int _likesCount;
  late bool _isFollowing;
  final TextEditingController _commentController = TextEditingController();
  late AnimationController _likeAnimationController;
  late AnimationController _followAnimationController;
  late Animation<double> _likeScaleAnimation;
  late Animation<double> _followScaleAnimation;
  
  late List<Map<String, dynamic>> _commentsList;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _likesCount = widget.likes;
    _isFollowing = false;
    
    // 监听用户信息变化（包括头像变化）
    _userManager.addListener(_onUserInfoChanged);
    
    // 根据动态内容生成不同的评论
    _commentsList = _generateComments();
    
    // 点赞动画控制器
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
    
    // 关注动画控制器
    _followAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _followScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.9),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.9, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(
      parent: _followAnimationController,
      curve: Curves.easeInOut,
    ));
  }
  
  // 生成随机评论
  List<Map<String, dynamic>> _generateComments() {
    final allComments = <Map<String, String>>[
      {'name': '阿杰', 'avatar': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop', 'content': '太棒了！我也想去试试'},
      {'name': '林晓风', 'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop', 'content': '看起来很不错呢'},
      {'name': '小鹿', 'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop', 'content': '好羡慕啊！'},
      {'name': '江南烟雨', 'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop', 'content': '拍得真好看'},
      {'name': '北辰', 'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop', 'content': '这个地方在哪里？'},
      {'name': '柠檬茶', 'avatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&h=100&fit=crop', 'content': '好想去打卡'},
      {'name': '星河', 'avatar': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100&h=100&fit=crop', 'content': '有没有攻略分享？'},
      {'name': '温柔一刀', 'avatar': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&h=100&fit=crop', 'content': '太美了！'},
      {'name': '云朵', 'avatar': 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=100&h=100&fit=crop', 'content': '下次一起去'},
      {'name': '月下独酌', 'avatar': 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=100&h=100&fit=crop', 'content': '好喜欢这种风格'},
      {'name': '清风', 'avatar': 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=100&h=100&fit=crop', 'content': '拍照技术一流'},
      {'name': '樱桃小丸子', 'avatar': 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=100&h=100&fit=crop', 'content': '好想拥有同款'},
      {'name': '时光', 'avatar': 'https://images.unsplash.com/photo-1531427186611-ecfd6d936c79?w=100&h=100&fit=crop', 'content': '这也太赞了吧'},
      {'name': '南风知我意', 'avatar': 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=100&h=100&fit=crop', 'content': '求详细地址'},
      {'name': '浅笑', 'avatar': 'https://images.unsplash.com/photo-1519345182560-3f2917c472ef?w=100&h=100&fit=crop', 'content': '已收藏！'},
      {'name': '墨染青衣', 'avatar': 'https://images.unsplash.com/photo-1502685104226-ee32379fefbe?w=100&h=100&fit=crop', 'content': '好治愈啊'},
      {'name': '晨曦', 'avatar': 'https://images.unsplash.com/photo-1504257432389-52343af06ae3?w=100&h=100&fit=crop', 'content': '这个角度绝了'},
      {'name': '花开半夏', 'avatar': 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=100&h=100&fit=crop', 'content': '好想去体验一下'},
      {'name': '陌上', 'avatar': 'https://images.unsplash.com/photo-1507081323647-4d250478b919?w=100&h=100&fit=crop', 'content': '太有感觉了'},
      {'name': '烟雨蒙蒙', 'avatar': 'https://images.unsplash.com/photo-1521119989659-a83eee488004?w=100&h=100&fit=crop', 'content': '爱了爱了'},
    ];
    
    final times = ['刚刚', '2分钟前', '5分钟前', '10分钟前', '15分钟前', '30分钟前', '1小时前', '2小时前'];
    
    // 使用动态内容的哈希值作为随机种子，确保同一条动态总是显示相同的评论
    final seed = widget.content.hashCode.abs();
    final random = _SeededRandom(seed);
    
    // 使用传入的评论数量，确保与动态页显示的数量一致
    final commentCount = widget.comments;
    final selectedIndices = <int>{};
    
    while (selectedIndices.length < commentCount && selectedIndices.length < allComments.length) {
      selectedIndices.add(random.nextInt(allComments.length));
    }
    
    return selectedIndices.map((index) {
      final comment = allComments[index];
      return <String, dynamic>{
        'avatar': comment['avatar']!,
        'name': comment['name']!,
        'time': times[random.nextInt(times.length)],
        'content': comment['content']!,
      };
    }).toList();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _likeAnimationController.dispose();
    _followAnimationController.dispose();
    _userManager.removeListener(_onUserInfoChanged);
    super.dispose();
  }
  
  // 当用户信息变化时（包括头像），更新评论列表中的头像
  void _onUserInfoChanged() {
    setState(() {
      // 更新评论列表中当前用户的头像
      for (var comment in _commentsList) {
        if (comment['name'] == _userManager.nickname) {
          comment['avatar'] = _userManager.avatarPathOrDefault;
        }
      }
    });
  }

  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return AssetImage(imagePath);
    } else {
      return NetworkImage(imagePath);
    }
  }

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
          '动态详情',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          if (widget.isMyPost)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _showDeleteDialog(context),
            )
          else
            IconButton(
              icon: const Icon(Icons.more_horiz, color: Colors.black87),
              onPressed: () => _showOthersPostMenu(context),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildPostContent(),
                  const SizedBox(height: 12),
                  _buildCommentSection(),
                ],
              ),
            ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildPostContent() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 用户信息
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: _getImageProvider(widget.avatar),
              ),
              const SizedBox(width: 12),
              Expanded(
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
              if (!widget.isMyPost)
                ScaleTransition(
                  scale: _followScaleAnimation,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFollowing = !_isFollowing;
                      });
                      _followAnimationController.forward(from: 0);
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
                ),
            ],
          ),
          const SizedBox(height: 16),
          // 内容
          Text(
            widget.content,
            style: const TextStyle(
              color: Color(0xFF333333),
              fontSize: 16,
              height: 1.6,
            ),
          ),
          if (widget.images.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildImageGrid(widget.images),
          ],
          const SizedBox(height: 16),
          // 互动按钮
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ScaleTransition(
                  scale: _likeScaleAnimation,
                  child: _buildActionButton(
                    icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                    label: '$_likesCount',
                    color: _isLiked ? Colors.pink : Colors.grey[600]!,
                    onTap: () {
                      setState(() {
                        _isLiked = !_isLiked;
                        _likesCount += _isLiked ? 1 : -1;
                      });
                      _likeAnimationController.forward(from: 0);
                    },
                  ),
                ),
                _buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: '${widget.comments}',
                  color: Colors.grey[600]!,
                  onTap: () {
                    // 聚焦到评论输入框
                  },
                ),
              ],
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
          fit: BoxFit.cover,
        ),
      );
    } else if (images.length == 2) {
      return SizedBox(
        height: 180,
        child: Row(
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

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '评论 ${widget.comments}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ..._commentsList.map((comment) => _buildCommentItem(comment)),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: _getImageProvider(comment['avatar'] as String),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment['name'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      comment['time'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  comment['content'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FD),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: '说点什么...',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  style: const TextStyle(fontSize: 14),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      setState(() {
                        _commentsList.insert(0, <String, dynamic>{
                          'avatar': _userManager.avatarPathOrDefault,
                          'name': _userManager.nickname,
                          'time': '刚刚',
                          'content': value.trim(),
                        });
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('评论已发送'),
                          backgroundColor: const Color(0xFF9D31FF),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                      _commentController.clear();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                if (_commentController.text.trim().isNotEmpty) {
                  setState(() {
                    _commentsList.insert(0, {
                      'avatar': _userManager.avatarPathOrDefault,
                      'name': _userManager.nickname,
                      'time': '刚刚',
                      'content': _commentController.text.trim(),
                    });
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('评论已发送'),
                      backgroundColor: const Color(0xFF9D31FF),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                  _commentController.clear();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9D31FF), Color(0xFFF260FF)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOthersPostMenu(BuildContext context) {
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
                      _userManager.blockUser(widget.name);
                    },
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
                  Navigator.pop(context); // 关闭底部菜单
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('已屏蔽该动态'),
                      backgroundColor: const Color(0xFF9D31FF),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                  // 延迟一下再返回，让用户看到提示
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (mounted) {
                      Navigator.pop(context, {'blocked': true}); // 返回屏蔽标记
                    }
                  });
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
              // 如果是拉黑操作，延迟后返回
              if (title == '拉黑用户') {
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (mounted) {
                    Navigator.pop(context, {'blocked': true});
                  }
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

  void _showDeleteDialog(BuildContext context) {
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
              Navigator.pop(context); // 关闭对话框
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('动态已删除'),
                  backgroundColor: const Color(0xFF9D31FF),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
              // 延迟后返回删除标记
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  Navigator.pop(context, {'deleted': true}); // 返回删除标记
                }
              });
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

// 简单的伪随机数生成器，使用种子确保可重复性
class _SeededRandom {
  int _seed;
  
  _SeededRandom(this._seed);
  
  int nextInt(int max) {
    _seed = ((_seed * 1103515245 + 12345) & 0x7fffffff);
    return _seed % max;
  }
}
