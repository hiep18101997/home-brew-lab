import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/beans_provider.dart';
import '../../providers/brew_timer_provider.dart';
import '../../../core/constants/brew_methods.dart';
import '../../../domain/entities/bean.dart';
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
    final guide = BrewGuide.getGuide(BrewMethod.v60);
    _dose = guide.defaultDose;
    _yield = guide.defaultYield;
  }

  @override
  Widget build(BuildContext context) {
    final beansAsync = ref.watch(beansProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'New Brew',
          style: GoogleFonts.notoSerif(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: AppColors.onSurface,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Bean selection
          _SectionHeader(title: 'Select Bean', color: AppColors.onSurface),
          const SizedBox(height: 12),
          _TonalCard(
            backgroundColor: AppColors.surfaceContainerLow,
            child: _BeanDropdown(
              beansAsync: beansAsync,
              selectedBean: _selectedBean,
              onChanged: (bean) => setState(() => _selectedBean = bean),
            ),
          ),
          const SizedBox(height: 32),

          // Method selection - Visual grid
          _SectionHeader(title: 'Brew Method', color: AppColors.onSurface),
          const SizedBox(height: 12),
          _MethodGrid(
            selectedMethod: _selectedMethod,
            onSelected: (method) {
              final config = BrewMethodConfig.getConfig(method);
              final guide = BrewGuide.getGuide(method);
              setState(() {
                _selectedMethod = method;
                _waterTemp = config.defaultWaterTemp;
                _dose = guide.defaultDose;
                _yield = guide.defaultYield;
              });
            },
          ),
          const SizedBox(height: 32),

          // Parameters Section
          _SectionHeader(title: 'Parameters', color: AppColors.onSurface),
          const SizedBox(height: 12),
          _TonalCard(
            backgroundColor: AppColors.surfaceContainerLow,
            child: Column(
              children: [
                _ParameterSlider(
                  label: 'Dose',
                  value: _dose,
                  min: 5,
                  max: 30,
                  unit: 'g',
                  divisions: 25,
                  onChanged: (v) => setState(() => _dose = v),
                ),
                const SizedBox(height: 20),
                _ParameterSlider(
                  label: 'Yield',
                  value: _yield,
                  min: 20,
                  max: 500,
                  unit: 'g',
                  divisions: 45,
                  onChanged: (v) => setState(() => _yield = v),
                ),
                const SizedBox(height: 20),
                _ParameterSlider(
                  label: 'Grind Size',
                  value: _grindSize.toDouble(),
                  min: 1,
                  max: 10,
                  unit: '',
                  divisions: 9,
                  displayValue: '$_grindSize',
                  onChanged: (v) => setState(() => _grindSize = v.round()),
                  accentColor: AppColors.tertiary,
                ),
                const SizedBox(height: 20),
                _ParameterSlider(
                  label: 'Water Temp',
                  value: _waterTemp.toDouble(),
                  min: 70,
                  max: 100,
                  unit: '°C',
                  divisions: 30,
                  displayValue: '$_waterTemp',
                  onChanged: (v) => setState(() => _waterTemp = v.round()),
                  accentColor: AppColors.tertiary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Rating Section
          _SectionHeader(title: 'Rating', color: AppColors.onSurface),
          const SizedBox(height: 12),
          _TonalCard(
            backgroundColor: AppColors.surfaceContainerLow,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) => GestureDetector(
                    onTap: () => setState(() => _rating = i + 1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        i < _rating ? Icons.star_rounded : Icons.star_border_rounded,
                        size: 40,
                        color: AppColors.secondary,
                      ),
                    ),
                  )),
                ),
                if (_rating > 0) ...[
                  const SizedBox(height: 12),
                  Text(
                    _getRatingLabel(_rating),
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Start brew button
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.secondary, AppColors.secondary.withOpacity(0.85)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: TextButton(
              onPressed: _startBrew,
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow, color: AppColors.onSecondary),
                  const SizedBox(width: 8),
                  Text(
                    'Start Brew',
                    style: GoogleFonts.manrope(
                      fontSize: 18,
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
    );
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1: return 'Poor';
      case 2: return 'Below Average';
      case 3: return 'Average';
      case 4: return 'Good';
      case 5: return 'Excellent';
      default: return '';
    }
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

class _MethodGrid extends StatelessWidget {
  final BrewMethod selectedMethod;
  final ValueChanged<BrewMethod> onSelected;

  const _MethodGrid({
    required this.selectedMethod,
    required this.onSelected,
  });

  IconData _getMethodIcon(BrewMethod method) {
    switch (method) {
      case BrewMethod.v60: return Icons.filter_alt_outlined;
      case BrewMethod.chemex: return Icons.local_cafe_outlined;
      case BrewMethod.espresso: return Icons.coffee_maker_outlined;
      case BrewMethod.aeropress: return Icons.sports_bar_outlined;
      case BrewMethod.frenchPress: return Icons.coffee_outlined;
      case BrewMethod.phin: return Icons.water_drop_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: BrewMethod.values.map((method) {
        final isSelected = method == selectedMethod;
        return GestureDetector(
          onTap: () => onSelected(method),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 100,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.secondary.withOpacity(0.15)
                  : AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppColors.secondary
                    : AppColors.surfaceContainer,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  _getMethodIcon(method),
                  size: 28,
                  color: isSelected
                      ? AppColors.secondary
                      : AppColors.onSurfaceVariant,
                ),
                const SizedBox(height: 8),
                Text(
                  method.displayName,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppColors.secondary
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _BeanDropdown extends StatelessWidget {
  final AsyncValue<List<Bean>> beansAsync;
  final Bean? selectedBean;
  final ValueChanged<Bean?> onChanged;

  const _BeanDropdown({
    required this.beansAsync,
    required this.selectedBean,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return beansAsync.when(
      loading: () => Center(
        child: CircularProgressIndicator(color: AppColors.secondary),
      ),
      error: (_, __) => Text(
        'Error loading beans',
        style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant),
      ),
      data: (beans) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<Bean?>(
            value: selectedBean,
            isExpanded: true,
            dropdownColor: AppColors.surfaceContainer,
            icon: Icon(Icons.keyboard_arrow_down, color: AppColors.onSurfaceVariant),
            items: [
              DropdownMenuItem<Bean?>(
                value: null,
                child: Text(
                  'No bean selected',
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              ...beans.map((b) => DropdownMenuItem(
                value: b,
                child: Text(
                  '${b.name} (${b.roaster})',
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    color: AppColors.onSurface,
                  ),
                ),
              )),
            ],
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}

class _ParameterSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final String unit;
  final int divisions;
  final String? displayValue;
  final ValueChanged<double> onChanged;
  final Color accentColor;

  const _ParameterSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.divisions,
    this.displayValue,
    required this.onChanged,
    this.accentColor = AppColors.secondary,
  });

  @override
  Widget build(BuildContext context) {
    final display = displayValue ?? (unit.isEmpty ? value.toStringAsFixed(0) : '${value.toStringAsFixed(0)}$unit');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 14,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                display,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: accentColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            activeTrackColor: accentColor,
            inactiveTrackColor: AppColors.surfaceContainerHigh,
            thumbColor: accentColor,
            overlayColor: accentColor.withOpacity(0.2),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}