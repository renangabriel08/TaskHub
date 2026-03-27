import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskhub/config/app_colors.dart';
import 'package:taskhub/widgets/app_bar_widget.dart';

class CreatePublicationScreen extends StatefulWidget {
  const CreatePublicationScreen({super.key});

  @override
  State<CreatePublicationScreen> createState() =>
      _CreatePublicationScreenState();
}

class _CreatePublicationScreenState extends State<CreatePublicationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _serviceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  final List<String> _categories = const [
    'Elétrica',
    'Hidráulica',
    'Decoração',
    'Ar Condicionado',
    'Saúde',
    'Pintura',
    'Outro',
  ];

  String? _selectedCategory;
  final List<XFile> _selectedMedia = [];

  @override
  void dispose() {
    _titleController.dispose();
    _serviceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromCamera() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 1280,
    );

    if (image == null) {
      return;
    }

    _addMediaFiles([image]);
  }

  Future<void> _pickVideoFromCamera() async {
    final video = await _imagePicker.pickVideo(source: ImageSource.camera);
    if (video == null) {
      return;
    }

    _addMediaFiles([video]);
  }

  Future<void> _pickMediaFromGallery() async {
    final media = await _imagePicker.pickMultipleMedia(imageQuality: 80);
    if (media.isEmpty) {
      return;
    }

    _addMediaFiles(media);
  }

  void _addMediaFiles(List<XFile> files) {
    final availableSlots = 5 - _selectedMedia.length;
    if (availableSlots <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Limite de 5 arquivos atingido.')),
      );
      return;
    }

    final filesToAdd = files.take(availableSlots).toList();
    setState(() {
      _selectedMedia.addAll(filesToAdd);
    });

    if (files.length > filesToAdd.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Apenas 5 mídias são permitidas por publicação.'),
        ),
      );
    }
  }

  bool _isVideo(XFile file) {
    final path = file.path.toLowerCase();
    return path.endsWith('.mp4') ||
        path.endsWith('.mov') ||
        path.endsWith('.avi') ||
        path.endsWith('.mkv') ||
        path.endsWith('.webm');
  }

  void _showImageSourceSheet() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text('Escolher mídia da galeria'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _pickMediaFromGallery();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: const Text('Tirar foto'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _pickImageFromCamera();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.videocam_outlined),
                  title: const Text('Gravar vídeo'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _pickVideoFromCamera();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitPublication() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione uma categoria para a publicação.'),
        ),
      );
      return;
    }

    if (_selectedMedia.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicione de 1 a 5 fotos ou vídeos.')),
      );
      return;
    }

    final publicationData = {
      'title': _titleController.text.trim(),
      'serviceType': _serviceController.text.trim(),
      'category': _selectedCategory,
      'description': _descriptionController.text.trim(),
      'mediaPaths': _selectedMedia.map((file) => file.path).toList(),
      'createdAt': DateTime.now().toIso8601String(),
    };

    Navigator.of(context).pop(publicationData);
  }

  InputDecoration _inputDecoration(String label, {String? hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
      ),
    );
  }

  String? _requiredValidator(String? value, {int min = 2}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Campo obrigatório';
    }
    if (text.length < min) {
      return 'Preencha com pelo menos $min caracteres';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const TaskHubAppBar(
        title: 'Criar Publicação',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Preencha os dados da sua publicação',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Esses campos ajudam outros usuários a entender seu serviço com clareza.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _titleController,
                validator: _requiredValidator,
                textInputAction: TextInputAction.next,
                decoration: _inputDecoration(
                  'Título da publicação',
                  hint: 'Ex: Reforma elétrica completa',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _serviceController,
                validator: _requiredValidator,
                textInputAction: TextInputAction.next,
                decoration: _inputDecoration(
                  'Tipo de serviço',
                  hint: 'Ex: Instalação, manutenção, consultoria',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: _inputDecoration('Categoria'),
                items: _categories
                    .map(
                      (category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                validator: (value) => _requiredValidator(value, min: 20),
                minLines: 4,
                maxLines: 6,
                textInputAction: TextInputAction.done,
                decoration: _inputDecoration(
                  'Descrição detalhada',
                  hint: 'Descreva o serviço, materiais e diferenciais.',
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _showImageSourceSheet,
                  icon: const Icon(Icons.upload_file_rounded),
                  label: Text(
                    'Upload de foto/vídeo (${_selectedMedia.length}/5)',
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.border),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              if (_selectedMedia.isNotEmpty) ...[
                const SizedBox(height: 8),
                Column(
                  children: _selectedMedia.asMap().entries.map((entry) {
                    final index = entry.key;
                    final file = entry.value;
                    final isVideo = _isVideo(file);

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        isVideo ? Icons.videocam_rounded : Icons.image_rounded,
                        color: AppColors.primary,
                      ),
                      title: Text(
                        file.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(isVideo ? 'Vídeo' : 'Foto'),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            _selectedMedia.removeAt(index);
                          });
                        },
                        icon: const Icon(Icons.delete_outline),
                      ),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _submitPublication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.publish_rounded),
                  label: const Text(
                    'Publicar',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
