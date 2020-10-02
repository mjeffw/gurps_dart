import 'package:meta/meta.dart';

class DamageType {
  const DamageType({@required this.label, @required this.shortLabel});

  final String label;
  final String shortLabel;

  static Map<String, DamageType> map = {
    burning.label: burning,
    corrosive.label: corrosive,
    crushing.label: crushing,
    cutting.label: cutting,
    fatigue.label: fatigue,
    impaling.label: impaling,
    hugePiercing.label: hugePiercing,
    largePiercing.label: largePiercing,
    piercing.label: piercing,
    smallPiercing.label: smallPiercing,
    toxic.label: toxic,
  };

  static const List<DamageType> types = [
    burning,
    corrosive,
    crushing,
    cutting,
    fatigue,
    impaling,
    hugePiercing,
    largePiercing,
    piercing,
    smallPiercing,
    toxic
  ];

  static const burning = Burning();
  static const corrosive = Corrosive();
  static const crushing = Crushing();
  static const cutting = Cutting();
  static const fatigue = Fatigue();
  static const impaling = Impaling();
  static const hugePiercing = HugePiercing();
  static const largePiercing = LargePiercing();
  static const piercing = Piercing();
  static const smallPiercing = SmallPiercing();
  static const toxic = Toxic();
}

class Burning extends DamageType {
  const Burning() : super(label: 'Burning', shortLabel: 'burn');
}

class Corrosive extends DamageType {
  const Corrosive() : super(label: 'Corrosive', shortLabel: 'cor');
}

class Crushing extends DamageType {
  const Crushing() : super(label: 'Crushing', shortLabel: 'cr');
}

class Cutting extends DamageType {
  const Cutting() : super(label: 'Cutting', shortLabel: 'cut');
}

class Fatigue extends DamageType {
  const Fatigue() : super(label: 'Fatigue', shortLabel: 'fat');
}

class Impaling extends DamageType {
  const Impaling() : super(label: 'Impaling', shortLabel: 'imp');
}

class HugePiercing extends DamageType {
  const HugePiercing() : super(label: 'Huge Piercing', shortLabel: 'pi++');
}

class LargePiercing extends DamageType {
  const LargePiercing() : super(label: 'Large Piercing', shortLabel: 'pi+');
}

class Piercing extends DamageType {
  const Piercing() : super(label: 'Piercing', shortLabel: 'pi');
}

class SmallPiercing extends DamageType {
  const SmallPiercing() : super(label: 'Small Piercing', shortLabel: 'pi-');
}

class Toxic extends DamageType {
  const Toxic() : super(label: 'Toxic', shortLabel: 'tox');
}
