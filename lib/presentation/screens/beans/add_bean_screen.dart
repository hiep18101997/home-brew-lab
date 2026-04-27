import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../features/beans/domain/entities/bean.dart';
import '../../../features/beans/presentation/bloc/beans_bloc.dart';
import '../../../features/beans/presentation/bloc/beans_event.dart';
import '../../../features/beans/presentation/bloc/beans_state.dart';
import '../../widgets/sliders.dart';

class AddBeanScreen extends StatefulWidget {
  const AddBeanScreen({super.key});

  @override
  State<AddBeanScreen> createState() => _AddBeanScreenState();
}

class _AddBeanScreenState extends State<AddBeanScreen> {
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
    return BlocListener<BeansBloc, BeansState>(
      listener: (context, state) {
        if (state is BeansSuccess) {
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Bean'),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Bean Name *',
                  hintText: 'e.g., Ethiopia Yirgacheffe',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter bean name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Roaster
              TextFormField(
                controller: _roasterController,
                decoration: const InputDecoration(
                  labelText: 'Roaster *',
                  hintText: 'e.g., local roaster',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter roaster name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Origin
              TextFormField(
                controller: _originController,
                decoration: const InputDecoration(
                  labelText: 'Origin',
                  hintText: 'e.g., Ethiopia',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Variety
              TextFormField(
                controller: _varietyController,
                decoration: const InputDecoration(
                  labelText: 'Variety',
                  hintText: 'e.g., Heirloom',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Process
              TextFormField(
                controller: _processController,
                decoration: const InputDecoration(
                  labelText: 'Process',
                  hintText: 'e.g., Washed, Natural',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Roast Level
              DropdownButtonFormField<String>(
                value: _roastLevel,
                decoration: const InputDecoration(
                  labelText: 'Roast Level',
                  border: OutlineInputBorder(),
                ),
                items: _roastLevels.map((level) {
                  return DropdownMenuItem(value: level, child: Text(level));
                }).toList(),
                onChanged: (value) => setState(() => _roastLevel = value),
              ),
              const SizedBox(height: 16),

              // Roast Date
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Roast Date'),
                subtitle: Text(
                  _roastDate != null
                      ? DateFormat.yMMMd().format(_roastDate!)
                      : 'Not set',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _roastDate ?? DateTime.now(),
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() => _roastDate = date);
                    }
                  },
                ),
              ),
              const Divider(),
              const SizedBox(height: 16),

              // Weight slider
              LabeledSlider(
                label: 'Weight',
                value: _weight,
                min: 50,
                max: 1000,
                unit: 'g',
                divisions: 95,
                onChanged: (value) => setState(() => _weight = value),
              ),
              const SizedBox(height: 16),

              // Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Tasting notes, roaster info...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Save button
              FilledButton(
                onPressed: _saveBean,
                child: const Text('Save Bean'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveBean() {
    if (_formKey.currentState!.validate()) {
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
      );

      context.read<BeansBloc>().add(BeanCreated(bean));
    }
  }
}