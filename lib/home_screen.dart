import 'dart:async';
import 'package:flutter/material.dart';
import 'widgets/app_image.dart';
import 'quote_category_screen.dart';
import 'banner_detail_screen.dart';
import 'moment_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _bannerController = PageController(viewportFraction: 0.92);
  int _bannerIndex = 0;
  Timer? _bannerTimer;

  static const _banners = [
    {
      'image': 'assets/home/banner1.jpg',
      'title': '把今天的一餐一景，随手记下来',
      'body': '探友用来放下那些不太想发朋友圈、又舍不得忘的小事。',
    },
    {
      'image': 'assets/home/banner2.jpg',
      'title': '夜里刷一刷，看看别人怎么过这一天',
      'body': '发现页里都是普通人的片段，看着看着，自己也想写两句。',
    },
    {
      'image': 'assets/home/banner3.jpg',
      'title': '写得真实一点，比写得很漂亮更有用',
      'body': '累了就说累，开心就说开心。少一点表演，多一点人话。',
    },
  ];

  static const _quoteCats = [
    {
      'id': 'love',
      'title': '心情便签',
      'hint': '点进复制到动态里',
      'cover': 'assets/home/quote_love.jpg',
    },
    {
      'id': 'fun',
      'title': '轻松一句',
      'hint': '发动态不知道写啥时用',
      'cover': 'assets/home/quote_fun.jpg',
    },
    {
      'id': 'famous',
      'title': '短句备用',
      'hint': '配图时随手贴一句',
      'cover': 'assets/home/quote_famous.jpg',
    },
    {
      'id': 'night',
      'title': '今日收尾',
      'hint': '睡前记一笔也好',
      'cover': 'assets/home/quote_night.jpg',
    },
  ];

  static const _moments = [
    {
      'image': 'assets/home/m1.jpg',
      'title': '夜色里并肩',
      'caption': '车灯拖成一条线，这一段路值得记下来。',
    },
    {
      'image': 'assets/home/m2.jpg',
      'title': '镜子前的自己',
      'caption': '今天状态一般，但还是把日子过完了。',
    },
    {
      'image': 'assets/home/m3.jpg',
      'title': '雨后街道',
      'caption': '地面反着灯，空气闻起来干净一点。',
    },
    {
      'image': 'assets/home/m4.jpg',
      'title': '午后咖啡',
      'caption': '杯子凉了也没关系，坐着发一会儿呆。',
    },
    {
      'image': 'assets/feed/sunset.jpg',
      'title': '天桥晚霞',
      'caption': '下班路过，橘色光把玻璃染亮了一层。',
    },
    {
      'image': 'assets/feed/hike1.jpg',
      'title': '山顶一阵风',
      'caption': '腿已经不是自己的了，风景还算对得起。',
    },
    {
      'image': 'assets/feed/cat1.jpg',
      'title': '店里的橘猫',
      'caption': '说不让摸，结果自己跳上腿。',
    },
    {
      'image': 'assets/feed/plants.jpg',
      'title': '阳台一点绿',
      'caption': '浇水浇多了，至少阳台活过来了。',
    },
    {
      'image': 'assets/feed/river1.jpg',
      'title': '江边走走',
      'caption': '风有点大，帽子差点跑掉，心情松了些。',
    },
    {
      'image': 'assets/feed/coffee_note.jpg',
      'title': '靠窗座位',
      'caption': '美式偏酸，邮件回完了，人也坐稳了。',
    },
    {
      'image': 'assets/feed/weekend.jpg',
      'title': '想去海边',
      'caption': '预报说有雨，不去也行，心里先摆一张沙滩。',
    },
    {
      'image': 'assets/feed/snow.jpg',
      'title': '早起看雪',
      'caption': '拍了一张又缩回被窝，冬天就该这样。',
    },
    {
      'image': 'assets/feed/jogging.jpg',
      'title': '夜跑半圈',
      'caption': '计划五公里，两公里收工，出门就算赢。',
    },
    {
      'image': 'assets/feed/book.jpg',
      'title': '翻了几页',
      'caption': '书看到一半，人不太舒服，但还想看完。',
    },
    {
      'image': 'assets/feed/cake.jpg',
      'title': '塌了一半',
      'caption': '烤箱第二次用，卖相一般，味道勉强过关。',
    },
    {
      'image': 'assets/feed/rain.jpg',
      'title': '雨天出门',
      'caption': '伞面滴答响，适合找家老店坐一会儿。',
    },
    {
      'image': 'assets/feed/library.jpg',
      'title': '角落座位',
      'caption': '耳机白噪音，效率意外还行。',
    },
    {
      'image': 'assets/feed/balcony.jpg',
      'title': '收衣服的午后',
      'caption': '阳台风干得快，日子也跟着松一点。',
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
        if (!mounted || !_bannerController.hasClients) return;
        final next = (_bannerIndex + 1) % _banners.length;
        _bannerController.animateToPage(
          next,
          duration: const Duration(milliseconds: 380),
          curve: Curves.easeOut,
        );
      });
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F2),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _sectionTitle('今日一瞥')),
            SliverToBoxAdapter(child: _buildBanner()),
            SliverToBoxAdapter(child: _sectionTitle('文案灵感')),
            SliverToBoxAdapter(child: _buildQuoteRow()),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            SliverToBoxAdapter(child: _sectionTitle('生活碎片')),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.78,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildMomentCard(_moments[index]),
                  childCount: _moments.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A1A1A),
          height: 1.2,
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: _banners.length,
            onPageChanged: (i) => setState(() => _bannerIndex = i),
            itemBuilder: (context, index) {
              final item = _banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BannerDetailScreen(
                          image: item['image']!,
                          title: item['title']!,
                          body: item['body']!,
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        AppImage(item['image']!, fit: BoxFit.cover),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(16, 28, 16, 14),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Color(0x99000000)],
                              ),
                            ),
                            child: Text(
                              item['title']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (i) {
            final active = i == _bannerIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 8 : 6,
              height: active ? 8 : 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active
                    ? const Color(0xFFE85A7A)
                    : const Color(0x33E85A7A),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildQuoteRow() {
    return SizedBox(
      height: 168,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _quoteCats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final cat = _quoteCats[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuoteCategoryScreen(
                    categoryId: cat['id']!,
                    title: cat['title']!,
                    cover: cat['cover']!,
                  ),
                ),
              );
            },
            child: Container(
              width: 128,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        AppImage(cat['cover']!, fit: BoxFit.cover),
                        Container(color: Colors.black.withValues(alpha: 0.28)),
                        Center(
                          child: Text(
                            cat['title']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cat['title']!,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF222222),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          cat['hint']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMomentCard(Map<String, String> item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MomentDetailScreen(
              image: item['image']!,
              title: item['title']!,
              caption: item['caption']!,
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AppImage(item['image']!, fit: BoxFit.cover),
      ),
    );
  }
}
