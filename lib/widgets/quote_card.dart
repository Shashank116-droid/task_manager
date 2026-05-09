import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quote_provider.dart';
import '../theme/app_colors.dart';

class QuoteCard extends StatelessWidget {
  const QuoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    final quoteProvider = context.watch<QuoteProvider>();
    final quote = quoteProvider.quote;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryLight.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: quoteProvider.isLoading ? _buildLoadingState() : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.format_quote_rounded, color: Colors.white, size: 32),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
                onPressed: () => quoteProvider.refresh(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            quote?.content ?? '',
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 12),
          Text(
            "- ${quote?.author ?? 'Unknown'}",
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const SizedBox(
      height: 120,
      child: Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
    );
  }
}
