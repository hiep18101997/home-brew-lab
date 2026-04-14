import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/beans_provider.dart';
import '../../../domain/entities/bean.dart';

class AddBeanScreen extends ConsumerStatefulWidget {
  const AddBeanScreen({super.key});

  @override
  ConsumerState<AddBeanScreen> createState() => _AddBeanScreenState();
}

class _AddBeanScreenState extends ConsumerState<AddBeanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roasterController = TextEditingController();
  final _originController = TextEditingController();
  final _varietyController = TextEditingController();
  final _processController = TextEditingController();
  final _notesController = TextEditingController();

  String? _roastLevel;
  DateTime? _roastDate;
  double _weight = 250;

  // Image picker state
  String? _imageUrl;
  bool _isProcessingImage = false;
  Uint8List? _processedImageBytes;
  final ImagePicker _imagePicker = ImagePicker();

  final List<String> _roastLevels = ['Light', 'Medium-Light', 'Medium', 'Medium-Dark', 'Dark'];

  @override
  void dispose() {
    _nameController.dispose();
    _roasterController.dispose();
    _originController.dispose();
    _varietyController.dispose();
    _processController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Add Bean',
          style: GoogleFonts.notoSerif(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: AppColors.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveBean,
            child: Text(
              'Save',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Bean Image Picker - Hero Image
          _BeanImagePicker(
            imageUrl: _imageUrl,
            processedImageBytes: _processedImageBytes,
            isProcessing: _isProcessingImage,
            onCameraTap: () => _pickImage(ImageSource.camera),
            onGalleryTap: () => _pickImage(ImageSource.gallery),
            onDeleteTap: _removeImage,
          ),
          // Form
          Expanded(
            child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Essential Section
            _SectionHeader(title: 'Essential', color: AppColors.onSurface),
            const SizedBox(height: 12),
            _TonalCard(
              backgroundColor: AppColors.surfaceContainerLow,
              child: Column(
                children: [
                  _DesignTextField(
                    controller: _nameController,
                    label: 'Bean Name *',
                    hint: 'e.g., Ethiopia Yirgacheffe',
                    textColor: AppColors.onSurface,
                    hintColor: AppColors.onSurfaceVariant,
                    accentColor: AppColors.secondary,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter bean name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _DesignTextField(
                    controller: _roasterController,
                    label: 'Roaster *',
                    hint: 'e.g., Local Roaster',
                    textColor: AppColors.onSurface,
                    hintColor: AppColors.onSurfaceVariant,
                    accentColor: AppColors.secondary,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter roaster name';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Origin Section
            _SectionHeader(title: 'Origin', color: AppColors.onSurface),
            const SizedBox(height: 12),
            _TonalCard(
              backgroundColor: AppColors.surfaceContainerLow,
              child: Column(
                children: [
                  _DesignTextField(
                    controller: _originController,
                    label: 'Origin',
                    hint: 'e.g., Ethiopia',
                    textColor: AppColors.onSurface,
                    hintColor: AppColors.onSurfaceVariant,
                    accentColor: AppColors.secondary,
                  ),
                  const SizedBox(height: 16),
                  _DesignTextField(
                    controller: _varietyController,
                    label: 'Variety',
                    hint: 'e.g., Heirloom',
                    textColor: AppColors.onSurface,
                    hintColor: AppColors.onSurfaceVariant,
                    accentColor: AppColors.secondary,
                  ),
                  const SizedBox(height: 16),
                  _DesignTextField(
                    controller: _processController,
                    label: 'Process',
                    hint: 'e.g., Washed, Natural',
                    textColor: AppColors.onSurface,
                    hintColor: AppColors.onSurfaceVariant,
                    accentColor: AppColors.secondary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Roast Details Section
            _SectionHeader(title: 'Roast Details', color: AppColors.onSurface),
            const SizedBox(height: 12),
            _TonalCard(
              backgroundColor: AppColors.surfaceContainerLow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Roast Level',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _roastLevels.map((level) => _RoastChip(
                      label: level,
                      isSelected: _roastLevel == level,
                      selectedColor: AppColors.secondary,
                      backgroundColor: AppColors.surfaceContainerHigh,
                      textColor: AppColors.onSurface,
                      selectedTextColor: AppColors.onSecondary,
                      onTap: () => setState(() => _roastLevel = level),
                    )).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Roast Date',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _roastDate ?? DateTime.now(),
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: AppColors.secondary,
                                onPrimary: AppColors.onSecondary,
                                surface: AppColors.surfaceContainerLow,
                                onSurface: AppColors.onSurface,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (date != null) {
                        setState(() => _roastDate = date);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: AppColors.onSurfaceVariant, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            _roastDate != null
                                ? DateFormat.yMMMd().format(_roastDate!)
                                : 'Not set',
                            style: GoogleFonts.manrope(
                              fontSize: 15,
                              color: _roastDate != null ? AppColors.onSurface : AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Quantity Section
            _SectionHeader(title: 'Quantity', color: AppColors.onSurface),
            const SizedBox(height: 12),
            _TonalCard(
              backgroundColor: AppColors.surfaceContainerLow,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Weight',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_weight.toStringAsFixed(0)}g',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _CustomSlider(
                    value: _weight,
                    min: 50,
                    max: 1000,
                    onChanged: (value) => setState(() => _weight = value),
                    activeColor: AppColors.secondary,
                    trackColor: AppColors.surfaceContainerHigh,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Notes Section
            _SectionHeader(title: 'Notes', color: AppColors.onSurface),
            const SizedBox(height: 12),
            _TonalCard(
              backgroundColor: AppColors.surfaceContainerLow,
              child: _DesignTextField(
                controller: _notesController,
                label: 'Notes',
                hint: 'Tasting notes, roaster info...',
                textColor: AppColors.onSurface,
                hintColor: AppColors.onSurfaceVariant,
                accentColor: AppColors.secondary,
                maxLines: 4,
              ),
            ),
            const SizedBox(height: 40),

            // Save Button
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.secondary, AppColors.secondary.withOpacity(0.9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton(
                onPressed: _saveBean,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check, color: AppColors.onSecondary),
                    const SizedBox(width: 8),
                    Text(
                      'Save Bean',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
            ),
          ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Camera permission required'),
              action: SnackBarAction(label: 'Settings', onPressed: openAppSettings),
            ),
          );
        }
        return;
      }
    }

    setState(() => _isProcessingImage = true);

    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile == null) {
        setState(() => _isProcessingImage = false);
        return;
      }

      final bytes = await pickedFile.readAsBytes();

      if (mounted) {
        setState(() {
          _processedImageBytes = bytes;
          _imageUrl = null;
          _isProcessingImage = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessingImage = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to process image: $e')),
        );
      }
    }
  }

  void _removeImage() {
    setState(() {
      _imageUrl = null;
      _processedImageBytes = null;
    });
  }

  Future<void> _saveBean() async {
    if (!_formKey.currentState!.validate()) return;

    final beanId = const Uuid().v4();

    String? finalImageUrl;
    if (_processedImageBytes != null) {
      try {
        finalImageUrl = await ref.read(beansProvider.notifier).saveBeanImage(
          _processedImageBytes!,
          beanId,
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save image: $e')),
          );
        }
      }
    }

    final bean = Bean.create(
      name: _nameController.text,
      roaster: _roasterController.text,
      origin: _originController.text.isNotEmpty ? _originController.text : null,
      variety: _varietyController.text.isNotEmpty ? _varietyController.text : null,
      process: _processController.text.isNotEmpty ? _processController.text : null,
      roastLevel: _roastLevel,
      roastDate: _roastDate,
      weightRemaining: _weight,
      weightInitial: _weight,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      imageUrl: finalImageUrl,
    );

    await ref.read(beansProvider.notifier).addBean(bean);

    if (mounted) context.pop();
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;

  const _SectionHeader({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.notoSerif(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: color,
      ),
    );
  }
}

class _TonalCard extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;

  const _TonalCard({required this.backgroundColor, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}

class _DesignTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final Color textColor;
  final Color hintColor;
  final Color accentColor;
  final String? Function(String?)? validator;
  final int maxLines;

  const _DesignTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.textColor,
    required this.hintColor,
    required this.accentColor,
    this.validator,
    this.maxLines = 1,
  });

  @override
  State<_DesignTextField> createState() => _DesignTextFieldState();
}

class _DesignTextFieldState extends State<_DesignTextField> {
  bool _isFocused = false;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.manrope(
            fontSize: 14,
            color: widget.hintColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 4,
                height: 52,
                decoration: BoxDecoration(
                  color: _isFocused ? widget.accentColor : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    color: widget.textColor,
                  ),
                  maxLines: widget.maxLines,
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: GoogleFonts.manrope(
                      fontSize: 15,
                      color: widget.hintColor.withOpacity(0.6),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  validator: widget.validator,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoastChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final Color backgroundColor;
  final Color textColor;
  final Color selectedTextColor;
  final VoidCallback onTap;

  const _RoastChip({
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.backgroundColor,
    required this.textColor,
    required this.selectedTextColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? selectedTextColor : textColor,
          ),
        ),
      ),
    );
  }
}

class _CustomSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final Color activeColor;
  final Color trackColor;

  const _CustomSlider({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.activeColor,
    required this.trackColor,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 4,
        activeTrackColor: activeColor,
        inactiveTrackColor: trackColor,
        thumbColor: activeColor,
        overlayColor: activeColor.withOpacity(0.2),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        onChanged: onChanged,
      ),
    );
  }
}

class _BeanImagePicker extends StatelessWidget {
  final String? imageUrl;
  final Uint8List? processedImageBytes;
  final bool isProcessing;
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;
  final VoidCallback onDeleteTap;

  const _BeanImagePicker({
    this.imageUrl,
    this.processedImageBytes,
    required this.isProcessing,
    required this.onCameraTap,
    required this.onGalleryTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null || processedImageBytes != null;

    return Container(
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (isProcessing)
            const Center(child: CircularProgressIndicator())
          else if (processedImageBytes != null)
            Image.memory(
              processedImageBytes!,
              fit: BoxFit.cover,
            )
          else if (imageUrl != null)
            Image.file(
              File(imageUrl!),
              fit: BoxFit.cover,
            )
          else
            GestureDetector(
              onTap: onCameraTap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    size: 48,
                    color: AppColors.onSurfaceVariant,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to add photo',
                    style: GoogleFonts.manrope(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          if (hasImage)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                  ),
                ),
              ),
            ),
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              children: [
                _ActionButton(icon: Icons.camera_alt, onTap: onCameraTap),
                const SizedBox(width: 8),
                _ActionButton(icon: Icons.photo_library, onTap: onGalleryTap),
                if (hasImage) ...[
                  const SizedBox(width: 8),
                  _ActionButton(icon: Icons.delete, onTap: onDeleteTap),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}