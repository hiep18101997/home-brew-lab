import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/beans_provider.dart';
import '../../providers/brew_timer_provider.dart';
import '../../widgets/sliders.dart';
import '../../../core/constants/brew_methods.dart';
import '../../../features/beans/domain/entities/bean.dart';
import '../../../domain/entities/brew_guide.dart';

class NewBrewScreen extends ConsumerStatefulWidget {
  const NewBrewScreen({super.key});

  @override
  ConsumerState<NewBrewScreen> createState() => _NewBrewScreenState();
}

class _NewBrewScreenState extends ConsumerState<NewBrewScreen> {
  Bean? _selectedBean;
  BrewMethod _selectedMethod = BrewMethod.v60;
  double _dose = 15.0;
  double _yield = 250.0;
  int _grindSize = 5;
  int _waterTemp = 96;
  int _rating = 0;

  @override
  void initState() {
    super.initState();
    // Set defaults from V60 guide
    final guide = BrewGuide.getGuide(BrewMethod.v60);
    _dose = guide.defaultDose;
    _yield = guide.defaultYield;
  }

  @override
  Widget build(BuildContext context) {
    final beansAsync = ref.watch(beansProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Brew'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Bean selection
          beansAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const Text('Error loading beans'),
            data: (beans) => DropdownButtonFormField<Bean?>(
              decoration: const InputDecoration(
                labelText: 'Select Bean (optional)',
                border: OutlineInputBorder(),
              ),
              value: _selectedBean,
              items: [
                const DropdownMenuItem<Bean?>(
                  value: null,
                  child: Text('No bean selected'),
                ),
                ...beans.map((b) => DropdownMenuItem(
                  value: b,
                  child: Text('${b.name} (${b.roaster})'),
                )),
              ],
              onChanged: (bean) => setState(() => _selectedBean = bean),
            ),
          ),
          const SizedBox(height: 24),

          // Method selection
          DropdownButtonFormField<BrewMethod>(
            decoration: const InputDecoration(
              labelText: 'Brew Method',
              border: OutlineInputBorder(),
            ),
            value: _selectedMethod,
            items: BrewMethod.values.map((m) => DropdownMenuItem(
              value: m,
              child: Text(m.displayName),
            )).toList(),
            onChanged: (method) {
              if (method != null) {
                final config = BrewMethodConfig.getConfig(method);
                final guide = BrewGuide.getGuide(method);
                setState(() {
                  _selectedMethod = method;
                  _waterTemp = config.defaultWaterTemp;
                  _dose = guide.defaultDose;
                  _yield = guide.defaultYield;
                });
              }
            },
          ),
          const SizedBox(height: 24),

          // Dose slider
          LabeledSlider(
            label: 'Dose',
            value: _dose,
            min: 5,
            max: 30,
            unit: 'g',
            divisions: 25,
            onChanged: (v) => setState(() => _dose = v),
          ),

          // Yield slider
          LabeledSlider(
            label: 'Yield',
            value: _yield,
            min: 50,
            max: 500,
            unit: 'g',
            divisions: 45,
            onChanged: (v) => setState(() => _yield = v),
          ),

          // Grind size slider
          LabeledSlider(
            label: 'Grind Size',
            value: _grindSize.toDouble(),
            min: 1,
            max: 10,
            unit: '',
            divisions: 9,
            onChanged: (v) => setState(() => _grindSize = v.round()),
          ),

          // Water temp slider
          LabeledSlider(
            label: 'Water Temp',
            value: _waterTemp.toDouble(),
            min: 70,
            max: 100,
            unit: '°C',
            divisions: 30,
            onChanged: (v) => setState(() => _waterTemp = v.round()),
          ),

          const SizedBox(height: 24),

          // Rating
          Text(
            'Rating',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) => IconButton(
              icon: Icon(
                i < _rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
              onPressed: () => setState(() => _rating = i + 1),
            )),
          ),

          const SizedBox(height: 32),

          // Start brew button
          FilledButton.icon(
            onPressed: _startBrew,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Brew'),
          ),
        ],
      ),
    );
  }

  void _startBrew() {
    ref.read(brewTimerProvider.notifier).startBrew(
      _selectedMethod,
      beanId: _selectedBean?.id,
      dose: _dose,
      yield_: _yield,
      grindSize: _grindSize,
      waterTemperature: _waterTemp,
    );
    context.push('/brew/timer');
  }
}