import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/review.dart';
import '../services/supabase_service.dart';

class ReviewCard extends StatefulWidget {
  final Review review;

  const ReviewCard({super.key, required this.review});

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  late bool _isLiked;
  late int _likesCount;
  bool _showReplies = false;
  bool _isLoadingReplies = false;
  List<Map<String, dynamic>> _replies = [];
  final _replyCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isLiked = widget.review.isLikedByMe;
    _likesCount = widget.review.likesCount;
  }

  Future<void> _toggleLike() async {
    // Optimistic UI update
    setState(() {
      _isLiked = !_isLiked;
      _isLiked ? _likesCount++ : _likesCount--;
    });
    try {
      await context.read<SupabaseService>().toggleLike(widget.review.id, _isLiked);
    } catch (e) {
      // revert UI on error
      if (mounted) {
        setState(() {
          _isLiked = !_isLiked;
          _isLiked ? _likesCount++ : _likesCount--;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao curtir: $e')));
      }
    }
  }

  Future<void> _toggleReplies() async {
    setState(() {
      _showReplies = !_showReplies;
    });
    if (_showReplies && _replies.isEmpty) {
      _loadReplies();
    }
  }

  Future<void> _loadReplies() async {
    setState(() => _isLoadingReplies = true);
    final results = await context.read<SupabaseService>().getReplies(widget.review.id);
    if (mounted) {
      setState(() {
        _replies = results;
        _isLoadingReplies = false;
      });
    }
  }

  Future<void> _submitReply() async {
    if (_replyCtrl.text.trim().isEmpty) return;
    try {
      await context.read<SupabaseService>().submitReply(widget.review.id, _replyCtrl.text.trim());
      _replyCtrl.clear();
      _loadReplies();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao responder: \$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2C3440),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: widget.review.user.avatarUrl.isNotEmpty ? NetworkImage(widget.review.user.avatarUrl) : null,
                radius: 16,
                child: widget.review.user.avatarUrl.isEmpty ? const Icon(Icons.person, size: 16) : null,
              ),
              const SizedBox(width: 8),
              Text(
                widget.review.user.username,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Spacer(),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < widget.review.rating.floor() ? Icons.star : Icons.star_border,
                    color: const Color(0xFF00E054),
                    size: 16,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.review.comment,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              InkWell(
                onTap: _toggleLike,
                child: Row(
                  children: [
                    Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? Colors.red : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    const Text('Curtir', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: _toggleReplies,
                child: const Row(
                  children: [
                    Icon(Icons.chat_bubble_outline, color: Colors.grey, size: 20),
                    SizedBox(width: 4),
                    Text('Responder', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
          if (_showReplies) ...[
            const Divider(color: Colors.white24, height: 24),
            if (_isLoadingReplies)
              const Center(child: CircularProgressIndicator(color: Color(0xFF00E054)))
            else ...[
              for (var reply in _replies)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0, left: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: reply['user']['avatar_url'] != null && reply['user']['avatar_url'].isNotEmpty ? NetworkImage(reply['user']['avatar_url']) : null,
                        radius: 12,
                        child: (reply['user']['avatar_url'] == null || reply['user']['avatar_url'].isEmpty) ? const Icon(Icons.person, size: 12) : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(reply['user']['username'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
                            const SizedBox(height: 2),
                            Text(reply['content'], style: const TextStyle(color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _replyCtrl,
                        decoration: const InputDecoration(
                          hintText: 'Adicionar uma resposta...',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(),
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Color(0xFF00E054)),
                      onPressed: _submitReply,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
