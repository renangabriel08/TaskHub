import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskhub/models/models.dart';
import 'package:taskhub/providers/auth_provider.dart';
import 'package:taskhub/widgets/app_bar_widget.dart';

class ProfessionalAreaScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ProfessionalAreaScreen({super.key, required this.userData});

  @override
  State<ProfessionalAreaScreen> createState() => _ProfessionalAreaScreenState();
}

class _ProfessionalAreaScreenState extends State<ProfessionalAreaScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _serviceTypeController;
  late TextEditingController _specialtiesController;
  late TextEditingController _descriptionController;
  late TextEditingController _yearsExperienceController;

  // Formação
  bool _hasHighSchool = false;
  bool _hasTechnicalCourses = false;
  bool _hasHigherEducation = false;
  List<String> _technicalCourses = [];
  List<String> _higherEducationCourses = [];
  List<String> _additionalCourses = [];

  // Experiência de trabalho
  late TextEditingController _workExperienceController;

  // Quantidade de trabalhos realizados
  String _jobsCompleted = '0-5';

  bool _isLoading = false;

  // Lista de tipos de serviço para autocomplete
  final List<String> _serviceTypes = [
    'Eletricista',
    'Encanador',
    'Pintor',
    'Pedreiro',
    'Marceneiro',
    'Jardineiro',
    'Limpeza',
    'Manutenção',
    'Instalador de Ar Condicionado',
    'Reparador de Eletrodomésticos',
    'Montador de Móveis',
    'Serviços Gerais',
    'Técnico de Informática',
    'Designer Gráfico',
    'Fotógrafo',
    'Cozinheiro',
    'Babá',
    'Personal Trainer',
    'Professor Particular',
    'Tradutor',
    'Contador',
    'Advogado',
    'Médico',
    'Dentista',
    'Enfermeiro',
    'Fisioterapeuta',
    'Psicólogo',
    'Veterinário',
  ];

  @override
  void initState() {
    super.initState();
    _serviceTypeController = TextEditingController();
    _specialtiesController = TextEditingController();
    _descriptionController = TextEditingController();
    _yearsExperienceController = TextEditingController();
    _workExperienceController = TextEditingController();
  }

  @override
  void dispose() {
    _serviceTypeController.dispose();
    _specialtiesController.dispose();
    _descriptionController.dispose();
    _yearsExperienceController.dispose();
    _workExperienceController.dispose();
    super.dispose();
  }

  int _calculateScore() {
    int score = 0;

    // Years of experience: 2 points per year, max 40
    int years = int.tryParse(_yearsExperienceController.text) ?? 0;
    score += (years * 2).clamp(0, 40);

    // Education: points for different levels
    if (_hasHighSchool) score += 5;
    score += _technicalCourses.length * 10; // 10 points per technical course
    score +=
        _higherEducationCourses.length *
        15; // 15 points per higher education course
    score += _additionalCourses.length * 3; // 3 points per additional course

    // Work experience description: 1 point per 100 characters, max 10
    int workExpLength = _workExperienceController.text.length;
    score += (workExpLength / 100).round().clamp(0, 10);

    // Jobs completed: points based on range
    switch (_jobsCompleted) {
      case '0-5':
        score += 0;
        break;
      case '6-20':
        score += 5;
        break;
      case '21-50':
        score += 10;
        break;
      case '51-100':
        score += 15;
        break;
      case '100+':
        score += 20;
        break;
    }

    // Description length: 1 point per 50 characters, max 10
    int descLength = _descriptionController.text.length;
    score += (descLength / 50).round().clamp(0, 10);

    return score;
  }

  int _calculateLevel(int score) {
    if (score <= 20) return 1;
    if (score <= 40) return 2;
    if (score <= 60) return 3;
    if (score <= 80) return 4;
    return 5;
  }

  void _addTechnicalCourse() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Curso Técnico'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nome do Curso Técnico'),
          onSubmitted: (_) => _submitTechnicalCourse(controller),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => _submitTechnicalCourse(controller),
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  void _addHigherEducationCourse() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Ensino Superior'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nome do Curso Superior',
          ),
          onSubmitted: (_) => _submitHigherEducationCourse(controller),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => _submitHigherEducationCourse(controller),
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  void _addCourse() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Curso'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nome do Curso'),
          onSubmitted: (_) => _submitAdditionalCourse(controller),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => _submitAdditionalCourse(controller),
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  void _submitTechnicalCourse(TextEditingController controller) {
    final value = controller.text.trim();
    if (value.isNotEmpty) {
      setState(() {
        _technicalCourses.add(value);
      });
    }
    Navigator.of(context).pop();
  }

  void _submitHigherEducationCourse(TextEditingController controller) {
    final value = controller.text.trim();
    if (value.isNotEmpty) {
      setState(() {
        _higherEducationCourses.add(value);
      });
    }
    Navigator.of(context).pop();
  }

  void _submitAdditionalCourse(TextEditingController controller) {
    final value = controller.text.trim();
    if (value.isNotEmpty) {
      setState(() {
        _additionalCourses.add(value);
      });
    }
    Navigator.of(context).pop();
  }

  void _removeCourse(int index) {
    setState(() {
      _additionalCourses.removeAt(index);
    });
  }

  void _removeTechnicalCourse(int index) {
    setState(() {
      _technicalCourses.removeAt(index);
    });
  }

  void _removeHigherEducationCourse(int index) {
    setState(() {
      _higherEducationCourses.removeAt(index);
    });
  }

  Future<void> _handleCompleteRegistration() async {
    // Removed validations for easier testing

    setState(() => _isLoading = true);

    int score = _calculateScore();
    int level = _calculateLevel(score);

    // Create education list
    List<Education> educationList = [];
    if (_hasHighSchool) {
      educationList.add(
        Education(degree: 'Ensino Médio', description: 'Completado'),
      );
    }
    _technicalCourses.forEach((course) {
      educationList.add(
        Education(degree: 'Ensino Técnico', fieldOfStudy: course),
      );
    });
    _higherEducationCourses.forEach((course) {
      educationList.add(
        Education(degree: 'Ensino Superior', fieldOfStudy: course),
      );
    });
    _additionalCourses.forEach((course) {
      educationList.add(Education(degree: 'Curso', fieldOfStudy: course));
    });

    // Create Professional object
    Professional professional = Professional(
      userId: 0, // Will be set by backend
      documentType: widget.userData['documentType'],
      documentNumber: widget.userData['documentNumber'],
      documentIssuerState: widget.userData['documentIssuerState'],
      professionalRegistry: widget.userData['professionalRegistry'] ?? '',
      serviceType: _serviceTypeController.text,
      specialties: _specialtiesController.text,
      description:
          '${_descriptionController.text}\n\nExperiência de trabalho: ${_workExperienceController.text}',
      yearsExperience: int.tryParse(_yearsExperienceController.text) ?? 0,
      level: level,
      education: educationList.isNotEmpty ? educationList : null,
      address: Address(
        street: widget.userData['address_street'],
        number: widget.userData['address_number'],
        complement: widget.userData['address_complement'],
        neighborhood: widget.userData['address_neighborhood'],
        city: widget.userData['address_city'],
        state: widget.userData['address_state'],
        zipCode: widget.userData['address_zip_code'],
      ),
    );

    try {
      // Simula uma resposta de cadastro bem-sucedida (dados fictícios)
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.setAuthenticatedUser(
        'fake_access_token_123',
        'fake_refresh_token_123',
        User(
          id: 999,
          email: widget.userData['email'] ?? 'profissional@taskhub.com',
          userType: 'professional',
          firstName: widget.userData['firstName'] ?? 'Profissional',
          lastName: widget.userData['lastName'] ?? 'Fictício',
          isActive: true,
        ),
      );

      await _showLevelDialog(level);

      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      _showErrorSnackBar('Erro no cadastro fictício: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showLevelDialog(int level) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cadastro concluído'),
        content: Text('Seu nível de profissional é: Nível $level.'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TaskHubAppBar(
        title: 'Detalhes Profissionais',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Conte-nos sobre sua área de atuação',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return _serviceTypes.where((String option) {
                    return option.toLowerCase().contains(
                      textEditingValue.text.toLowerCase(),
                    );
                  });
                },
                onSelected: (String selection) {
                  _serviceTypeController.text = selection;
                },
                fieldViewBuilder:
                    (
                      BuildContext context,
                      TextEditingController fieldTextEditingController,
                      FocusNode fieldFocusNode,
                      VoidCallback onFieldSubmitted,
                    ) {
                      // Sync the field controller with our main controller
                      fieldTextEditingController.text =
                          _serviceTypeController.text;
                      fieldTextEditingController.addListener(() {
                        _serviceTypeController.text =
                            fieldTextEditingController.text;
                      });
                      return TextFormField(
                        controller: fieldTextEditingController,
                        focusNode: fieldFocusNode,
                        decoration: const InputDecoration(
                          labelText: 'Tipo de Serviço',
                        ),
                      );
                    },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _specialtiesController,
                decoration: const InputDecoration(labelText: 'Especialidades'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _yearsExperienceController,
                decoration: const InputDecoration(
                  labelText: 'Anos de Experiência',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),

              // Formação Acadêmica
              Text(
                'Formação Acadêmica',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Ensino Médio Completo'),
                value: _hasHighSchool,
                onChanged: (value) {
                  setState(() {
                    _hasHighSchool = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                title: const Text('Possui curso técnico'),
                value: _hasTechnicalCourses,
                onChanged: (value) {
                  setState(() {
                    _hasTechnicalCourses = value ?? false;
                  });
                },
              ),
              if (_hasTechnicalCourses) ...[
                const SizedBox(height: 8),
                ..._technicalCourses.map(
                  (course) => ListTile(
                    title: Text(course),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeTechnicalCourse(
                        _technicalCourses.indexOf(course),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addTechnicalCourse,
                  child: const Text('Adicionar Curso Técnico'),
                ),
              ],
              const SizedBox(height: 12),
              CheckboxListTile(
                title: const Text('Possui ensino superior'),
                value: _hasHigherEducation,
                onChanged: (value) {
                  setState(() {
                    _hasHigherEducation = value ?? false;
                  });
                },
              ),
              if (_hasHigherEducation) ...[
                const SizedBox(height: 8),
                ..._higherEducationCourses.map(
                  (course) => ListTile(
                    title: Text(course),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeHigherEducationCourse(
                        _higherEducationCourses.indexOf(course),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addHigherEducationCourse,
                  child: const Text('Adicionar Ensino Superior'),
                ),
              ],
              const SizedBox(height: 16),
              Text(
                'Cursos Adicionais',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ..._additionalCourses.map(
                (course) => ListTile(
                  title: Text(course),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () =>
                        _removeCourse(_additionalCourses.indexOf(course)),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _addCourse,
                child: const Text('Adicionar Curso'),
              ),
              const SizedBox(height: 24),

              // Experiência de Trabalho
              Text(
                'Experiência de Trabalho',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _workExperienceController,
                decoration: const InputDecoration(
                  labelText: 'Descreva sua experiência profissional',
                  hintText:
                      'Ex: Trabalhei como eletricista por 5 anos em empresa X...',
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),

              // Quantidade de Trabalhos
              Text(
                'Quantidade de Trabalhos Realizados',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _jobsCompleted,
                decoration: const InputDecoration(
                  labelText: 'Número aproximado de trabalhos realizados',
                ),
                items: const [
                  DropdownMenuItem(value: '0-5', child: Text('0-5 trabalhos')),
                  DropdownMenuItem(
                    value: '6-20',
                    child: Text('6-20 trabalhos'),
                  ),
                  DropdownMenuItem(
                    value: '21-50',
                    child: Text('21-50 trabalhos'),
                  ),
                  DropdownMenuItem(
                    value: '51-100',
                    child: Text('51-100 trabalhos'),
                  ),
                  DropdownMenuItem(
                    value: '100+',
                    child: Text('Mais de 100 trabalhos'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _jobsCompleted = value ?? '0-5';
                  });
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleCompleteRegistration,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Completar Cadastro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
