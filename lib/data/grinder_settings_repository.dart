import '../domain/entities/grinder_profile.dart';
import '../core/constants/brew_methods.dart';

class GrinderSettingsRepository {
  static final Map<GrinderBrand, List<GrinderProfile>> grinders = {
    GrinderBrand.oneZpresso: [
      GrinderProfile(
        brand: '1Zpresso',
        model: 'JX',
        country: 'Taiwan',
        settings: {
          BrewMethod.v60: const GrinderSettings(
            grindSize: '8-10 clicks',
            dose: 15,
            yield_: 250,
            brewTime: '2:30-3:00',
            notes: 'Start at 9 clicks. Adjust finer if too fast.',
          ),
          BrewMethod.espresso: const GrinderSettings(
            grindSize: '6-8 clicks',
            dose: 18,
            yield_: 36,
            brewTime: '25-30s',
            notes: 'Aim for 25-28s shot.',
          ),
          BrewMethod.phin: const GrinderSettings(
            grindSize: '12-14 clicks',
            dose: 20,
            yield_: 150,
            brewTime: '4-5 min',
            notes: 'Medium-coarse, like rough sand.',
          ),
          BrewMethod.aeropress: const GrinderSettings(
            grindSize: '10-12 clicks',
            dose: 15,
            yield_: 200,
            brewTime: '1:30-2:00',
          ),
          BrewMethod.frenchPress: const GrinderSettings(
            grindSize: '14-16 clicks',
            dose: 30,
            yield_: 500,
            brewTime: '4:00',
          ),
        },
      ),
      GrinderProfile(
        brand: '1Zpresso',
        model: 'JX-Pro',
        country: 'Taiwan',
        settings: {
          BrewMethod.v60: const GrinderSettings(
            grindSize: '8-10 clicks',
            dose: 15,
            yield_: 250,
            brewTime: '2:30-3:00',
            notes: 'More consistent than JX. Start at 9 clicks.',
          ),
          BrewMethod.espresso: const GrinderSettings(
            grindSize: '6-8 clicks',
            dose: 18,
            yield_: 36,
            brewTime: '25-30s',
            notes: 'Precision burrs for better clarity.',
          ),
          BrewMethod.chemex: const GrinderSettings(
            grindSize: '10-12 clicks',
            dose: 42,
            yield_: 700,
            brewTime: '4:00-4:30',
          ),
          BrewMethod.phin: const GrinderSettings(
            grindSize: '12-14 clicks',
            dose: 20,
            yield_: 150,
            brewTime: '4-5 min',
          ),
          BrewMethod.aeropress: const GrinderSettings(
            grindSize: '10-12 clicks',
            dose: 15,
            yield_: 200,
            brewTime: '1:30-2:00',
          ),
          BrewMethod.frenchPress: const GrinderSettings(
            grindSize: '14-16 clicks',
            dose: 30,
            yield_: 500,
            brewTime: '4:00',
          ),
        },
      ),
      GrinderProfile(
        brand: '1Zpresso',
        model: 'K-Plus',
        country: 'Taiwan',
        settings: {
          BrewMethod.v60: const GrinderSettings(
            grindSize: '7-9 clicks',
            dose: 18,
            yield_: 300,
            brewTime: '2:45-3:15',
            notes: 'K-Plus has coarser upper range.',
          ),
          BrewMethod.espresso: const GrinderSettings(
            grindSize: '5-7 clicks',
            dose: 20,
            yield_: 40,
            brewTime: '25-30s',
          ),
        },
      ),
      GrinderProfile(
        brand: '1Zpresso',
        model: 'ZP6 Special',
        country: 'Taiwan',
        settings: {
          BrewMethod.v60: const GrinderSettings(
            grindSize: '5-7 clicks',
            dose: 15,
            yield_: 250,
            brewTime: '2:00-2:30',
            notes: 'Ultra-uniform particles. Great for light roasts.',
          ),
          BrewMethod.chemex: const GrinderSettings(
            grindSize: '6-8 clicks',
            dose: 40,
            yield_: 650,
            brewTime: '3:30-4:00',
          ),
        },
      ),
    ],
    GrinderBrand.timemore: [
      GrinderProfile(
        brand: 'Timemore',
        model: 'C2',
        country: 'China',
        settings: {
          BrewMethod.v60: const GrinderSettings(
            grindSize: '16-18 clicks',
            dose: 15,
            yield_: 250,
            brewTime: '2:30-3:00',
            notes: 'Popular in VN community. Start at 17.',
          ),
          BrewMethod.espresso: const GrinderSettings(
            grindSize: '12-14 clicks',
            dose: 18,
            yield_: 36,
            brewTime: '25-30s',
          ),
          BrewMethod.phin: const GrinderSettings(
            grindSize: '20-22 clicks',
            dose: 20,
            yield_: 150,
            brewTime: '4-5 min',
          ),
        },
      ),
      GrinderProfile(
        brand: 'Timemore',
        model: 'C3',
        country: 'China',
        settings: {
          BrewMethod.v60: const GrinderSettings(
            grindSize: '14-16 clicks',
            dose: 15,
            yield_: 250,
            brewTime: '2:30-3:00',
            notes: 'Slightly finer than C2.',
          ),
          BrewMethod.espresso: const GrinderSettings(
            grindSize: '10-12 clicks',
            dose: 18,
            yield_: 36,
            brewTime: '25-30s',
          ),
        },
      ),
      GrinderProfile(
        brand: 'Timemore',
        model: 'Slim',
        country: 'China',
        settings: {
          BrewMethod.v60: const GrinderSettings(
            grindSize: '15-17 clicks',
            dose: 15,
            yield_: 250,
            brewTime: '2:30-3:00',
            notes: 'Portable. Great for travel.',
          ),
        },
      ),
      GrinderProfile(
        brand: 'Timemore',
        model: 'Black Mirror',
        country: 'China',
        settings: {
          BrewMethod.v60: const GrinderSettings(
            grindSize: '12-14 clicks',
            dose: 15,
            yield_: 250,
            brewTime: '2:30-3:00',
            notes: 'Premium finish. Electronic dosing.',
          ),
          BrewMethod.espresso: const GrinderSettings(
            grindSize: '8-10 clicks',
            dose: 18,
            yield_: 36,
            brewTime: '25-30s',
          ),
        },
      ),
      GrinderProfile(
        brand: 'Timemore',
        model: 'Basil',
        country: 'China',
        settings: {
          BrewMethod.v60: const GrinderSettings(
            grindSize: '13-15 clicks',
            dose: 16,
            yield_: 260,
            brewTime: '2:30-3:00',
            notes: 'Newer model. Faster grinding.',
          ),
        },
      ),
    ],
    GrinderBrand.helge: [
      GrinderProfile(
        brand: 'HELGE',
        model: 'H1',
        country: 'China',
        settings: {
          BrewMethod.v60: const GrinderSettings(
            grindSize: '8-10 clicks',
            dose: 15,
            yield_: 250,
            brewTime: '2:30-3:00',
            notes: 'Popular in Vietnam. Good value.',
          ),
          BrewMethod.phin: const GrinderSettings(
            grindSize: '12-14 clicks',
            dose: 20,
            yield_: 150,
            brewTime: '4-5 min',
          ),
        },
      ),
      GrinderProfile(
        brand: 'HELGE',
        model: 'H2',
        country: 'China',
        settings: {
          BrewMethod.v60: const GrinderSettings(
            grindSize: '8-10 clicks',
            dose: 15,
            yield_: 250,
            brewTime: '2:30-3:00',
            notes: 'Improved from H1.',
          ),
          BrewMethod.espresso: const GrinderSettings(
            grindSize: '6-8 clicks',
            dose: 18,
            yield_: 36,
            brewTime: '25-30s',
          ),
        },
      ),
      GrinderProfile(
        brand: 'HELGE',
        model: 'H3',
        country: 'China',
        settings: {
          BrewMethod.v60: const GrinderSettings(
            grindSize: '7-9 clicks',
            dose: 16,
            yield_: 260,
            brewTime: '2:30-3:00',
            notes: 'Premium Helge. Better burrs.',
          ),
          BrewMethod.espresso: const GrinderSettings(
            grindSize: '5-7 clicks',
            dose: 18,
            yield_: 36,
            brewTime: '25-30s',
          ),
        },
      ),
    ],
    GrinderBrand.ssure: [
      GrinderProfile(
        brand: 'SSURE',
        model: 'S1',
        country: 'China',
        settings: {
          BrewMethod.v60: const GrinderSettings(
            grindSize: '9-11 clicks',
            dose: 15,
            yield_: 250,
            brewTime: '2:30-3:00',
            notes: 'Budget friendly. Popular in VN.',
          ),
          BrewMethod.phin: const GrinderSettings(
            grindSize: '13-15 clicks',
            dose: 20,
            yield_: 150,
            brewTime: '4-5 min',
          ),
        },
      ),
      GrinderProfile(
        brand: 'SSURE',
        model: 'S2',
        country: 'China',
        settings: {
          BrewMethod.v60: const GrinderSettings(
            grindSize: '8-10 clicks',
            dose: 15,
            yield_: 250,
            brewTime: '2:30-3:00',
            notes: 'Better build than S1.',
          ),
          BrewMethod.espresso: const GrinderSettings(
            grindSize: '6-8 clicks',
            dose: 18,
            yield_: 36,
            brewTime: '25-30s',
          ),
        },
      ),
      GrinderProfile(
        brand: 'SSURE',
        model: 'S3',
        country: 'China',
        settings: {
          BrewMethod.v60: const GrinderSettings(
            grindSize: '8-10 clicks',
            dose: 15,
            yield_: 250,
            brewTime: '2:30-3:00',
            notes: 'Top of SSURE line.',
          ),
          BrewMethod.espresso: const GrinderSettings(
            grindSize: '5-7 clicks',
            dose: 18,
            yield_: 36,
            brewTime: '25-30s',
          ),
        },
      ),
    ],
    GrinderBrand.wizard: [
      GrinderProfile(
        brand: 'Wizard',
        model: 'M1',
        country: 'China',
        settings: {
          BrewMethod.v60: const GrinderSettings(
            grindSize: '9-11 clicks',
            dose: 15,
            yield_: 250,
            brewTime: '2:30-3:00',
            notes: 'Chinese brand. Good community feedback.',
          ),
          BrewMethod.phin: const GrinderSettings(
            grindSize: '13-15 clicks',
            dose: 20,
            yield_: 150,
            brewTime: '4-5 min',
          ),
        },
      ),
      GrinderProfile(
        brand: 'Wizard',
        model: 'M2',
        country: 'China',
        settings: {
          BrewMethod.v60: const GrinderSettings(
            grindSize: '8-10 clicks',
            dose: 15,
            yield_: 250,
            brewTime: '2:30-3:00',
            notes: 'Improved version of M1.',
          ),
        },
      ),
    ],
    GrinderBrand.xiaomi: [
      GrinderProfile(
        brand: 'Xiaomi',
        model: 'Smart Grinder',
        country: 'China',
        settings: {
          BrewMethod.v60: const GrinderSettings(
            grindSize: '8-10 clicks',
            dose: 15,
            yield_: 250,
            brewTime: '2:30-3:00',
            notes: 'App connected. Good for beginners.',
          ),
          BrewMethod.espresso: const GrinderSettings(
            grindSize: '6-8 clicks',
            dose: 18,
            yield_: 36,
            brewTime: '25-30s',
          ),
        },
      ),
    ],
    GrinderBrand.cafelat: [
      GrinderProfile(
        brand: 'CAFELATTI',
        model: 'K1',
        country: 'China',
        settings: {
          BrewMethod.v60: const GrinderSettings(
            grindSize: '9-11 clicks',
            dose: 15,
            yield_: 250,
            brewTime: '2:30-3:00',
            notes: 'Italian design style. Good value.',
          ),
          BrewMethod.phin: const GrinderSettings(
            grindSize: '13-15 clicks',
            dose: 20,
            yield_: 150,
            brewTime: '4-5 min',
          ),
        },
      ),
      GrinderProfile(
        brand: 'CAFELATTI',
        model: 'K2',
        country: 'China',
        settings: {
          BrewMethod.v60: const GrinderSettings(
            grindSize: '8-10 clicks',
            dose: 15,
            yield_: 250,
            brewTime: '2:30-3:00',
            notes: 'Upgraded from K1.',
          ),
          BrewMethod.espresso: const GrinderSettings(
            grindSize: '6-8 clicks',
            dose: 18,
            yield_: 36,
            brewTime: '25-30s',
          ),
        },
      ),
    ],
    GrinderBrand.comandante: [
      GrinderProfile(
        brand: 'Commandante',
        model: 'C40',
        country: 'Germany',
        settings: {
          BrewMethod.v60: const GrinderSettings(
            grindSize: '25-28 clicks',
            dose: 15,
            yield_: 250,
            brewTime: '2:30-3:00',
            notes: 'Premium hand grinder. Great clarity.',
          ),
          BrewMethod.espresso: const GrinderSettings(
            grindSize: '20-23 clicks',
            dose: 18,
            yield_: 36,
            brewTime: '25-30s',
            notes: 'Nitro blade burrs for espresso.',
          ),
          BrewMethod.chemex: const GrinderSettings(
            grindSize: '28-32 clicks',
            dose: 42,
            yield_: 700,
            brewTime: '4:00-4:30',
          ),
          BrewMethod.phin: const GrinderSettings(
            grindSize: '30-34 clicks',
            dose: 20,
            yield_: 150,
            brewTime: '4-5 min',
          ),
          BrewMethod.aeropress: const GrinderSettings(
            grindSize: '22-25 clicks',
            dose: 15,
            yield_: 200,
            brewTime: '1:30-2:00',
          ),
          BrewMethod.frenchPress: const GrinderSettings(
            grindSize: '32-36 clicks',
            dose: 30,
            yield_: 500,
            brewTime: '4:00',
          ),
        },
      ),
    ],
    GrinderBrand.baratza: [
      GrinderProfile(
        brand: 'Baratza',
        model: 'Encore',
        country: 'USA',
        settings: {
          BrewMethod.v60: const GrinderSettings(
            grindSize: '8-10 (of 40)',
            dose: 15,
            yield_: 250,
            brewTime: '2:30-3:00',
            notes: 'Entry level electric. 40 settings.',
          ),
          BrewMethod.espresso: const GrinderSettings(
            grindSize: '10-12 (of 40)',
            dose: 18,
            yield_: 36,
            brewTime: '25-30s',
            notes: 'Need adjustment for espresso.',
          ),
          BrewMethod.phin: const GrinderSettings(
            grindSize: '14-16 (of 40)',
            dose: 20,
            yield_: 150,
            brewTime: '4-5 min',
          ),
        },
      ),
      GrinderProfile(
        brand: 'Baratza',
        model: 'Virtuoso',
        country: 'USA',
        settings: {
          BrewMethod.v60: const GrinderSettings(
            grindSize: '8-10 (of 40)',
            dose: 15,
            yield_: 250,
            brewTime: '2:30-3:00',
            notes: 'More consistent than Encore.',
          ),
          BrewMethod.espresso: const GrinderSettings(
            grindSize: '10-12 (of 40)',
            dose: 18,
            yield_: 36,
            brewTime: '25-30s',
          ),
        },
      ),
    ],
    GrinderBrand.hario: [
      GrinderProfile(
        brand: 'Hario',
        model: 'Skerton',
        country: 'Japan',
        settings: {
          BrewMethod.v60: const GrinderSettings(
            grindSize: '3-4 (of 5)',
            dose: 15,
            yield_: 250,
            brewTime: '2:30-3:00',
            notes: 'Ceramic burrs. Manual. Entry level.',
          ),
          BrewMethod.phin: const GrinderSettings(
            grindSize: '4-5 (of 5)',
            dose: 20,
            yield_: 150,
            brewTime: '4-5 min',
          ),
        },
      ),
      GrinderProfile(
        brand: 'Hario',
        model: 'Mini Mill',
        country: 'Japan',
        settings: {
          BrewMethod.v60: const GrinderSettings(
            grindSize: '3-4 (of 5)',
            dose: 15,
            yield_: 250,
            brewTime: '2:30-3:00',
            notes: 'Smaller than Skerton. Same burrs.',
          ),
          BrewMethod.phin: const GrinderSettings(
            grindSize: '4-5 (of 5)',
            dose: 20,
            yield_: 150,
            brewTime: '4-5 min',
          ),
        },
      ),
    ],
  };

  static List<GrinderProfile> getByBrand(GrinderBrand brand) {
    return grinders[brand] ?? [];
  }

  static List<GrinderProfile> getAll() {
    return grinders.values.expand((list) => list).toList();
  }

  static GrinderSettings? getSettings(GrinderBrand brand, String model, BrewMethod method) {
    final profiles = getByBrand(brand);
    final profile = profiles.where((p) => p.model == model).firstOrNull;
    return profile?.settings[method];
  }
}
