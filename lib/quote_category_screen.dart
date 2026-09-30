import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/app_image.dart';

class QuoteCategoryScreen extends StatelessWidget {
  final String categoryId;
  final String title;
  final String cover;

  const QuoteCategoryScreen({
    super.key,
    required this.categoryId,
    required this.title,
    required this.cover,
  });

  List<String> get _quotes {
    switch (categoryId) {
      case 'love':
        return [
          '今天过得普通，但也值得记一笔。',
          '没什么大事，就是想留个痕迹。',
          '这一刻挺安静的，适合写两句。',
          '天气一般，心情还行，先这样。',
          '小事情堆起来，也算过日子。',
          '不想总结人生，只想记下晚饭。',
          '状态一般，但饭还是好好吃了。',
          '把今天收到口袋里，明天再说。',
        ];
      case 'fun':
        return [
          '计划很多，执行了吃饭这一项。',
          '本来想勤奋，最后选择躺平十分钟。',
          '今日份摸鱼已完成，进度条拉满。',
          '不是没灵感，是灵感在排队。',
          '写动态比写周报轻松多了。',
          '相机里又多了一张说不清的图。',
          '生活偶尔翻车，记录一下当纪念。',
          '今天的主角是咖啡，我只是路过。',
        ];
      case 'famous':
        return [
          '慢一点也没关系，日子还长。',
          '先把自己安顿好，别的稍后。',
          '小事做好，大事反而会清楚些。',
          '不用每天精彩，清楚过完就行。',
          '留白也是一天的一部分。',
          '走神的时候，往往最像自己。',
          '把期待调小一格，轻松很多。',
          '今天够用就好，不用很圆满。',
        ];
      case 'night':
      default:
        return [
          '今天到这，关灯睡觉。',
          '事情没做完也先休息，明天再续。',
          '把手机扣下，把今天放下。',
          '夜深了，记下这一笔就收工。',
          '没有大结局，只有今天结束。',
          '枕头比待办清单更重要。',
          '先睡，梦里不许加班。',
          '晚安，明天继续过小日子。',
        ];
    }
  }

  Future<void> _copy(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('已复制'),
        backgroundColor: const Color(0xFFC94A5A),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1200),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quotes = _quotes;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F2),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 6)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  AppImage(cover, fit: BoxFit.cover),
                  Container(color: Colors.black.withValues(alpha: 0.32)),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final text = quotes[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => _copy(context, text),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  text,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.55,
                                    color: Color(0xFF2A2A2A),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.copy_rounded,
                                size: 18,
                                color: Colors.grey[400],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: quotes.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
