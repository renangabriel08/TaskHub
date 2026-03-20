import 'package:flutter/material.dart';
import 'package:taskhub/config/app_colors.dart';
import 'package:taskhub/screens/menu/professional_detail_screen.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  // Sample service posts data
  static const List<Map<String, dynamic>> _servicePosts = [
    {
      'id': 1,
      'professionalName': 'Carlos Eletricista',
      'category': 'Elétrica',
      'description':
          'Instalação de novo painel elétrico na residência do Sr. João. Trabalho realizado com excelência e segurança.',
      'rating': 4.8,
      'reviews': 124,
      'date': 'Há 2 dias',
      'avatar': '👨‍🔧',
    },
    {
      'id': 2,
      'professionalName': 'Andrea Fisioterapia',
      'category': 'Saúde',
      'description':
          'Sessão de fisioterapia completa com análise postural e tratamento de dores nas costas. Resultado excepcional!',
      'rating': 4.9,
      'reviews': 87,
      'date': 'Há 1 dia',
      'avatar': '👩‍⚕️',
    },
    {
      'id': 3,
      'professionalName': 'Lucas Encanador',
      'category': 'Hidráulica',
      'description':
          'Conserto de vazamento em cano de cobre e substituição de sifão. Trabalho rápido e eficiente!',
      'rating': 4.7,
      'reviews': 156,
      'date': 'Há 3 dias',
      'avatar': '🔧',
    },
    {
      'id': 4,
      'professionalName': 'Marina Design de Interiores',
      'category': 'Decoração',
      'description':
          'Reforma completa de sala de estar com novo layout, pintura e acabamentos. Ambiente completamente transformado!',
      'rating': 5.0,
      'reviews': 203,
      'date': 'Há 5 dias',
      'avatar': '👩‍🎨',
    },
    {
      'id': 5,
      'professionalName': 'Roberto Climatização',
      'category': 'Ar Condicionado',
      'description':
          'Instalação de ar condicionado split com isolamento térmico e higienização. Sistema funcionando perfeitamente!',
      'rating': 4.6,
      'reviews': 95,
      'date': 'Há 4 dias',
      'avatar': '❄️',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _servicePosts.length,
      itemBuilder: (context, index) {
        final post = _servicePosts[index];
        return _buildServicePost(context, post);
      },
    );
  }

  Widget _buildServicePost(BuildContext context, Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with professional info
          GestureDetector(
            onTap: () {
              // Create a professional object from the post data
              final professional = {
                'id': post['id'],
                'name': post['professionalName'],
                'category': post['category'],
                'rating': post['rating'],
                'reviews': post['reviews'],
                'avatar': post['avatar'],
                'price': 'Consultar',
                'description': 'Profissional especializado',
              };
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProfessionalDetailScreen(professional: professional),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryVeryLight,
                    ),
                    child: Center(
                      child: Text(
                        post['avatar'] as String,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Professional name and category
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post['professionalName'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentCyan.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            post['category'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.accentCyan,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Date
                  Text(
                    post['date'] as String,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Service description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              post['description'] as String,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 12),

          // Placeholder image
          Container(
            width: double.infinity,
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(Icons.image, size: 48, color: AppColors.primaryLight),
            ),
          ),
          const SizedBox(height: 16),

          // Footer with rating and action
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Rating
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post['rating']} (${post['reviews']})',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Like button
                IconButton(
                  icon: const Icon(
                    Icons.favorite_outline,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {},
                ),
                // More options
                IconButton(
                  icon: const Icon(
                    Icons.share,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // CTA Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Ver Mais',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textInverse,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
