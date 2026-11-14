/// Role a person had in the project. Each role has a localized label
/// (see `CreditsScreen._roleLabel`).
enum CreditRole { support }

/// One person in the credits.
final class CreditEntry {
  const CreditEntry({required this.name, required this.role});

  final String name;
  final CreditRole role;
}

/// Credits catalog. To thank someone new, add a line here.
abstract final class Credits {
  static const List<CreditEntry> people = [
    CreditEntry(name: 'Leonardo Heck', role: CreditRole.support),
  ];
}
