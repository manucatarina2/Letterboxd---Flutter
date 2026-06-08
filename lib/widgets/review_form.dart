import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../services/supabase_service.dart';

class ReviewForm extends StatefulWidget {
  final Movie movie;
  final VoidCallback onSubmitted;

  const ReviewForm({super.key, required this.movie, required this.onSubmitted});

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final _commentCtrl = TextEditingController();
  double _rating = 3.0;
  bool _isLoading = false;

  Future<void> _submit() async {
    if (_commentCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Escreva um comentário!')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await context.read<SupabaseService>().submitReview(
        widget.movie.id,
        _rating,
        _commentCtrl.text.trim(),
      );
      if (mounted) {
        widget.onSubmitted(); // refresh details page
        _commentCtrl.clear();
        setState(() => _rating = 3.0);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Avaliação enviada com sucesso!'), backgroundColor: Colors.green));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao enviar: \$e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Avaliar \${widget.movie.title}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < _rating.floor() ? Icons.star : Icons.star_border,
                color: const Color(0xFF00E054),
                size: 36,
              ),
              onPressed: () {
                setState(() {
                  _rating = index + 1.0;
                });
              },
            );
          }),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _commentCtrl,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'O que você achou do filme?',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Color(0xFF2C3440),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submit,
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E054)),
            child: _isLoading 
              ? const CircularProgressIndicator(color: Colors.white) 
              : const Text('ENVIAR AVALIAÇÃO', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
