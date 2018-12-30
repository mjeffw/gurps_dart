import 'package:gurps_dart/src/advantages/advantage.dart';
import 'package:gurps_dart/src/trait_modifier.dart';

var expression = RegExp(r'^(.+)\((.+)\).*');
var traitExpr = RegExp(r'(.*),\s*((?:[-|+|−])*\d+)%');

class AbilityParser {
  AbilityParser(this.text);

  final String text;

  Future<Advantage> advantage() async {
    // Advantage name is before the parentheses.
    var match = expression.firstMatch(text);
    String candidate = match?.group(1);
    candidate = candidate?.trim();
    if (candidate == null) {
      return null;
    }

    // candidate might be the advantage name alone
    AdvantageBase base = await AdvantageBase.fetchByName(candidate);

    if (base != null) {
      return Advantage(base: base);
    }
    return null;
  }

  Future<List<TraitModifier>> modifiers() async {
    // Modifiers appear inside the parentheses.
    var match = expression.firstMatch(text);

    String candidate = match?.group(2);
    candidate = candidate?.trim();

    // candidate should be one or more matches of the form:
    // <name>, <optional specialization>, <percentage>%
    // Split <name>, <optional specialization and <percentage>
    var results = <TraitModifier>[];
    var matches = candidate.split(';');
    for (String string in matches) {
      var match = traitExpr.firstMatch(string.trim());
      var modifierText = match.group(1);
      var percentText = match.group(2).replaceAll('−', '-');

      // Modifier text, at this point, is either the nanme of the modifier alone,
      // or name + detail. If detail exists, break it out.
      String detail;
      var parts = modifierText.split(',');
      if (parts.length == 2) {
        detail = parts[1].trim();
        modifierText = parts[0].trim();
      }

      results.add(TraitModifier(
          name: modifierText, level: int.parse(percentText), detail: detail));
    }
    return results;
  }
}
