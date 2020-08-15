class DamageType {
  const DamageType();

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
  const Burning();
}

class Corrosive extends DamageType {
  const Corrosive();
}

class Crushing extends DamageType {
  const Crushing();
}

class Cutting extends DamageType {
  const Cutting();
}

class Fatigue extends DamageType {
  const Fatigue();
}

class Impaling extends DamageType {
  const Impaling();
}

class HugePiercing extends DamageType {
  const HugePiercing();
}

class LargePiercing extends DamageType {
  const LargePiercing();
}

class Piercing extends DamageType {
  const Piercing();
}

class SmallPiercing extends DamageType {
  const SmallPiercing();
}

class Toxic extends DamageType {
  const Toxic();
}
