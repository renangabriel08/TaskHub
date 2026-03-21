import 'package:flutter/material.dart';
import 'package:taskhub/config/app_colors.dart';
import 'package:taskhub/screens/menu/hire_professional_screen.dart';
import 'package:taskhub/screens/menu/professional_detail_screen.dart';

class HomeMenuScreen extends StatefulWidget {
  const HomeMenuScreen({super.key});

  @override
  State<HomeMenuScreen> createState() => _HomeMenuScreenState();
}

class _HomeMenuScreenState extends State<HomeMenuScreen> {
  late TextEditingController _searchController;
  String _searchQuery = '';
  String? _selectedCategory;
  int? _selectedLevel;
  String _sortBy =
      'relevancia'; // relevancia, rating, reviews, preco_asc, preco_desc

  // Categories padrão que serão listadas
  static const List<String> _defaultCategories = [
    'Elétrica',
    'Hidráulica',
    'Decoração',
    'Ar Condicionado',
    'Saúde',
    'Pintura',
  ];

  // Sample professionals data
  static final List<Map<String, dynamic>> _allProfessionals = [
    {
      'id': 1,
      'name': 'Carlos Eletricista',
      'category': 'Elétrica',
      'level': 3,
      'rating': 4.8,
      'reviews': 124,
      'price': 'R\$ 80-150/h',
      'priceValue': 80,
      'avatar': '👨‍🔧',
      'description': 'Especializado em instalações e manutenção elétrica',
    },
    {
      'id': 2,
      'name': 'Lucas Encanador',
      'category': 'Hidráulica',
      'level': 2,
      'rating': 4.7,
      'reviews': 156,
      'price': 'R\$ 70-120/h',
      'priceValue': 70,
      'avatar': '🔧',
      'description': 'Consertos e instalações hidráulicas com garantia',
    },
    {
      'id': 3,
      'name': 'Marina Design',
      'category': 'Decoração',
      'level': 3,
      'rating': 5.0,
      'reviews': 203,
      'price': 'R\$ 100-200/h',
      'priceValue': 100,
      'avatar': '👩‍🎨',
      'description': 'Design de interiores e reformas completas',
    },
    {
      'id': 4,
      'name': 'Roberto HVAC',
      'category': 'Ar Condicionado',
      'level': 2,
      'rating': 4.6,
      'reviews': 95,
      'price': 'R\$ 150-300/serviço',
      'priceValue': 150,
      'avatar': '❄️',
      'description': 'Instalação e manutenção de sistemas de refrigeração',
    },
    {
      'id': 5,
      'name': 'Andrea Fisio',
      'category': 'Saúde',
      'level': 3,
      'rating': 4.9,
      'reviews': 87,
      'price': 'R\$ 120-150/sessão',
      'priceValue': 120,
      'avatar': '👩‍⚕️',
      'description': 'Fisioterapia especializada e reabilitação',
    },
    {
      'id': 6,
      'name': 'João Pintor',
      'category': 'Pintura',
      'level': 1,
      'rating': 4.5,
      'reviews': 78,
      'price': 'R\$ 60-100/h',
      'priceValue': 60,
      'avatar': '🎨',
      'description': 'Pintura residencial e comercial profissional',
    },
  ];

  late List<Map<String, dynamic>> _filteredProfessionals;
  late List<String> _categories;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredProfessionals = _allProfessionals;
    // Extract unique categories
    _categories =
        _allProfessionals.map((p) => p['category'] as String).toSet().toList()
          ..sort();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProfessionals(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();

      // Start with all professionals
      List<Map<String, dynamic>> filtered = List.from(_allProfessionals);

      // Filter by search query
      if (_searchQuery.isNotEmpty) {
        filtered = filtered
            .where(
              (prof) =>
                  prof['name'].toLowerCase().contains(_searchQuery) ||
                  prof['category'].toLowerCase().contains(_searchQuery) ||
                  prof['description'].toLowerCase().contains(_searchQuery),
            )
            .toList();
      }

      // Filter by category
      if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
        if (_selectedCategory == 'outro') {
          // Show only non-default categories
          filtered = filtered
              .where((prof) => !_defaultCategories.contains(prof['category']))
              .toList();
        } else {
          // Show exact category
          filtered = filtered
              .where((prof) => prof['category'] == _selectedCategory)
              .toList();
        }
      }

      // Filter by level
      if (_selectedLevel != null) {
        filtered = filtered
            .where((prof) => prof['level'] == _selectedLevel)
            .toList();
      }

      // Sort
      switch (_sortBy) {
        case 'rating':
          filtered.sort(
            (a, b) => (b['rating'] as num).compareTo(a['rating'] as num),
          );
          break;
        case 'reviews':
          filtered.sort(
            (a, b) => (b['reviews'] as int).compareTo(a['reviews'] as int),
          );
          break;
        case 'preco_asc':
          filtered.sort(
            (a, b) =>
                (a['priceValue'] as int).compareTo(b['priceValue'] as int),
          );
          break;
        case 'preco_desc':
          filtered.sort(
            (a, b) =>
                (b['priceValue'] as int).compareTo(a['priceValue'] as int),
          );
          break;
        default: // relevancia
          break;
      }

      _filteredProfessionals = filtered;
    });
  }

  void _updateFilters() {
    _filterProfessionals(_searchQuery);
  }

  void _showFiltersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filtros',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Category Filter
                    Text(
                      'Categoria',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = null;
                            });
                            _updateFilters();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _selectedCategory == null
                                  ? AppColors.primary
                                  : Colors.white,
                              border: Border.all(
                                color: _selectedCategory == null
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Todos',
                              style: TextStyle(
                                color: _selectedCategory == null
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        ..._categories.map((category) {
                          final isSelected = _selectedCategory == category;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = category;
                              });
                              _updateFilters();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.white,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                category,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        // Outro option
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = 'outro';
                            });
                            _updateFilters();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _selectedCategory == 'outro'
                                  ? AppColors.primary
                                  : Colors.white,
                              border: Border.all(
                                color: _selectedCategory == 'outro'
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Outro',
                              style: TextStyle(
                                color: _selectedCategory == 'outro'
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Level Filter
                    Text(
                      'Nível',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedLevel = null;
                            });
                            _updateFilters();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _selectedLevel == null
                                  ? AppColors.primary
                                  : Colors.white,
                              border: Border.all(
                                color: _selectedLevel == null
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Todos',
                              style: TextStyle(
                                color: _selectedLevel == null
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        ...[1, 2, 3].map((level) {
                          final isSelected = _selectedLevel == level;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedLevel = level;
                              });
                              _updateFilters();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.white,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Nível $level',
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Sort Filter
                    Text(
                      'Ordenar por',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: _sortBy,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(
                            value: 'relevancia',
                            child: Text('Relevância'),
                          ),
                          DropdownMenuItem(
                            value: 'rating',
                            child: Text('Maior Avaliação'),
                          ),
                          DropdownMenuItem(
                            value: 'reviews',
                            child: Text('Mais Avaliações'),
                          ),
                          DropdownMenuItem(
                            value: 'preco_asc',
                            child: Text('Menor Preço'),
                          ),
                          DropdownMenuItem(
                            value: 'preco_desc',
                            child: Text('Maior Preço'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _sortBy = value;
                            });
                            _updateFilters();
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Apply Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Aplicar Filtros',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Text(
            'Encontre o profissional ideal',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Busque por categoria ou nome do profissional',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),

          // Search Bar
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterProfessionals,
                  decoration: InputDecoration(
                    hintText: 'Buscar...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _filterProfessionals('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () => _showFiltersBottomSheet(context),
                  tooltip: 'Filtros',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Results count
          if (_filteredProfessionals.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                '${_filteredProfessionals.length} profissional(is) encontrado(s)',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ),

          // Professionals List
          if (_filteredProfessionals.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 48,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Nenhum profissional encontrado',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredProfessionals.length,
              itemBuilder: (context, index) {
                final professional = _filteredProfessionals[index];
                return _buildProfessionalCard(context, professional);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildProfessionalCard(
    BuildContext context,
    Map<String, dynamic> professional,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProfessionalDetailScreen(professional: professional),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryVeryLight, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                // Avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryVeryLight,
                  ),
                  child: Center(
                    child: Text(
                      professional['avatar'] as String,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        professional['name'] as String,
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
                          '${professional['category']} • Nível ${professional['level']}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.accentCyan,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              professional['description'] as String,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            // Rating and Price
            Row(
              children: [
                // Rating
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${professional['rating']} (${professional['reviews']})',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Price
                Text(
                  professional['price'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Hire Button
            SizedBox(
              width: double.infinity,
              height: 36,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          HireProfessionalScreen(professional: professional),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Contratar',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textInverse,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
