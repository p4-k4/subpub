import 'dart:async';
import 'package:macros/macros.dart';
import 'macro_extensions.dart';

macro class Publish implements ClassDeclarationsMacro, ClassDefinitionMacro {
  const Publish();

  @override
  FutureOr<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    final name = clazz.identifier.name;

    // // Add singleton functionality
    // builder.declareInType(
    //   DeclarationCode.fromString(
    //     'static final instance = $name._();'
    //   ),
    // );
    //
    // // Add private constructor
    // builder.declareInType(
    //   DeclarationCode.fromString(
    //     '$name._();'
    //   ),
    // );

    // Create getters for private fields
    final fields = await builder.fieldsOf(clazz);
    final privateFields = fields.where((e) => e.identifier.name.startsWith('_'));

    for (final field in privateFields) {
      final privateName = field.identifier.name;
      final publicName = field.identifier.name.substring(1);

      // Check and cast the type using our extension methods
      final namedType = field.type.checkNamed(builder);
      if (namedType == null) continue;

      builder.declareInType(
        DeclarationCode.fromParts([
          'external ',
          namedType.identifier,
          if (namedType.isNullable) '?',
          ' get ',
          publicName,
          ';'
        ]),
      );
    }
  }

  @override
  FutureOr<void> buildDefinitionForClass(
    ClassDeclaration clazz,
    TypeDefinitionBuilder builder,
  ) async {
    // Get all getter methods
    final methods = await builder.methodsOf(clazz);
    final getters = methods.where((m) => m.isGetter);

    // Build the implementation for each getter
    for (final getter in getters) {
      final getterMethod = await builder.buildMethod(getter.identifier);
      final fieldName = '_${getter.identifier.name}';
      
      getterMethod.augment(
        FunctionBodyCode.fromString('=> get($fieldName);'),
      );
    }
  }
}
