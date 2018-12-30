import 'package:gurps_dart/src/trait_modifier.dart';

var expression = RegExp(r'^(.+)\((.+)\).*');
var traitExpr = RegExp(r'(.*),\s*((?:[-|+|−])*\d+)%');

class AbilityParser {
  AbilityParser(this.text);

  final String text;
  String get baseName => _baseName();
  List<TraitModifier> get modifiers => _modifiers();

  String _baseName() {
    // Advantage name is before the parentheses.
    var match = expression.firstMatch(text);
    return match?.group(1)?.trim();
  }

  List<TraitModifier> _modifiers() {
    List<String> matches = _modifierDetailText();

    var results = <TraitModifier>[];
    for (String string in matches) {
      var match = traitExpr.firstMatch(string.trim());
      var modifierText = match.group(1);
      var percentText = match.group(2).replaceAll('−', '-');

      // Modifier text, at this point, is either the nanme of the modifier
      // alone, or name + detail. If detail exists, break it out.
      String detail;
      var parts = modifierText.split(',');
      if (parts.length == 2) {
        detail = parts[1].trim();
        modifierText = parts[0].trim();
      }

      results.add(TraitModifier(
          name: modifierText, percent: int.parse(percentText), detail: detail));
    }
    return results;
  }

  List<String> _modifierDetailText() {
    // Modifiers appear inside the parentheses.
    var match = expression.firstMatch(text);

    String candidate = match?.group(2);
    candidate = candidate?.trim();
    var matches = candidate.split(';');
    return matches;
  }
}
