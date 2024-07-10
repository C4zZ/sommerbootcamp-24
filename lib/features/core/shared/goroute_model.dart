/// App GoRouteModel
class GoRouteModel {
  /// Pfad, kann absolut oder relative sein
  /// Für 'nested Routes' wird ein relativer Pfad angegeben
  final String path;

  /// Name der Route
  final String name;

  /// Name des Parameters ohne Doppelpunkt
  final String? paramName;

  /// Constructor
  const GoRouteModel({
    required this.path,
    required this.name,
    this.paramName,
  });

  /// Liefert den Pfad mit optionaler Parameterangabe
  String get pathWithParameter {
    if (null == paramName || true == paramName?.isEmpty) {
      return path;
    }
    return '$path/:$paramName';
  }
}
