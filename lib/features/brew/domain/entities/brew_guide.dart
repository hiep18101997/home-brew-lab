import '../../../../core/constants/brew_methods.dart';

/// A single step in a brew guide
class PourStep {
  final String name;
  final Duration duration;
  final double waterAmount; // grams
  final String instruction;

  const PourStep({
    required this.name,
    required this.duration,
    required this.waterAmount,
    required this.instruction,
  });
}

/// Pre-defined brew guide for a specific method
class BrewGuide {
  final BrewMethod method;
  final String name;
  final Duration totalTime;
  final List<PourStep> steps;
  final double defaultDose; // grams
  final double defaultYield; // grams

  const BrewGuide({
    required this.method,
    required this.name,
    required this.totalTime,
    required this.steps,
    required this.defaultDose,
    required this.defaultYield,
  });

  static const Map<BrewMethod, BrewGuide> guides = {
    BrewMethod.v60: BrewGuide(
      method: BrewMethod.v60,
      name: 'V60 Classic',
      totalTime: Duration(minutes: 3, seconds: 30),
      defaultDose: 15,
      defaultYield: 250,
      steps: [
        PourStep(
          name: 'Bloom',
          duration: Duration(seconds: 30),
          waterAmount: 50,
          instruction: 'Pour 50g water, let bloom',
        ),
        PourStep(
          name: 'Pour 1',
          duration: Duration(seconds: 60),
          waterAmount: 100,
          instruction: 'Pour steadily to 150g',
        ),
        PourStep(
          name: 'Pour 2',
          duration: Duration(seconds: 60),
          waterAmount: 100,
          instruction: 'Final pour to 250g',
        ),
        PourStep(
          name: 'Drawdown',
          duration: Duration(seconds: 60),
          waterAmount: 0,
          instruction: 'Let drawdown complete',
        ),
      ],
    ),
    BrewMethod.chemex: BrewGuide(
      method: BrewMethod.chemex,
      name: 'Chemex',
      totalTime: Duration(minutes: 4, seconds: 30),
      defaultDose: 30,
      defaultYield: 450,
      steps: [
        PourStep(
          name: 'Bloom',
          duration: Duration(seconds: 45),
          waterAmount: 60,
          instruction: 'Pour 60g water, let bloom',
        ),
        PourStep(
          name: 'Pour 1',
          duration: Duration(seconds: 90),
          waterAmount: 200,
          instruction: 'Pour to 260g',
        ),
        PourStep(
          name: 'Pour 2',
          duration: Duration(seconds: 60),
          waterAmount: 190,
          instruction: 'Final pour to 450g',
        ),
      ],
    ),
    BrewMethod.espresso: BrewGuide(
      method: BrewMethod.espresso,
      name: 'Espresso',
      totalTime: Duration(seconds: 30),
      defaultDose: 18,
      defaultYield: 36,
      steps: [
        PourStep(
          name: 'Pre-infusion',
          duration: Duration(seconds: 5),
          waterAmount: 0,
          instruction: 'Light pre-infusion',
        ),
        PourStep(
          name: 'Extraction',
          duration: Duration(seconds: 25),
          waterAmount: 36,
          instruction: 'Extract to 36g yield',
        ),
      ],
    ),
    BrewMethod.aeropress: BrewGuide(
      method: BrewMethod.aeropress,
      name: 'AeroPress',
      totalTime: Duration(minutes: 2),
      defaultDose: 15,
      defaultYield: 250,
      steps: [
        PourStep(
          name: 'Bloom',
          duration: Duration(seconds: 30),
          waterAmount: 50,
          instruction: 'Pour 50g, let bloom',
        ),
        PourStep(
          name: 'Pour',
          duration: Duration(seconds: 30),
          waterAmount: 200,
          instruction: 'Pour remaining water',
        ),
        PourStep(
          name: 'Press',
          duration: Duration(seconds: 30),
          waterAmount: 0,
          instruction: 'Slow press over 30s',
        ),
      ],
    ),
    BrewMethod.frenchPress: BrewGuide(
      method: BrewMethod.frenchPress,
      name: 'French Press',
      totalTime: Duration(minutes: 4, seconds: 30),
      defaultDose: 15,
      defaultYield: 250,
      steps: [
        PourStep(
          name: 'Bloom',
          duration: Duration(seconds: 30),
          waterAmount: 50,
          instruction: 'Pour 50g, let bloom',
        ),
        PourStep(
          name: 'Pour',
          duration: Duration(seconds: 60),
          waterAmount: 200,
          instruction: 'Pour to 250g',
        ),
        PourStep(
          name: 'Steep',
          duration: Duration(minutes: 4),
          waterAmount: 0,
          instruction: 'Let steep for 4 minutes',
        ),
        PourStep(
          name: 'Press',
          duration: Duration(seconds: 30),
          waterAmount: 0,
          instruction: 'Slow press over 30s',
        ),
      ],
    ),
    BrewMethod.phin: BrewGuide(
      method: BrewMethod.phin,
      name: 'Phin',
      totalTime: Duration(minutes: 5),
      defaultDose: 12,
      defaultYield: 250,
      steps: [
        PourStep(
          name: 'Bloom',
          duration: Duration(seconds: 30),
          waterAmount: 30,
          instruction: 'Pour 30g, let bloom',
        ),
        PourStep(
          name: 'Fill',
          duration: Duration(seconds: 30),
          waterAmount: 220,
          instruction: 'Fill to 250g total',
        ),
        PourStep(
          name: 'Wait',
          duration: Duration(minutes: 4),
          waterAmount: 0,
          instruction: 'Wait for drip through',
        ),
      ],
    ),
  };

  static BrewGuide getGuide(BrewMethod method) {
    return guides[method]!;
  }

  static List<BrewMethod> get supportedMethods => BrewMethod.values;
}