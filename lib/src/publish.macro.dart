
import 'dart:async';
import 'package:macros/macros.dart';

macro class Publish implements ClassDeclarationsMacro {
  const Publish();

  @override
  FutureOr<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    final name = clazz.identifier.name;

    // Add singleton functionality
    builder.declareInType(
      DeclarationCode.fromString(
        'static final instance = $name._();'
      ),
    );

    // Add private constructor
    builder.declareInType(
      DeclarationCode.fromString(
        '$name._();'
      ),
    );

    // Create getters for private fields
    final fields = await builder.fieldsOf(clazz);
    final privateFields = fields.where((e) => e.identifier.name.startsWith('_'));

    for (final field in privateFields) {
      final privateName = field.identifier.name;
      final publicName = field.identifier.name.substring(1);
      final type = field.type;

      builder.declareInType(
        DeclarationCode.fromParts([
          type.code,
          ' get $publicName => get($privateName);'
        ]),
      );
    }
  }
}
