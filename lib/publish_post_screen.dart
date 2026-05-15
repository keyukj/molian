import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PublishPostScreen extends StatefulWidget {
  const PublishPostScreen({super.key});

  @override
  State<PublishPostScreen> createState() => _PublishPostScreenState();
}

class _PublishPostScreenState extends State<PublishPostScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _contentController = TextEditingController();
  final List<XFile> _uploadedImages = [];
  final ImagePicker _picker = ImagePicker();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _contentController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  bool get _canPublish => _contentController.text.trim().isNotEmpty || _uploadedImages.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFF),
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: FadeTransition(
                opacity: _animationController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildContentInput(),
                    const SizedBox(height: 24),
                    _buildImageUpload(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FD),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.close, color: Colors.black87, size: 22),
                ),
              ),
              const Text(
                '发布动态',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              GestureDetector(
                onTap: _canPublish ? _publishPost : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    gradient: _canPublish
                        ? const LinearGradient(
                            colors: [Color(0xFF9D31FF), Color(0xFFF260FF), Color(0xFFFF609F)],
                          )
                        : null,
                    color: _canPublish ? null : Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: _canPublish
                        ? [
                            BoxShadow(
                              color: const Color(0xFF9D31FF).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    '发布',
                    style: TextStyle(
                      color: _canPublish ? Colors.white : Colors.grey[500],
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9D31FF).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _contentController,
            maxLines: 10,
            maxLength: 500,
            decoration: const InputDecoration(
              hintText: '分享你的生活瞬间...',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 15,
                height: 1.6,
              ),
              border: InputBorder.none,
              counterText: '',
            ),
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.black87,
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Container(
            height: 1,
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
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${_contentController.text.length}/500',
              style: TextStyle(
                fontSize: 12,
                color: _contentController.text.length > 450
                    ? Colors.red
                    : _contentController.text.length > 400
                        ? Colors.orange
                        : Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9D31FF), Color(0xFFF260FF)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.image_outlined, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Text(
              '添加图片',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '最多9张',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ..._uploadedImages.map((image) => _buildImageItem(image)),
            if (_uploadedImages.length < 9) _buildAddImageButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildImageItem(XFile image) {
    return Stack(
      children: [
        Container(
          width: 106,
          height: 106,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[100],
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9D31FF).withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(
              File(image.path),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: -6,
          right: -6,
          child: GestureDetector(
            onTap: () => setState(() => _uploadedImages.remove(image)),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 106,
        height: 106,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 2,
            style: BorderStyle.solid,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.add_photo_alternate_outlined, size: 22, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              '添加图片',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickImage() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        setState(() {
          final remainingSlots = 9 - _uploadedImages.length;
          final imagesToAdd = images.take(remainingSlots).toList();
          _uploadedImages.addAll(imagesToAdd);
        });

        if (images.length > (9 - _uploadedImages.length + images.length)) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('最多只能添加9张图片'),
                backgroundColor: const Color(0xFF9D31FF),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('选择图片失败，请重试'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  void _publishPost() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('发布成功！'),
          ],
        ),
        backgroundColor: const Color(0xFF9D31FF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    Navigator.pop(context);
  }
}
